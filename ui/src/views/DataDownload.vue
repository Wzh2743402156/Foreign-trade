<template>
  <div class="space-y-6">
    <!-- 过滤器和控制面板 -->
    <div class="bg-white rounded-lg shadow-md">
      <div class="p-5">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">数据导出</h3>
        <p class="text-gray-600 mb-6">选择时间范围和数据粒度，导出库存数据报表</p>
        
        <!-- 快捷选择按钮 -->
        <div class="mb-6">
          <h4 class="text-sm font-medium text-gray-700 mb-2">快捷选择</h4>
          <div class="flex flex-wrap gap-2">
            <button 
              v-for="preset in presets" 
              :key="preset.label"
              @click="applyPreset(preset)"
              class="px-3 py-1.5 text-sm font-medium rounded-md transition-all duration-200 border"
              :class="selectedPreset === preset.label 
                ? 'bg-blue-50 text-blue-700 border-blue-200' 
                : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'"
            >
              {{ preset.label }}
            </button>
          </div>
        </div>
        
        <!-- 自定义日期范围 -->
        <div class="mb-6">
          <h4 class="text-sm font-medium text-gray-700 mb-2">自定义日期范围</h4>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">开始日期</label>
              <input 
                type="date" 
                v-model="startDate" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                :max="endDate"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">结束日期</label>
              <input 
                type="date" 
                v-model="endDate" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                :min="startDate"
                :max="today"
              />
            </div>
          </div>
        </div>
        
        <!-- 数据粒度选择 -->
        <div class="mb-6">
          <h4 class="text-sm font-medium text-gray-700 mb-2">数据粒度</h4>
          <div class="inline-flex p-1 bg-gray-100 rounded-lg">
            <button 
              v-for="granularity in granularities" 
              :key="granularity.value"
              @click="selectedGranularity = granularity.value"
              class="px-3 py-1.5 text-sm font-medium rounded-md transition-all duration-200"
              :class="selectedGranularity === granularity.value 
                ? 'bg-white text-blue-700 shadow-sm' 
                : 'text-gray-600 hover:text-gray-800'"
            >
              {{ granularity.label }}
            </button>
          </div>
        </div>
        
        <!-- 数据预览 -->
        <div class="mb-6">
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-medium text-gray-700">数据预览</h4>
            <span class="text-xs text-gray-500">显示前 10 条记录</span>
          </div>
          
          <div class="border border-gray-200 rounded-lg overflow-hidden">
            <div class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr class="bg-gray-50">
                    <th v-for="column in previewColumns" :key="column" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {{ column }}
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  <tr v-if="isLoading" class="animate-pulse">
                    <td :colspan="previewColumns.length" class="px-4 py-10 text-center">
                      <div class="flex justify-center">
                        <svg class="animate-spin h-5 w-5 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <span class="ml-2 text-sm text-gray-500">加载中...</span>
                      </div>
                    </td>
                  </tr>
                  <tr v-else-if="previewData.length === 0">
                    <td :colspan="previewColumns.length" class="px-4 py-10 text-center text-sm text-gray-500">
                      <div class="flex flex-col items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-gray-300 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        暂无数据
                      </div>
                    </td>
                  </tr>
                  <tr v-for="(item, index) in previewData" :key="index" class="hover:bg-gray-50">
                    <td v-for="column in previewColumns" :key="column" class="px-4 py-3 whitespace-nowrap text-sm text-gray-700">
                      {{ item[column.toLowerCase()] || '-' }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
        <!-- 下载按钮 -->
        <div class="flex flex-col sm:flex-row gap-3">
          <button 
            @click="generatePreview"
            class="px-4 py-2 bg-gray-100 text-gray-700 rounded-md font-medium hover:bg-gray-200 transition-colors flex items-center justify-center"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
            刷新预览
          </button>
          <button 
            @click="downloadData"
            class="px-4 py-2 bg-blue-600 text-white rounded-md font-medium hover:bg-blue-700 transition-colors flex items-center justify-center"
            :disabled="isDownloading || previewData.length === 0"
            :class="{'opacity-50 cursor-not-allowed': isDownloading || previewData.length === 0}"
          >
            <svg v-if="!isDownloading" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
            </svg>
            <svg v-else class="animate-spin h-5 w-5 mr-1.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            {{ isDownloading ? '下载中...' : '下载 CSV' }}
          </button>
        </div>
      </div>
    </div>
    
    <!-- 下载历史记录 -->
    <div class="bg-white rounded-lg shadow-md">
      <div class="p-5">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">下载历史</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead>
              <tr class="bg-gray-50">
                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">文件名</th>
                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">时间范围</th>
                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">数据粒度</th>
                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">下载时间</th>
                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-if="downloadHistory.length === 0">
                <td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">
                  暂无下载记录
                </td>
              </tr>
              <tr v-for="(item, index) in downloadHistory" :key="index" class="hover:bg-gray-50">
                <td class="px-4 py-3 whitespace-nowrap text-sm font-medium text-gray-700">{{ item.filename }}</td>
                <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-500">{{ item.dateRange }}</td>
                <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-500">{{ getGranularityLabel(item.granularity) }}</td>
                <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-500">{{ formatDate(item.downloadTime) }}</td>
                <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-500">
                  <button 
                    @click="redownload(item)"
                    class="text-blue-600 hover:text-blue-800 font-medium"
                  >
                    重新下载
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

// 状态变量
const startDate = ref('');
const endDate = ref('');
const selectedGranularity = ref('daily');
const selectedPreset = ref('');
const previewData = ref([]);
const isLoading = ref(false);
const isDownloading = ref(false);
const downloadHistory = ref([]);

// 计算今天的日期
const today = new Date().toISOString().split('T')[0];

// 初始化日期为最近7天
onMounted(() => {
  const now = new Date();
  endDate.value = now.toISOString().split('T')[0];
  
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(now.getDate() - 7);
  startDate.value = sevenDaysAgo.toISOString().split('T')[0];
  
  selectedPreset.value = '近7天';
  
  // 加载预览数据
  generatePreview();
  
  // 从本地存储加载下载历史
  const savedHistory = localStorage.getItem('downloadHistory');
  if (savedHistory) {
    downloadHistory.value = JSON.parse(savedHistory);
  }
});

// 预设时间范围
const presets = [
  { label: '近7天', days: 7 },
  { label: '近2周', days: 14 },
  { label: '近1个月', days: 30 },
  { label: '近3个月', days: 90 },
  { label: '近6个月', days: 180 },
  { label: '今年季度报表', type: 'thisYearQuarterly' },
  { label: '近2年', years: 2 },
  { label: '近3年', years: 3 },
  { label: '近5年', years: 5 }
];

// 数据粒度选项
const granularities = [
  { label: '日数据', value: 'daily' },
  { label: '周数据', value: 'weekly' },
  { label: '月数据', value: 'monthly' },
  { label: '季度数据', value: 'quarterly' },
  { label: '年数据', value: 'yearly' }
];

// 预览列
const previewColumns = computed(() => {
  switch (selectedGranularity.value) {
    case 'daily':
      return ['日期', '入库', '出库', '净变化'];
    case 'weekly':
      return ['周次', '开始日期', '结束日期', '入库', '出库', '净变化'];
    case 'monthly':
      return ['月份', '入库', '出库', '净变化'];
    case 'quarterly':
      return ['季度', '入库', '出库', '净变化'];
    case 'yearly':
      return ['年份', '入库', '出库', '净变化'];
    default:
      return ['日期', '入库', '出库', '净变化'];
  }
});

// 应用预设时间范围
const applyPreset = (preset) => {
  selectedPreset.value = preset.label;
  
  const now = new Date();
  endDate.value = now.toISOString().split('T')[0];
  
  if (preset.days) {
    // 按天数计算
    const pastDate = new Date();
    pastDate.setDate(now.getDate() - preset.days);
    startDate.value = pastDate.toISOString().split('T')[0];
  } else if (preset.years) {
    // 按年数计算
    const pastDate = new Date();
    pastDate.setFullYear(now.getFullYear() - preset.years);
    startDate.value = pastDate.toISOString().split('T')[0];
  } else if (preset.type === 'thisYearQuarterly') {
    // 今年季度报表
    const thisYear = now.getFullYear();
    startDate.value = `${thisYear}-01-01`;
  }
  
  // 更新预览
  generatePreview();
};

// 生成预览数据
const generatePreview = async () => {
  if (!startDate.value || !endDate.value) {
    return;
  }
  
  isLoading.value = true;
  
  try {
    // 这里应该调用实际的API，现在使用模拟数据
    // const response = await axios.get('http://8.130.70.249:8080/api/inventory/export/preview', {
    //   params: {
    //     startDate: startDate.value,
    //     endDate: endDate.value,
    //     granularity: selectedGranularity.value
    //   }
    // });
    
    // 模拟API响应
    await new Promise(resolve => setTimeout(resolve, 800));
    
    // 生成模拟数据
    previewData.value = generateMockData();
  } catch (error) {
    console.error('Error fetching preview data:', error);
    previewData.value = [];
  } finally {
    isLoading.value = false;
  }
};

// 生成模拟数据
const generateMockData = () => {
  const result = [];
  const start = new Date(startDate.value);
  const end = new Date(endDate.value);
  
  switch (selectedGranularity.value) {
    case 'daily':
      // 生成日数据（最多10条）
      for (let i = 0; i < 10; i++) {
        const date = new Date(start);
        date.setDate(start.getDate() + i);
        
        if (date > end) break;
        
        const inbound = Math.floor(Math.random() * 100);
        const outbound = Math.floor(Math.random() * 80);
        
        result.push({
          日期: date.toISOString().split('T')[0],
          入库: inbound,
          出库: outbound,
          净变化: inbound - outbound
        });
      }
      break;
      
    case 'weekly':
      // 生成周数据
      for (let i = 0; i < 10; i++) {
        const weekStart = new Date(start);
        weekStart.setDate(start.getDate() + i * 7);
        
        if (weekStart > end) break;
        
        const weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);
        
        if (weekEnd > end) {
          weekEnd.setTime(end.getTime());
        }
        
        const inbound = Math.floor(Math.random() * 500);
        const outbound = Math.floor(Math.random() * 400);
        
        result.push({
          周次: `第${i + 1}周`,
          开始日期: weekStart.toISOString().split('T')[0],
          结束日期: weekEnd.toISOString().split('T')[0],
          入库: inbound,
          出库: outbound,
          净变化: inbound - outbound
        });
      }
      break;
      
    case 'monthly':
      // 生成月数据
      for (let i = 0; i < 10; i++) {
        const date = new Date(start.getFullYear(), start.getMonth() + i, 1);
        
        if (date > end) break;
        
        const inbound = Math.floor(Math.random() * 2000);
        const outbound = Math.floor(Math.random() * 1800);
        
        result.push({
          月份: `${date.getFullYear()}年${date.getMonth() + 1}月`,
          入库: inbound,
          出库: outbound,
          净变化: inbound - outbound
        });
      }
      break;
      
    case 'quarterly':
      // 生成季度数据
      for (let i = 0; i < 4; i++) {
        const quarterStart = new Date(start.getFullYear(), i * 3, 1);
        
        if (quarterStart > end) break;
        
        const inbound = Math.floor(Math.random() * 5000);
        const outbound = Math.floor(Math.random() * 4500);
        
        result.push({
          季度: `${quarterStart.getFullYear()}年Q${i + 1}`,
          入库: inbound,
          出库: outbound,
          净变化: inbound - outbound
        });
      }
      break;
      
    case 'yearly':
      // 生成年数据
      for (let i = 0; i < 5; i++) {
        const year = start.getFullYear() + i;
        
        if (year > end.getFullYear()) break;
        
        const inbound = Math.floor(Math.random() * 20000);
        const outbound = Math.floor(Math.random() * 18000);
        
        result.push({
          年份: `${year}年`,
          入库: inbound,
          出库: outbound,
          净变化: inbound - outbound
        });
      }
      break;
  }
  
  return result;
};

