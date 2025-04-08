<template>
  <div class="space-y-6 relative">
    <!-- 加载中遮罩 -->
    <div v-if="isLoading" class="absolute inset-0 bg-white/80 backdrop-blur-sm z-50 flex items-center justify-center">
      <div class="flex flex-col items-center">
        <div class="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-blue-600 font-medium">数据加载中...</p>
      </div>
    </div>

    <!-- 查询条件区域 -->
    <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100">
      <div class="flex flex-wrap items-end gap-4">
        <!-- 标签选择 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">标签名称</label>
          <select v-model="selectedTagId" @change="fetchData"
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
            <option value="">请选择标签</option>
            <option v-for="tag in tagOptions" :key="tag.id" :value="tag.id">
              {{ tag.name }}
            </option>
          </select>
        </div>

        <!-- 时间范围 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">时间范围</label>
          <select v-model="timeRange" class="w-full rounded-md border-gray-300 shadow-sm">
            <option value="daily">日视图</option>
            <option value="monthly">月视图</option>
            <option value="quarterly">季度视图</option>
            <option value="yearly">年视图</option>
          </select>
        </div>

        <!-- 开始日期 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">开始日期</label>
          <input type="date" v-model="startDate" class="w-full rounded-md border-gray-300 shadow-sm" />
        </div>

        <!-- 结束日期 -->
        <div class="flex-1 min-w-[150px]">
          <label class="block text-sm font-medium text-gray-700 mb-1">结束日期</label>
          <input type="date" v-model="endDate" class="w-full rounded-md border-gray-300 shadow-sm" />
        </div>

        <!-- 刷新按钮 -->
        <button @click="fetchData" class="px-3 py-2 border rounded-md text-sm bg-white hover:bg-gray-50"
          :disabled="!selectedTag">
          刷新数据
        </button>
      </div>
    </div>

    <!-- 数据总览 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 flex items-center">
        📦<div class="ml-3">
          <p class="text-sm text-gray-500">总库存</p>
          <p class="text-xl font-bold">{{ formatNumber(summary.totalInventory) }}</p>
        </div>
      </div>
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 flex items-center">
        ⬆️<div class="ml-3">
          <p class="text-sm text-gray-500">入库数量</p>
          <p class="text-xl font-bold">{{ formatNumber(summary.inboundCount) }}</p>
        </div>
      </div>
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 flex items-center">
        ⬇️<div class="ml-3">
          <p class="text-sm text-gray-500">出库数量</p>
          <p class="text-xl font-bold">{{ formatNumber(summary.outboundCount) }}</p>
        </div>
      </div>
      <div class="bg-white rounded-lg shadow-md p-4 border border-gray-100 flex items-center">
        🔁<div class="ml-3">
          <p class="text-sm text-gray-500">周转率</p>
          <p class="text-xl font-bold">{{ summary.turnoverRate }}</p>
        </div>
      </div>
    </div>

    <!-- 图表和表格 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <div class="lg:col-span-2 bg-white rounded-lg shadow-md p-5 border border-gray-100">
        <canvas :id="'myChart' + selectedTagId" class="w-full h-64"></canvas> <!-- 动态生成ID -->
      </div>
      <div class="bg-white rounded-lg shadow-md p-5 border border-gray-100">
        <StatisticsTable :tableData="tableData" :timeRange="timeRange" />
      </div>
    </div>

    <!-- 类别统计 -->
    <!-- <div class="bg-white rounded-lg shadow-md p-5 border border-gray-100">
      <CategoryStatistics :categoryData="categoryData" :viewType="categoryView" />
    </div> -->
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, onActivated, onBeforeUnmount, nextTick } from 'vue'
import axios from 'axios'
// 正确的导入 Chart.js
import { Chart } from 'chart.js'
import InventoryChart from '../components/InventoryChart.vue'
import StatisticsTable from '../components/StatisticsTable.vue'
import CategoryStatistics from '../components/CategoryStatistics.vue'
import { getTagLogs, getCategoryStatistics } from '../services/tagLogService'

const isLoading = ref(false)
const chartType = ref('line')
const categoryView = ref('table')

