<template>
  <div class="inventory-dashboard">
    <div class="dashboard-header">
      <h2>库存管理</h2>
      <div class="date-selector">
        <span class="date-label">数据周期:</span>
        <div class="date-picker">
          <span>{{ currentDateRange }}</span>
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="calendar-icon"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
        </div>
      </div>
    </div>

    <!-- 概览卡片 -->
    <div class="summary">
      <div class="stat-card in-card">
        <div class="card-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
        </div>
        <div class="card-content">
          <div class="card-label">本周入库总数</div>
          <div class="card-value">{{ totalIn.toLocaleString() }}</div>
          <div class="card-trend positive">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
            <span>+12.5%</span>
          </div>
        </div>
      </div>
      
      <div class="stat-card out-card">
        <div class="card-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
        </div>
        <div class="card-content">
          <div class="card-label">本周出库总数</div>
          <div class="card-value">{{ totalOut.toLocaleString() }}</div>
          <div class="card-trend negative">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 18 13.5 8.5 8.5 13.5 1 6"></polyline><polyline points="17 18 23 18 23 12"></polyline></svg>
            <span>-5.2%</span>
          </div>
        </div>
      </div>
      
      <div class="stat-card balance-card">
        <div class="card-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
        </div>
        <div class="card-content">
          <div class="card-label">库存净变化</div>
          <div class="card-value">{{ (totalIn - totalOut).toLocaleString() }}</div>
          <div class="card-trend" :class="totalIn > totalOut ? 'positive' : 'negative'">
            <svg v-if="totalIn > totalOut" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 18 13.5 8.5 8.5 13.5 1 6"></polyline><polyline points="17 18 23 18 23 12"></polyline></svg>
            <span>{{ Math.abs(((totalIn - totalOut) / totalOut * 100).toFixed(1)) }}%</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 设置警戒线 -->
    <div class="alert-setting-container">
      <div class="alert-setting">
        <div class="setting-header">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
          <label>库存警戒线设置</label>
        </div>
        <div class="setting-controls">
          <input 
            v-model.number="alertLine" 
            type="number" 
            min="0"
            :class="{ 'warning': alertLine < 100 }"
          />
          <button @click="updateAlertLine" class="update-btn">
            <span>更新</span>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2v6h-6"></path><path d="M3 12a9 9 0 0 1 15-6.7L21 8"></path><path d="M3 12a9 9 0 0 0 15 6.7L21 16"></path><path d="M21 22v-6h-6"></path></svg>
          </button>
        </div>
      </div>
      
      <div class="alert-info">
        <div class="info-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
        </div>
        <span>当库存低于警戒线时，系统将自动发送通知</span>
      </div>
    </div>

    <!-- 折线图 -->
    <div class="charts-container">
      <div class="chart-wrapper">
        <div class="chart-header">
          <h3>出入库趋势图</h3>
          <div class="chart-actions">
            <button class="chart-action-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
              <span>导出</span>
            </button>
            <button class="chart-action-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
              <span>详情</span>
            </button>
          </div>
        </div>
        <div class="chart-content">
          <v-chart v-if="chartReady" class="chart" :option="chartOptions" autoresize />
          <div v-else class="chart-loading">
            <div class="spinner"></div>
            <span>加载中...</span>
          </div>
        </div>
      </div>
      
      <div class="chart-wrapper">
        <div class="chart-header">
          <h3>库存变化趋势</h3>
          <div class="chart-actions">
            <button class="chart-action-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
              <span>导出</span>
            </button>
            <button class="chart-action-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
              <span>详情</span>
            </button>
          </div>
        </div>
        <div class="chart-content">
          <v-chart v-if="chartReady" class="chart" :option="stockOptions" autoresize />
          <div v-else class="chart-loading">
            <div class="spinner"></div>
            <span>加载中...</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, computed } from 'vue'
import dayjs from 'dayjs'

// ECharts
import { use } from 'echarts/core'
import VChart from 'vue-echarts'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
  DataZoomComponent
} from 'echarts/components'

use([
  CanvasRenderer,
  LineChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
  DataZoomComponent
])

const chartOptions = ref({})
const stockOptions = ref({})
const totalIn = ref(1250)
const totalOut = ref(980)
const chartReady = ref(false)
const alertLine = ref(200)

// 计算当前日期范围
const currentDateRange = computed(() => {
  const today = dayjs()
  const startOfWeek = today.subtract(6, 'day').format('MM月DD日')
  const endOfWeek = today.format('MM月DD日')
  return `${startOfWeek} - ${endOfWeek}`
})

function updateAlertLine() {
  if (stockOptions.value.series?.length >= 2) {
    stockOptions.value.series[1].data = Array(stockOptions.value.xAxis.data.length).fill(alertLine.value)
  }
}

