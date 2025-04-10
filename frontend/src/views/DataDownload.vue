<template>
  <div class="space-y-6">
    <!-- 过滤器和控制面板 -->
    <div class="bg-white rounded-lg shadow-md">
      <div class="p-5">
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
import { ref, computed, onMounted, nextTick } from 'vue'
import axios from 'axios'

// 状态变量
const startDate = ref('')
const endDate = ref('')
const today = new Date().toISOString().split('T')[0]
const selectedGranularity = ref('daily')
const selectedPreset = ref('')
const previewData = ref([])
const isLoading = ref(false)
const isDownloading = ref(false)
const downloadHistory = ref([])
const tagOptions = ref([])
const selectedTagId = ref("all")

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
]

// 数据粒度选项
const granularities = [
  { label: '日数据', value: 'daily' },
  { label: '周数据', value: 'weekly' },
  { label: '月数据', value: 'monthly' },
  { label: '季度数据', value: 'quarterly' },
  { label: '年数据', value: 'yearly' }
]

// 预览列
const previewColumns = computed(() => {
  switch (selectedGranularity.value) {
    case 'daily':
      return ['日期', '入库', '出库', '净变化']
    case 'weekly':
      return ['周次', '开始日期', '结束日期', '入库', '出库', '净变化']
    case 'monthly':
      return ['月份', '入库', '出库', '净变化']
    case 'quarterly':
      return ['季度', '入库', '出库', '净变化']
    case 'yearly':
      return ['年份', '入库', '出库', '净变化']
    default:
      return ['日期', '入库', '出库', '净变化']
  }
})

// 应用预设时间范围
const applyPreset = (preset) => {
  selectedPreset.value = preset.label

  const now = new Date()
  endDate.value = now.toISOString().split('T')[0]

  if (preset.days) {
    const pastDate = new Date()
    pastDate.setDate(now.getDate() - preset.days)
    startDate.value = pastDate.toISOString().split('T')[0]
  } else if (preset.years) {
    const pastDate = new Date()
    pastDate.setFullYear(now.getFullYear() - preset.years)
    startDate.value = pastDate.toISOString().split('T')[0]
  } else if (preset.type === 'thisYearQuarterly') {
    const thisYear = now.getFullYear()
    startDate.value = `${thisYear}-01-01`
  }

  generatePreview()
}

// 初始化日期为最近7天
onMounted(() => {
  const now = new Date()
  endDate.value = now.toISOString().split('T')[0]

  const sevenDaysAgo = new Date()
  sevenDaysAgo.setDate(now.getDate() - 7)
  startDate.value = sevenDaysAgo.toISOString().split('T')[0]

  selectedPreset.value = '近7天'

  fetchTagOptions()
  generatePreview()
})

const fetchTagOptions = async () => {
  try {
    const res = await axios.get(`/api/tags/with_alert`, { params: { shop_id: 1 } })
    if (res.data.success) {
      tagOptions.value = res.data.data
      if (tagOptions.value.length > 0) {
        selectedTagId.value = "all"
        fetchData()
      }
    }
  } catch (error) {
    console.error('获取标签失败:', error)
  }
}

const fetchData = async () => {
  isLoading.value = true
  try {
    if (selectedTagId.value === "all") {
      const result = await axios.get(`/api/logs`, {
        params: {
          shop_id: 1,
          start_date: startDate.value,
          end_date: endDate.value,
          granularity: selectedGranularity.value,
        }
      })
      tableData.value = result.data.data
      summary.value = result.data.summary
    } else {
      const result = await axios.get(`/api/logs`, {
        params: {
          tag_id: selectedTagId.value,
          start_date: startDate.value,
          end_date: endDate.value,
          granularity: selectedGranularity.value,
        }
      })
      tableData.value = result.data.data
      summary.value = result.data.summary
    }
  } catch (err) {
    console.error('获取数据失败:', err)
  } finally {
    isLoading.value = false
  }
}

const generatePreview = async () => {
  if (!startDate.value || !endDate.value) {
    return
  }
  isLoading.value = true
  try {
    // 模拟API响应
    await new Promise(resolve => setTimeout(resolve, 800))
    // 生成模拟数据
    previewData.value = generateMockData()
  } catch (error) {
    console.error('Error fetching preview data:', error)
    previewData.value = []
  } finally {
    isLoading.value = false
  }
}

const generateMockData = () => {
  // Generate mock data
  return []
}

const downloadData = async () => {
  // Implement download functionality
}

</script>
