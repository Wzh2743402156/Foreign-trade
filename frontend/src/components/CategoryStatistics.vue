<template>
  <div>
    <div v-if="!categoryData || categoryData.length === 0" class="flex justify-center items-center h-40 text-gray-500">
      <div class="flex flex-col items-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-300 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" />
        </svg>
        <p>暂无数据</p>
      </div>
    </div>
    
    <div v-else>
      <!-- 表格视图 -->
      <div v-if="viewType === 'table'" class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th scope="col" class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                类别
              </th>
              <th scope="col" class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                数量
              </th>
              <th scope="col" class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                占比
              </th>
              <th scope="col" class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                分布
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="(item, index) in categoryData" :key="index" :class="index % 2 === 0 ? 'bg-white' : 'bg-gray-50'">
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-gray-900">
                {{ item.category }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm text-gray-500">
                {{ formatNumber(item.count) }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm text-gray-500">
                {{ item.percentage }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm text-gray-500">
                <div class="w-full bg-gray-200 rounded-full h-2.5">
                  <div 
                    class="h-2.5 rounded-full" 
                    :style="{ 
                      width: item.percentage,
                      backgroundColor: getColorForIndex(index)
                    }"
                  ></div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <!-- 图表视图 -->
      <div v-else-if="viewType === 'chart'" class="h-[300px]">
        <canvas ref="pieChartCanvas"></canvas>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import Chart from 'chart.js/auto';

// 定义props
const props = defineProps({
  categoryData: {
    type: Array,
    required: true,
    default: () => []
  },
  viewType: {
    type: String,
    default: 'table'
  }
});

const pieChartCanvas = ref(null);
const pieChart = ref(null);

// 颜色数组
const colors = [
  'rgba(59, 130, 246, 0.8)',  // 蓝色
  'rgba(16, 185, 129, 0.8)',  // 绿色
  'rgba(239, 68, 68, 0.8)',   // 红色
  'rgba(245, 158, 11, 0.8)',  // 黄色
  'rgba(139, 92, 246, 0.8)'   // 紫色
];

// 获取颜色
const getColorForIndex = (index) => {
  return colors[index % colors.length];
};

// 格式化数字
const formatNumber = (num) => {
  return new Intl.NumberFormat('zh-CN').format(num);
};

// 创建饼图
const createPieChart = () => {
  if (!pieChartCanvas.value || !props.categoryData || props.categoryData.length === 0) {
    return;
  }
  
  const ctx = pieChartCanvas.value.getContext('2d');
  
  // 销毁旧图表
  if (pieChart.value) {
    pieChart.value.destroy();
  }
  
  // 准备数据
  const labels = props.categoryData.map(item => item.category);
  const data = props.categoryData.map(item => item.count);
  const backgroundColors = props.categoryData.map((_, index) => getColorForIndex(index));
  
  // 创建新图表
  pieChart.value = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: labels,
      datasets: [{
        data: data,
        backgroundColor: backgroundColors,
        borderColor: 'white',
        borderWidth: 2,
        hoverOffset: 10
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'right',
          labels: {
            padding: 15,
            usePointStyle: true,
            pointStyle: 'circle',
            font: {
              size: 11
            }
          }
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
              const label = context.label || '';
              const value = context.raw;
              const percentage = context.parsed;
              const total = context.dataset.data.reduce((a, b) => a + b, 0);
              const percentageValue = ((value / total) * 100).toFixed(1);
              
              return `${label}: ${formatNumber(value)} (${percentageValue}%)`;
            }
          }
        }
      },
      cutout: '60%',
      animation: {
        animateRotate: true,
        animateScale: true,
        duration: 800,
        easing: 'easeOutQuart'
      }
    }
  });
};

// 监听视图类型变化
watch(() => props.viewType, async () => {
  if (props.viewType === 'chart') {
    await nextTick();
    createPieChart();
  }
});

// 监听数据变化
watch(() => props.categoryData, async () => {
  if (props.viewType === 'chart') {
    await nextTick();
    createPieChart();
  }
}, { deep: true });

// 组件挂载时创建图表
onMounted(async () => {
  if (props.viewType === 'chart') {
    await nextTick();
    createPieChart();
  }
});
</script>