onMounted(async () => {
  // 模拟API调用延迟
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  // 模拟数据
  const dates = [
    '2025-03-28', '2025-03-29', '2025-03-30', 
    '2025-03-31', '2025-04-01', '2025-04-02', '2025-04-03'
  ]
  const inData = [120, 132, 101, 134, 90, 230, 210]
  const outData = [85, 96, 75, 110, 70, 190, 175]
  const stockData = [500, 535, 561, 585, 605, 645, 680]

  await nextTick()

  // 设置图表主题色
  const colors = ['#3498db', '#e74c3c', '#f1c40f', '#2ecc71']

  chartOptions.value = {
    color: colors,
    title: { 
      text: '',
      textStyle: { fontSize: 16, fontWeight: 'bold' }
    },
    tooltip: { 
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.9)',
      borderColor: '#e6e9ed',
      borderWidth: 1,
      textStyle: { color: '#333' },
      formatter: function(params) {
        let result = `<div style="font-weight:bold;margin-bottom:5px;">${params[0].axisValue}</div>`;
        params.forEach(item => {
          result += `<div style="display:flex;align-items:center;margin:5px 0;">
            <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${item.color};margin-right:5px;"></span>
            <span style="margin-right:15px;">${item.seriesName}:</span>
            <span style="font-weight:bold;">${item.value}</span>
          </div>`;
        });
        return result;
      }
    },
    legend: { 
      data: ['入库', '出库'],
      icon: 'circle',
      itemWidth: 10,
      itemHeight: 10,
      textStyle: { fontSize: 12 }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '15%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: dates.map(d => dayjs(d).format('MM-DD')),
      axisLabel: { 
        rotate: 0,
        fontSize: 12,
        color: '#666'
      },
      axisLine: {
        lineStyle: { color: '#e6e9ed' }
      },
      axisTick: { show: false }
    },
    yAxis: { 
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: {
        lineStyle: { 
          type: 'dashed',
          color: '#e6e9ed'
        }
      }
    },
    dataZoom: [{
      type: 'slider',
      start: 0,
      end: 100,
      height: 20,
      bottom: 0,
      borderColor: 'transparent',
      backgroundColor: '#f5f7fa',
      dataBackground: {
        lineStyle: { color: '#ddd' },
        areaStyle: { color: '#e2e6ee' }
      },
      fillerColor: 'rgba(52, 152, 219, 0.2)',
      handleStyle: {
        color: '#3498db',
        borderColor: '#3498db'
      }
    }],
    series: [
      { 
        name: '入库', 
        type: 'line', 
        data: inData, 
        smooth: true,
        symbol: 'emptyCircle',
        symbolSize: 6,
        lineStyle: { width: 3 },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(52, 152, 219, 0.3)' },
              { offset: 1, color: 'rgba(52, 152, 219, 0.05)' }
            ]
          }
        }
      },
      { 
        name: '出库', 
        type: 'line', 
        data: outData, 
        smooth: true,
        symbol: 'emptyCircle',
        symbolSize: 6,
        lineStyle: { width: 3 },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(231, 76, 60, 0.3)' },
              { offset: 1, color: 'rgba(231, 76, 60, 0.05)' }
            ]
          }
        }
      }
    ]
  }

  stockOptions.value = {
    color: colors,
    title: { 
      text: '',
      textStyle: { fontSize: 16, fontWeight: 'bold' }
    },
    tooltip: { 
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.9)',
      borderColor: '#e6e9ed',
      borderWidth: 1,
      textStyle: { color: '#333' },
      formatter: function(params) {
        let result = `<div style="font-weight:bold;margin-bottom:5px;">${params[0].axisValue}</div>`;
        params.forEach(item => {
          result += `<div style="display:flex;align-items:center;margin:5px 0;">
            <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${item.color};margin-right:5px;"></span>
            <span style="margin-right:15px;">${item.seriesName}:</span>
            <span style="font-weight:bold;">${item.value}</span>
          </div>`;
        });
        return result;
      }
    },
    legend: { 
      data: ['库存', '警戒线'],
      icon: 'circle',
      itemWidth: 10,
      itemHeight: 10,
      textStyle: { fontSize: 12 }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '15%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: dates.map(d => dayjs(d).format('MM-DD')),
      axisLabel: { 
        rotate: 0,
        fontSize: 12,
        color: '#666'
      },
      axisLine: {
        lineStyle: { color: '#e6e9ed' }
      },
      axisTick: { show: false }
    },
    yAxis: { 
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: {
        lineStyle: { 
          type: 'dashed',
          color: '#e6e9ed'
        }
      }
    },
    dataZoom: [{
      type: 'slider',
      start: 0,
      end: 100,
      height: 20,
      bottom: 0,
      borderColor: 'transparent',
      backgroundColor: '#f5f7fa',
      dataBackground: {
        lineStyle: { color: '#ddd' },
        areaStyle: { color: '#e2e6ee' }
      },
      fillerColor: 'rgba(241, 196, 15, 0.2)',
      handleStyle: {
        color: '#f1c40f',
        borderColor: '#f1c40f'
      }
    }],
    series: [
      {
        name: '库存',
        type: 'line',
        data: stockData,
        smooth: true,
        symbol: 'emptyCircle',
        symbolSize: 6,
        lineStyle: { width: 3 },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(241, 196, 15, 0.3)' },
              { offset: 1, color: 'rgba(241, 196, 15, 0.05)' }
            ]
          }
        }
      },
      {
        name: '警戒线',
        type: 'line',
        data: Array(dates.length).fill(alertLine.value),
        symbol: 'none',
        lineStyle: {
          color: '#e74c3c',
          type: 'dashed',
          width: 2
        }
      }
    ]
  }

  chartReady.value = true
})
</script>

