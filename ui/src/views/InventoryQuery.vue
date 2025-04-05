<template>
  <div class="space-y-6 relative">
    <!-- 全局加载遮罩 -->
    <div v-if="isLoading" class="absolute inset-0 bg-white/80 backdrop-blur-sm z-50 flex items-center justify-center">
      <div class="flex flex-col items-center">
        <div class="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-blue-600 font-medium">数据加载中...</p>
      </div>
    </div>
    
    <!-- 过滤器和控制面板 -->
    <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100">
      <div class="flex flex-wrap items-end gap-4">
        <!-- 时间范围选择 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">时间范围</label>
          <select 
            v-model="timeRange" 
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            @change="updateChartData"
          >
            <option value="daily">日视图</option>
            <option value="monthly">月视图</option>
            <option value="quarterly">季度视图</option>
            <option value="yearly">年视图</option>
          </select>
        </div>
        
        <!-- 日期范围选择 -->
        <div v-if="timeRange === 'daily'" class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">日期范围</label>
          <select 
            v-model="dayRange" 
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            @change="updateChartData"
          >
            <option value="3">最近3天</option>
            <option value="7">最近7天</option>
            <option value="14">最近14天</option>
            <option value="30">最近30天</option>
          </select>
        </div>
        
        <!-- 月份范围选择 -->
        <div v-if="timeRange === 'monthly'" class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">月份范围</label>
          <select 
            v-model="monthRange" 
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            @change="updateChartData"
          >
            <option value="3">最近3个月</option>
            <option value="6">最近6个月</option>
            <option value="12">最近12个月</option>
          </select>
        </div>
        
        <!-- 年份范围选择 -->
        <div v-if="timeRange === 'yearly'" class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">年份范围</label>
          <select 
            v-model="yearRange" 
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            @change="updateChartData"
          >
            <option value="3">最近3年</option>
            <option value="5">最近5年</option>
            <option value="10">最近10年</option>
          </select>
        </div>
        
        <!-- 商品类别选择 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">商品类别</label>
          <select 
            v-model="selectedCategory" 
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            @change="updateChartData"
          >
            <option value="all">所有类别</option>
            <option value="electronics">电子产品</option>
            <option value="clothing">服装</option>
            <option value="furniture">家具</option>
            <option value="food">食品</option>
          </select>
        </div>
        
        <!-- 刷新按钮 -->
        <button 
          @click="updateChartData" 
          class="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          刷新数据
        </button>
      </div>
    </div>
    
    <!-- 数据概览卡片 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 transition-all duration-300 hover:shadow-lg">
        <div class="flex items-center">
          <div class="flex-shrink-0 bg-blue-100 rounded-full p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
            </svg>
          </div>
          <div class="ml-5">
            <p class="text-sm font-medium text-gray-500">总库存</p>
            <p class="text-lg font-semibold text-gray-900">{{ totalInventory }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 transition-all duration-300 hover:shadow-lg">
        <div class="flex items-center">
          <div class="flex-shrink-0 bg-green-100 rounded-full p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 11l5-5m0 0l5 5m-5-5v12" />
            </svg>
          </div>
          <div class="ml-5">
            <p class="text-sm font-medium text-gray-500">入库数量</p>
            <p class="text-lg font-semibold text-gray-900">{{ inboundCount }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 transition-all duration-300 hover:shadow-lg">
        <div class="flex items-center">
          <div class="flex-shrink-0 bg-red-100 rounded-full p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 13l-5 5m0 0l-5-5m5 5V6" />
            </svg>
          </div>
          <div class="ml-5">
            <p class="text-sm font-medium text-gray-500">出库数量</p>
            <p class="text-lg font-semibold text-gray-900">{{ outboundCount }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 transition-all duration-300 hover:shadow-lg">
        <div class="flex items-center">
          <div class="flex-shrink-0 bg-yellow-100 rounded-full p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-5">
            <p class="text-sm font-medium text-gray-500">周转率</p>
            <p class="text-lg font-semibold text-gray-900">{{ turnoverRate }}</p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 图表和表格 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- 库存趋势图 -->
      <div class="lg:col-span-2 bg-white rounded-lg shadow-md p-5 border border-gray-100">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-medium text-gray-900">库存趋势</h3>
          <div class="flex space-x-2">
            <button 
              @click="chartType = 'line'" 
              class="p-1.5 rounded-md transition-colors"
              :class="chartType === 'line' ? 'bg-blue-100 text-blue-600' : 'text-gray-500 hover:bg-gray-100'"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z" />
              </svg>
            </button>
            <button 
              @click="chartType = 'bar'" 
              class="p-1.5 rounded-md transition-colors"
              :class="chartType === 'bar' ? 'bg-blue-100 text-blue-600' : 'text-gray-500 hover:bg-gray-100'"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </button>
          </div>
        </div>
        <InventoryChart 
          :chartData="chartData" 
          :timeRange="timeRange"
          :chartType="chartType"
        />
      </div>
      
      <!-- 库存统计表 -->
      <div class="bg-white rounded-lg shadow-md p-5 border border-gray-100">
        <h3 class="text-lg font-medium text-gray-900 mb-4">库存统计</h3>
        <StatisticsTable 
          :tableData="tableData" 
          :timeRange="timeRange"
        />
      </div>
    </div>
    
    <!-- 类别统计 -->
    <div class="bg-white rounded-lg shadow-md p-5 border border-gray-100">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-medium text-gray-900">类别统计</h3>
        <div class="flex space-x-2">
          <button 
            @click="categoryView = 'table'" 
            class="p-1.5 rounded-md transition-colors"
            :class="categoryView === 'table' ? 'bg-blue-100 text-blue-600' : 'text-gray-500 hover:bg-gray-100'"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
            </svg>
          </button>
          <button 
            @click="categoryView = 'chart'" 
            class="p-1.5 rounded-md transition-colors"
            :class="categoryView === 'chart' ? 'bg-blue-100 text-blue-600' : 'text-gray-500 hover:bg-gray-100'"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" />
            </svg>
          </button>
        </div>
      </div>
      <CategoryStatistics 
        :categoryData="categoryData" 
        :viewType="categoryView"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import InventoryChart from '../components/InventoryChart.vue';
import StatisticsTable from '../components/StatisticsTable.vue';
import CategoryStatistics from '../components/CategoryStatistics.vue';

// 状态变量
const timeRange = ref('daily');
const dayRange = ref('7');
const monthRange = ref('6');
const yearRange = ref('3');
const selectedCategory = ref('all');
const isLoading = ref(false);
const chartType = ref('line');
const categoryView = ref('table');

// 初始化空数据结构
const chartData = ref({
  labels: [],
  datasets: []
});
const tableData = ref([]);
const categoryData = ref([]);

// 统计数据
const totalInventory = ref('0');
const inboundCount = ref('0');
const outboundCount = ref('0');
const turnoverRate = ref('0%');

// 初始化
onMounted(() => {
  updateChartData();
});

// 更新图表数据
const updateChartData = async () => {
  isLoading.value = true;
  
  try {
    // 模拟API响应延迟
    await new Promise(resolve => setTimeout(resolve, 500));
    
    // 生成模拟数据
    generateMockData();
    
  } catch (error) {
    console.error('Error fetching data:', error);
  } finally {
    isLoading.value = false;
  }
};

// 生成模拟数据
const generateMockData = () => {
  // 生成图表数据
  let labels = [];
  let inbound = [];
  let outbound = [];
  let inventory = [];
  
  // 根据时间范围生成不同的数据
  switch (timeRange.value) {
    case 'daily':
      // 生成日数据
      const days = parseInt(dayRange.value);
      for (let i = 0; i < days; i++) {
        const date = new Date();
        date.setDate(date.getDate() - (days - i - 1));
        const dateStr = `${date.getMonth() + 1}/${date.getDate()}`;
        
        labels.push(dateStr);
        inbound.push(Math.floor(Math.random() * 100));
        outbound.push(Math.floor(Math.random() * 80));
        
        // 确保库存不为负
        const prevInventory = i > 0 ? inventory[i - 1] : 500;
        inventory.push(prevInventory + inbound[i] - outbound[i]);
      }
      break;
      
    case 'monthly':
      // 生成月数据
      const months = parseInt(monthRange.value);
      for (let i = 0; i < months; i++) {
        const date = new Date();
        date.setMonth(date.getMonth() - (months - i - 1));
        const monthStr = `${date.getFullYear()}/${date.getMonth() + 1}`;
        
        labels.push(monthStr);
        inbound.push(Math.floor(Math.random() * 500));
        outbound.push(Math.floor(Math.random() * 400));
        
        const prevInventory = i > 0 ? inventory[i - 1] : 2000;
        inventory.push(prevInventory + inbound[i] - outbound[i]);
      }
      break;
      
    case 'quarterly':
      // 生成季度数据
      const quarters = 4;
      for (let i = 0; i < quarters; i++) {
        const quarterStr = `Q${i + 1}`;
        
        labels.push(quarterStr);
        inbound.push(Math.floor(Math.random() * 1500));
        outbound.push(Math.floor(Math.random() * 1200));
        
        const prevInventory = i > 0 ? inventory[i - 1] : 5000;
        inventory.push(prevInventory + inbound[i] - outbound[i]);
      }
      break;
      
    case 'yearly':
      // 生成年数据
      const years = parseInt(yearRange.value);
      for (let i = 0; i < years; i++) {
        const date = new Date();
        const yearStr = `${date.getFullYear() - (years - i - 1)}`;
        
        labels.push(yearStr);
        inbound.push(Math.floor(Math.random() * 5000));
        outbound.push(Math.floor(Math.random() * 4500));
        
        const prevInventory = i > 0 ? inventory[i - 1] : 10000;
        inventory.push(prevInventory + inbound[i] - outbound[i]);
      }
      break;
  }
  
  // 设置图表数据
  chartData.value = {
    labels,
    datasets: [
      {
        label: '库存',
        data: inventory,
        borderColor: '#3b82f6',
        backgroundColor: 'rgba(59, 130, 246, 0.1)',
        borderWidth: 2,
        fill: true,
        tension: 0.4
      },
      {
        label: '入库',
        data: inbound,
        borderColor: '#10b981',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        borderWidth: 2,
        fill: false,
        tension: 0.4
      },
      {
        label: '出库',
        data: outbound,
        borderColor: '#ef4444',
        backgroundColor: 'rgba(239, 68, 68, 0.1)',
        borderWidth: 2,
        fill: false,
        tension: 0.4
      }
    ]
  };
  
  // 设置表格数据
  tableData.value = labels.map((label, index) => ({
    period: label,
    inbound: inbound[index],
    outbound: outbound[index],
    inventory: inventory[index]
  }));
  
  // 设置类别数据
  categoryData.value = [
    { category: '电子产品', count: Math.floor(Math.random() * 1000) + 500, percentage: '35%' },
    { category: '服装', count: Math.floor(Math.random() * 800) + 300, percentage: '25%' },
    { category: '家具', count: Math.floor(Math.random() * 600) + 200, percentage: '20%' },
    { category: '食品', count: Math.floor(Math.random() * 400) + 100, percentage: '15%' },
    { category: '其他', count: Math.floor(Math.random() * 200) + 50, percentage: '5%' }
  ];
  
  // 更新统计数据
  totalInventory.value = inventory[inventory.length - 1].toLocaleString();
  inboundCount.value = inbound.reduce((a, b) => a + b, 0).toLocaleString();
  outboundCount.value = outbound.reduce((a, b) => a + b, 0).toLocaleString();
  
  // 计算周转率
  const avgInventory = inventory.reduce((a, b) => a + b, 0) / inventory.length;
  const totalOutbound = outbound.reduce((a, b) => a + b, 0);
  turnoverRate.value = avgInventory > 0 ? `${((totalOutbound / avgInventory) * 100).toFixed(1)}%` : '0%';
};
</script>