<template>
  <div class="relative">
    <div v-if="loading" class="absolute inset-0 flex justify-center items-center bg-white/60 backdrop-blur-[1px] z-10">
      <div class="flex flex-col items-center">
        <div class="w-10 h-10 border-3 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-2 text-sm text-blue-600">加载中...</p>
      </div>
    </div>
    
    <div v-if="!chartData || !chartData.labels || chartData.labels.length === 0" class="flex justify-center items-center h-64 text-gray-500">
      <div class="flex flex-col items-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-300 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
        <p>暂无数据</p>
      </div>
    </div>
    
    <div v-else class="h-[350px]">
      <canvas ref="chartCanvas"></canvas>
    </div>
    
    <!-- 图表控制器 -->
    <div v-if="chartData && chartData.labels && chartData.labels.length > 0" class="flex justify-between items-center mt-3">
      <div class="flex items-center space-x-4">
        <div v-for="(dataset, index) in chartData.datasets" :key="index" class="flex items-center">
          <div 
            class="w-3 h-3 rounded-full mr-1" 
            :style="{ backgroundColor: dataset.borderColor }"
          ></div>
          <span class="text-xs text-gray-600">{{ dataset.label }}</span>
        </div>
      </div>
      
      <div v-if="chartData.labels.length > 10" class="flex items-center">
        <button 
          @click="zoomOut" 
          class="p-1 text-gray-500 hover:text-blue-600 disabled:opacity-50 disabled:cursor-not-allowed"
          :disabled="zoomLevel <= 1"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM13 10H7" />
          </svg>
        </button>
        <button 
          @click="zoomIn" 
          class="p-1 text-gray-500 hover:text-blue-600 disabled:opacity-50 disabled:cursor-not-allowed"
          :disabled="zoomLevel >= maxZoomLevel"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7" />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick, onBeforeUnmount, computed } from 'vue';
import Chart from 'chart.js/auto';

// 定义props
const props = defineProps({
  chartData: {
    type: Object,
    required: true,
    default: () => ({
      labels: [],
      datasets: []
    })
  },
  timeRange: {
    type: String,
    default: 'daily'
  },
  chartType: {
    type: String,
    default: 'line'
  },
  loading: {
    type: Boolean,
    default: false
  }
});

const chartCanvas = ref(null);
const chart = ref(null);
const zoomLevel = ref(1);
const maxZoomLevel = computed(() => {
  if (!props.chartData || !props.chartData.labels) return 1;
  return Math.max(1, Math.floor(props.chartData.labels.length / 7));
});

// 缩放图表
const zoomIn = () => {
  if (zoomLevel.value < maxZoomLevel.value) {
    zoomLevel.value++;
    updateChartView();
  }
};

const zoomOut = () => {
  if (zoomLevel.value > 1) {
    zoomLevel.value--;
    updateChartView();
  }
};

// 更新图表视图
const updateChartView = () => {
  if (!chart.value || !props.chartData || !props.chartData.labels) return;
  
  const totalPoints = props.chartData.labels.length;
  const visiblePoints = Math.max(7, Math.floor(totalPoints / zoomLevel.value));
  
  chart.value.options.scales.x.min = 0;
  chart.value.options.scales.x.max = visiblePoints - 1;
  
  chart.value.update();
};

// 创建图表
const createChart = () => {
  if (!chartCanvas.value || !props.chartData || !props.chartData.labels || props.chartData.labels.length === 0) {
    return;
  }
  
  const ctx = chartCanvas.value.getContext('2d');
  
  // 销毁旧图表
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }
  
  // 深拷贝数据，避免修改原始数据
  const chartDataCopy = JSON.parse(JSON.stringify(props.chartData));
  
  // 根据图表类型调整数据集配置
  const datasets = chartDataCopy.datasets.map(dataset => {
    const newDataset = { ...dataset };
    
    if (props.chartType === 'bar') {
      // 柱状图配置
      newDataset.borderRadius = 4;
      newDataset.maxBarThickness = 40;
      newDataset.borderWidth = 0;
      newDataset.backgroundColor = 
        dataset.label === '库存' ? 'rgba(59, 130, 246, 0.7)' : 
        dataset.label === '入库' ? 'rgba(16, 185, 129, 0.7)' : 
        'rgba(239, 68, 68, 0.7)';
      
      // 删除折线图特有属性
      delete newDataset.tension;
      delete newDataset.fill;
    }
    
    return newDataset;
  });
  
  // 创建新图表
  try {
    chart.value = new Chart(ctx, {
      type: props.chartType,
      data: {
        labels: chartDataCopy.labels,
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: 'index',
          intersect: false,
        },
        plugins: {
          legend: {
            display: false // 隐藏默认图例，使用自定义图例
          },
          tooltip: {
            backgroundColor: 'rgba(255, 255, 255, 0.9)',
            titleColor: '#6b7280',
            bodyColor: '#374151',
            borderColor: '#e5e7eb',
            borderWidth: 1,
            padding: 10,
            boxPadding: 5,
            usePointStyle: true,
            callbacks: {
              label: function(context) {
                let label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                if (context.parsed.y !== null) {
                  label += new Intl.NumberFormat('zh-CN').format(context.parsed.y);
                }
                return label;
              }
            }
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            },
            ticks: {
              maxRotation: 45,
              minRotation: 45,
              font: {
                size: 10
              },
              callback: function(value, index) {
                // 当数据点过多时，只显示部分标签
                const totalLabels = chartDataCopy.labels.length;
                if (totalLabels > 14) {
                  return index % 2 === 0 ? chartDataCopy.labels[index] : '';
                }
                return chartDataCopy.labels[index];
              }
            }
          },
          y: {
            beginAtZero: true,
            grid: {
              drawBorder: false,
              color: 'rgba(226, 232, 240, 0.5)'
            },
            ticks: {
              callback: function(value) {
                return new Intl.NumberFormat('zh-CN').format(value);
              },
              font: {
                size: 10
              }
            }
          }
        },
        animation: {
          duration: 750,
          easing: 'easeOutQuart'
        }
      }
    });
    
    // 如果数据点过多，启用初始缩放
    if (chartDataCopy.labels.length > 14) {
      zoomLevel.value = 1;
      updateChartView();
    }
    
  } catch (error) {
    console.error('Error creating chart:', error);
  }
};

// 监听数据变化
watch(() => props.chartData, async (newVal) => {
  if (newVal && newVal.labels && newVal.labels.length > 0) {
    await nextTick();
    createChart();
  }
}, { deep: true });

// 监听图表类型变化
watch(() => props.chartType, async (newVal) => {
  if (props.chartData && props.chartData.labels && props.chartData.labels.length > 0) {
    await nextTick();
    createChart();
  }
});

// 组件挂载时创建图表
onMounted(async () => {
  await nextTick();
  createChart();
});

// 组件卸载前清理图表
onBeforeUnmount(() => {
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }
});
</script>