<style scoped>
.inventory-dashboard {
  padding: 24px;
  background-color: #f8fafc;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  max-width: 1200px;
  margin: 0 auto;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

h2 {
  font-size: 24px;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.date-selector {
  display: flex;
  align-items: center;
  gap: 8px;
}

.date-label {
  font-size: 14px;
  color: #64748b;
}

.date-picker {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 8px 12px;
  font-size: 14px;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.date-picker:hover {
  border-color: #cbd5e1;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.calendar-icon {
  color: #64748b;
}

/* 概览卡片 */
.summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.05);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  border: 1px solid #f1f5f9;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.05), 0 2px 4px rgba(0, 0, 0, 0.05);
}

.card-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  flex-shrink: 0;
}

.in-card .card-icon {
  background: rgba(52, 152, 219, 0.1);
  color: #3498db;
}

.out-card .card-icon {
  background: rgba(231, 76, 60, 0.1);
  color: #e74c3c;
}

.balance-card .card-icon {
  background: rgba(241, 196, 15, 0.1);
  color: #f1c40f;
}

.card-content {
  flex: 1;
}

.card-label {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 4px;
}

.card-value {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 4px;
}

.card-trend {
  display: flex;
  align-items: center;
  font-size: 13px;
  font-weight: 500;
}

.card-trend.positive {
  color: #10b981;
}

.card-trend.negative {
  color: #ef4444;
}

.card-trend svg {
  margin-right: 4px;
}

/* 设置警戒线 */
.alert-setting-container {
  background: white;
  border-radius: 12px;
  padding: 16px 20px;
  margin-bottom: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  border: 1px solid #f1f5f9;
}

.alert-setting {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
}

.setting-header {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #334155;
  font-weight: 500;
}

.setting-header svg {
  color: #f59e0b;
}

.setting-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.alert-setting input {
  width: 120px;
  padding: 8px 12px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 14px;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
}

.alert-setting input:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
}

.alert-setting input.warning {
  border-color: #f59e0b;
  background-color: #fffbeb;
}

.update-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.update-btn:hover {
  background-color: #2980b9;
  transform: translateY(-1px);
}

.update-btn:active {
  transform: translateY(0);
}

.alert-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px dashed #e2e8f0;
  color: #64748b;
  font-size: 13px;
}

.info-icon {
  color: #3498db;
}

/* 折线图 */
.charts-container {
  display: grid;
  grid-template-columns: 1fr;
  gap: 24px;
}

.chart-wrapper {
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  border: 1px solid #f1f5f9;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
}

.chart-header h3 {
  font-size: 16px;
  font-weight: 600;
  color: #334155;
  margin: 0;
}

.chart-actions {
  display: flex;
  gap: 8px;
}

.chart-action-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  color: #64748b;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.chart-action-btn:hover {
  background-color: #f1f5f9;
  color: #334155;
}

.chart-content {
  padding: 16px 20px 20px;
  position: relative;
  min-height: 350px;
}

.chart {
  width: 100%;
  height: 350px;
}

.chart-loading {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: rgba(255, 255, 255, 0.8);
  color: #64748b;
  font-size: 14px;
}

.spinner {
  width: 30px;
  height: 30px;
  border: 3px solid #e2e8f0;
  border-top-color: #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 8px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* 响应式设计 */
@media (min-width: 768px) {
  .charts-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 767px) {
  .dashboard-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
  
  .summary {
    grid-template-columns: 1fr;
  }
  
  .alert-setting {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .setting-controls {
    width: 100%;
  }
  
  .alert-setting input {
    flex: 1;
  }
}
</style>