// 下载数据
const downloadData = async () => {
  if (!startDate.value || !endDate.value || previewData.value.length === 0) {
    return;
  }
  
  isDownloading.value = true;
  
  try {
    // 在实际应用中，这里应该调用后端API下载数据
    // const response = await axios.get('http://8.130.70.249:8080/api/inventory/export', {
    //   params: {
    //     startDate: startDate.value,
    //     endDate: endDate.value,
    //     granularity: selectedGranularity.value
    //   },
    //   responseType: 'blob'
    // });
    
    // 模拟下载延迟
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // 生成CSV内容
    const csvContent = generateCSV(previewData.value);
    
    // 创建Blob对象
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    
    // 创建下载链接
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    // 设置文件名
    const granularityText = getGranularityLabel(selectedGranularity.value);
    const filename = `库存数据_${granularityText}_${startDate.value}_至_${endDate.value}.csv`;
    
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';
    
    // 添加到DOM并触发下载
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // 添加到下载历史
    const historyItem = {
      filename,
      dateRange: `${startDate.value} 至 ${endDate.value}`,
      granularity: selectedGranularity.value,
      downloadTime: new Date().toISOString(),
      params: {
        startDate: startDate.value,
        endDate: endDate.value,
        granularity: selectedGranularity.value
      }
    };
    
    downloadHistory.value = [historyItem, ...downloadHistory.value].slice(0, 10);
    localStorage.setItem('downloadHistory', JSON.stringify(downloadHistory.value));
    
  } catch (error) {
    console.error('Error downloading data:', error);
    alert('下载失败，请稍后重试');
  } finally {
    isDownloading.value = false;
  }
};

// 重新下载
const redownload = async (item) => {
  startDate.value = item.params.startDate;
  endDate.value = item.params.endDate;
  selectedGranularity.value = item.params.granularity;
  selectedPreset.value = '';
  
  await generatePreview();
  downloadData();
};

// 生成CSV内容
const generateCSV = (data) => {
  if (!data || data.length === 0) return '';
  
  // 获取列名
  const columns = Object.keys(data[0]);
  
  // 创建CSV头
  let csvContent = '\uFEFF'; // UTF-8 BOM，确保Excel正确显示中文
  csvContent += columns.join(',') + '\r\n';
  
  // 添加数据行
  data.forEach(item => {
    const row = columns.map(column => {
      // 处理包含逗号的字段
      const value = item[column];
      if (typeof value === 'string' && value.includes(',')) {
        return `"${value}"`;
      }
      return value;
    });
    csvContent += row.join(',') + '\r\n';
  });
  
  return csvContent;
};

// 获取数据粒度标签
const getGranularityLabel = (value) => {
  const granularity = granularities.find(g => g.value === value);
  return granularity ? granularity.label : value;
};

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
};
</script>