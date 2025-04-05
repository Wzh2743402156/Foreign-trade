<template>
    <div>
      <!-- 欢迎信息 -->
      <div class="bg-white rounded-lg shadow p-6 mb-6">
        <h2 class="text-2xl font-bold text-gray-900">欢迎回来，{{ userName }}</h2>
        <p class="mt-1 text-gray-500">今天是 {{ currentDate }}，以下是您的库存概览</p>
      </div>
      
      <!-- 统计卡片 -->
      <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4 mb-6">
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0 bg-blue-100 rounded-md p-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
              </svg>
            </div>
            <div class="ml-5">
              <p class="text-sm font-medium text-gray-500">总商品数</p>
              <p class="text-2xl font-semibold text-gray-900">{{ stats.totalProducts }}</p>
            </div>
          </div>
          <div class="mt-2">
            <div class="flex items-center">
              <span class="text-green-500 text-sm font-medium flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
                </svg>
                {{ stats.productIncrease }}%
              </span>
              <span class="text-gray-500 text-sm ml-2">较上月</span>
            </div>
          </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
              </svg>
            </div>
            <div class="ml-5">
              <p class="text-sm font-medium text-gray-500">总包裹数</p>
              <p class="text-2xl font-semibold text-gray-900">{{ stats.totalPackages }}</p>
            </div>
          </div>
          <div class="mt-2">
            <div class="flex items-center">
              <span class="text-green-500 text-sm font-medium flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
                </svg>
                {{ stats.packageIncrease }}%
              </span>
              <span class="text-gray-500 text-sm ml-2">较上月</span>
            </div>
          </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="ml-5">
              <p class="text-sm font-medium text-gray-500">库存预警</p>
              <p class="text-2xl font-semibold text-gray-900">{{ stats.alerts }}</p>
            </div>
          </div>
          <div class="mt-2">
            <div class="flex items-center">
              <span class="text-red-500 text-sm font-medium flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3" />
                </svg>
                {{ stats.alertIncrease }}%
              </span>
              <span class="text-gray-500 text-sm ml-2">较上月</span>
            </div>
          </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0 bg-purple-100 rounded-md p-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
            </div>
            <div class="ml-5">
              <p class="text-sm font-medium text-gray-500">本月操作</p>
              <p class="text-2xl font-semibold text-gray-900">{{ stats.monthlyOperations }}</p>
            </div>
          </div>
          <div class="mt-2">
            <div class="flex items-center">
              <span class="text-green-500 text-sm font-medium flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
                </svg>
                {{ stats.operationIncrease }}%
              </span>
              <span class="text-gray-500 text-sm ml-2">较上月</span>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 库存趋势图 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">库存趋势</h3>
          <div class="h-64">
            <inventory-chart :data="trendData" period="month" />
          </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">标签分布</h3>
          <div class="h-64">
            <category-statistics :data="tagDistribution" />
          </div>
        </div>
      </div>
      
      <!-- 最近活动 -->
      <div class="bg-white rounded-lg shadow overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">最近活动</h3>
        </div>
        <ul class="divide-y divide-gray-200">
          <li v-for="(activity, index) in recentActivities" :key="index" class="px-6 py-4">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div :class="[
                  'h-8 w-8 rounded-full flex items-center justify-center',
                  getActivityTypeClass(activity.type)
                ]">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getActivityTypeIcon(activity.type)" />
                  </svg>
                </div>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-900">{{ activity.description }}</p>
                <p class="text-sm text-gray-500">
                  {{ activity.user }} · {{ activity.time }}
                </p>
              </div>
            </div>
          </li>
        </ul>
        <div class="px-6 py-4 border-t border-gray-200 bg-gray-50">
          <router-link to="/logs" class="text-sm font-medium text-blue-600 hover:text-blue-500">
            查看所有活动
          </router-link>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  import InventoryChart from '../components/InventoryChart.vue';
  import CategoryStatistics from '../components/CategoryStatistics.vue';
  
  // 获取当前用户
  const user = computed(() => {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  });
  
  const userName = computed(() => {
    return user.value ? user.value.name : '用户';
  });
  
  // 当前日期
  const currentDate = computed(() => {
    const now = new Date();
    return now.toLocaleDateString('zh-CN', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      weekday: 'long'
    });
  });
  
  // 统计数据
  const stats = ref({
    totalProducts: 0,
    productIncrease: 0,
    totalPackages: 0,
    packageIncrease: 0,
    alerts: 0,
    alertIncrease: 0,
    monthlyOperations: 0,
    operationIncrease: 0
  });
  
  // 趋势数据
  const trendData = ref([]);
  
  // 标签分布
  const tagDistribution = ref([]);
  
  // 最近活动
  const recentActivities = ref([]);
  
  // 生命周期钩子
  onMounted(async () => {
    // 模拟API调用
    await loadDashboardData();
  });
  
  // 方法
  async function loadDashboardData() {
    // 模拟API延迟
    await new Promise(resolve => setTimeout(resolve, 500));
    
    // 模拟统计数据
    stats.value = {
      totalProducts: 1248,
      productIncrease: 12.5,
      totalPackages: 356,
      packageIncrease: 8.3,
      alerts: 24,
      alertIncrease: 15.2,
      monthlyOperations: 843,
      operationIncrease: 5.7
    };
    
    // 模拟趋势数据
    const months = ['1月', '2月', '3月', '4月', '5月', '6月'];
    trendData.value = months.map((month, index) => {
      const baseValue = 500 + Math.floor(Math.random() * 300);
      const inbound = baseValue + Math.floor(Math.random() * 100);
      const outbound = baseValue - Math.floor(Math.random() * 100);
      
      return {
        period: month,
        inbound: inbound,
        outbound: outbound,
        stock: inbound - outbound
      };
    });
    
    // 模拟标签分布
    tagDistribution.value = [
      { category: '电子产品', count: 450, percentage: 36 },
      { category: '家具', count: 250, percentage: 20 },
      { category: '服装', count: 350, percentage: 28 },
      { category: '食品', count: 120, percentage: 9.6 },
      { category: '玩具', count: 80, percentage: 6.4 }
    ];
    
    // 模拟最近活动
    recentActivities.value = [
      { 
        type: 'inbound', 
        description: '入库操作：50件电子产品入库', 
        user: '张三', 
        time: '今天 10:30' 
      },
      { 
        type: 'outbound', 
        description: '出库操作：30件服装出库', 
        user: '李四', 
        time: '今天 09:15' 
      },
      { 
        type: 'alert', 
        description: '库存预警：食品库存低于警戒线', 
        user: '系统', 
        time: '昨天 16:42' 
      },
      { 
        type: 'update', 
        description: '更新操作：更新了10件商品的信息', 
        user: '王五', 
        time: '昨天 14:20' 
      },
      { 
        type: 'create', 
        description: '创建操作：新增了5个包裹', 
        user: '赵六', 
        time: '前天 11:05' 
      }
    ];
  }
  
  function getActivityTypeClass(type) {
    switch (type) {
      case 'inbound': return 'bg-green-100 text-green-600';
      case 'outbound': return 'bg-blue-100 text-blue-600';
      case 'alert': return 'bg-red-100 text-red-600';
      case 'update': return 'bg-yellow-100 text-yellow-600';
      case 'create': return 'bg-purple-100 text-purple-600';
      default: return 'bg-gray-100 text-gray-600';
    }
  }
  
  function getActivityTypeIcon(type) {
    switch (type) {
      case 'inbound': return 'M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12';
      case 'outbound': return 'M3 4h13M3 8h9m-9 4h9m5-4v12m0 0l-4-4m4 4l4-4';
      case 'alert': return 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z';
      case 'update': return 'M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15';
      case 'create': return 'M12 4v16m8-8H4';
      default: return 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2';
    }
  }
  </script>