const selectedTagId = ref('')  // 当前选中的标签 ID
const tagOptions = ref([])  // 标签选择数据
const timeRange = ref('daily')  // 时间范围
const startDate = ref('')  // 开始日期
const endDate = ref('')  // 结束日期

const selectedTag = computed(() => tagOptions.value.find(t => t.id === Number(selectedTagId.value)))

let chartInstance = null
const chartData = ref({ labels: [], datasets: [] })
const tableData = ref([])  // 表格数据
const categoryData = ref([])  // 类别统计数据
const summary = ref({
  totalInventory: 0,
  inboundCount: 0,
  outboundCount: 0,
  turnoverRate: '0%'  // 周转率
})

onMounted(() => {
  nextTick(() => {
    // 设置默认选择为日视图并加载数据
    timeRange.value = 'daily' // 确保默认是日视图
    fetchTagOptions()
  })
  setDefaultDateRange()
})

onActivated(() => {
  setDefaultDateRange()
  fetchTagOptions()
})

// 监听 timeRange 的变化
watch(timeRange, () => {
  nextTick(() => {
    updateChart()
  })
  adjustDateRangeAndRefresh()
})

onBeforeUnmount(() => {
  if (chartInstance) {
    chartInstance.destroy()
  }
})

const updateChart = () => {
  const ctx = document.getElementById('myChart' + selectedTagId.value)  // 动态获取canvas元素ID
  if (ctx) {
    if (chartInstance) {
      chartInstance.destroy()  // 销毁之前的图表实例
    }
    chartInstance = new Chart(ctx, {
      type: 'line',  // 你使用的图表类型
      data: chartData.value,
      options: {
        responsive: true,
        // 其他图表配置
      }
    })
  }
}

const setDefaultDateRange = () => {
  const today = new Date()
  const sevenDaysAgo = new Date(today)
  sevenDaysAgo.setDate(today.getDate() - 7)
  startDate.value = sevenDaysAgo.toISOString().split('T')[0]
  endDate.value = today.toISOString().split('T')[0]
}

const fetchTagOptions = async () => {
  try {
    const res = await axios.get(`http://8.130.70.249:8080/api/tags/with_alert`, { params: { shop_id: 1 } })
    if (res.data.success) {
      tagOptions.value = res.data.data
      if (tagOptions.value.length > 0) {
        // 默认选择第一个标签
        selectedTagId.value = tagOptions.value[0].id
        fetchData()
      }
    }
  } catch (error) {
    console.error('获取标签失败:', error)
  }
}

const fetchData = async () => {
  if (!selectedTag.value) return
  const tagId = selectedTag.value.id

  isLoading.value = true
  try {
    const result = await getTagLogs({
      tagId,
      startDate: startDate.value,
      endDate: endDate.value,
      timeRange: timeRange.value
    })
    if (result && result.chartData) {
      chartData.value = result.chartData
      tableData.value = result.tableData
      summary.value = result.summary
      categoryData.value = await getCategoryStatistics(tagId)
      // console.log("Data loaded successfully:", result)
      // console.log("chartInstance:", chartInstance)
    } else {
      console.error("No data returned for chart")
    }
    updateChart()
  } catch (err) {
    console.error('获取数据失败:', err)
  } finally {
    isLoading.value = false
  }
}


// 根据选中的时间范围调整开始日期并刷新
const adjustDateRangeAndRefresh = () => {
  const today = new Date(endDate.value)
  let newStartDate

  if (timeRange.value === 'monthly') {
    // 月视图：开始日期为结束日期减去半年
    newStartDate = new Date(today)
    newStartDate.setMonth(today.getMonth() - 6)
  } else if (timeRange.value === 'quarterly' || timeRange.value === 'yearly') {
    // 季度视图和年视图：开始日期为结束日期减去一年
    newStartDate = new Date(today)
    newStartDate.setFullYear(today.getFullYear() - 1)
  } else if (timeRange.value === 'daily') {
    // 日视图：开始日期为结束日期减去7天
    newStartDate = new Date(today)
    newStartDate.setDate(today.getDate() - 7)
  }

  // 确保 startDate 不为 undefined
  if (newStartDate) {
    startDate.value = newStartDate.toISOString().split('T')[0]
    fetchData()
  }
}

const formatNumber = (num) => new Intl.NumberFormat('zh-CN').format(num)
</script>
