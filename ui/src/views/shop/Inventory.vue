<template>
  <div class="inventory-dashboard">
    <h2>库存管理</h2>

    <!-- 概览卡片 -->
    <div class="summary">
      <div class="card">本周入库总数：{{ totalIn }}</div>
      <div class="card">本周出库总数：{{ totalOut }}</div>
    </div>

    <!-- 设置警戒线 -->
    <div class="alert-setting">
      <label>库存警戒线：</label>
      <input v-model.number="alertLine" type="number" />
      <button @click="updateAlertLine">更新</button>
    </div>

    <!-- 出入库折线图 -->
    <v-chart v-if="chartReady" class="chart" :option="chartOptions" autoresize />
    <v-chart v-if="chartReady" class="chart" :option="stockOptions" autoresize />

    <!-- 库存表格 -->
    <table>
      <thead>
        <tr>
          <th>商品 ID</th>
          <th>当前库存</th>
          <th>累计入库</th>
          <th>累计出库</th>
          <th>更新时间</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in inventory" :key="item.id">
          <td>{{ item.product_id }}</td>
          <td>{{ item.current_quantity }}</td>
          <td>{{ item.inbound_total }}</td>
          <td>{{ item.outbound_total }}</td>
          <td>{{ item.updated_at }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'
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

const inventory = ref([])
const chartOptions = ref({})
const stockOptions = ref({})
const totalIn = ref(0)
const totalOut = ref(0)
const chartReady = ref(false)

const alertLine = ref(200) // 默认警戒线

function updateAlertLine() {
  // 更新库存图中的警戒线
  if (stockOptions.value.series?.length >= 2) {
    stockOptions.value.series[1].data = Array(stockOptions.value.xAxis.data.length).fill(alertLine.value)
  }
}

onMounted(async () => {
  const shopId = localStorage.getItem('shop_id')

  const invRes = await axios.get(`http://localhost:8080/api/shop/inventory?shop_id=${shopId}`)
  inventory.value = invRes.data.data

  const statRes = await axios.get(`http://localhost:8080/api/shop/stats?shop_id=${shopId}`)
  const stats = statRes.data.data

  const dates = stats.map(s => dayjs(s.date).format('YYYY-MM-DD'))
  const inData = stats.map(s => s.total_in)
  const outData = stats.map(s => s.total_out)
  const stockData = stats.map(s => s.stock)

  totalIn.value = inData.reduce((a, b) => a + b, 0)
  totalOut.value = outData.reduce((a, b) => a + b, 0)

  await nextTick()

  chartOptions.value = {
    title: { text: '出入库趋势图' },
    tooltip: { trigger: 'axis' },
    legend: { data: ['入库', '出库'] },
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: { rotate: 30 }
    },
    yAxis: { type: 'value' },
    dataZoom: [{ type: 'slider', start: 0, end: 100 }],
    series: [
      { name: '入库', type: 'line', data: inData, smooth: true },
      { name: '出库', type: 'line', data: outData, smooth: true }
    ]
  }

  stockOptions.value = {
    title: { text: '库存变化趋势' },
    tooltip: { trigger: 'axis' },
    legend: { data: ['库存', '警戒线'] },
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: { rotate: 30 }
    },
    yAxis: { type: 'value' },
    dataZoom: [{ type: 'slider', start: 0, end: 100 }],
    series: [
      {
        name: '库存',
        type: 'line',
        data: stockData,
        smooth: true,
        itemStyle: { color: '#f1c40f' } // 黄色
      },
      {
        name: '警戒线',
        type: 'line',
        data: Array(dates.length).fill(alertLine.value),
        lineStyle: {
          color: 'red',
          type: 'dashed'
        },
        showSymbol: false
      }
    ]
  }

  chartReady.value = true
})
</script>

<style scoped>
.inventory-dashboard {
  padding: 20px;
}

.summary {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.card {
  background: #f0f9eb;
  padding: 16px;
  border-left: 5px solid #67c23a;
  border-radius: 8px;
  font-weight: bold;
  min-width: 150px;
}

.alert-setting {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.alert-setting input {
  width: 100px;
  padding: 5px;
}
.alert-setting button {
  padding: 6px 12px;
  background-color: #67c23a;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.chart {
  width: 100%;
  height: 300px;
  margin-bottom: 30px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: center;
}
</style>
