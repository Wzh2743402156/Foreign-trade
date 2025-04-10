// 标签日志服务模块
import axios from 'axios';

/**
 * 获取标签日志数据
 * @param {Object} params - 查询参数
 * @param {number} params.tagId - 标签ID
 * @param {string} params.startDate - 开始日期 (可选)
 * @param {string} params.endDate - 结束日期 (可选)
 * @param {string} params.timeRange - 时间范围类型 (daily, monthly, quarterly, yearly)
 * @returns {Promise<Object>} 处理后的数据
 */
export async function getTagLogs(params) {
  try {
    // 调用后端API
    const response = await axios.post(`http://8.130.70.249:8080/api/taglogs`, {
      tag_id: params.tagId,
      start_date: params.startDate || '',
      end_date: params.endDate || ''
    });

    // 如果请求成功但没有数据
    if (!response.data.success || !response.data.data || response.data.data.length === 0) {
      return {
        chartData: { labels: [], datasets: [] },
        tableData: [],
        summary: {
          totalInventory: 0,
          inboundCount: 0,
          outboundCount: 0,
          turnoverRate: '0%'
        }
      };
    }

    // 处理API返回的原始数据
    const rawData = response.data.data;
    
    // 根据时间范围处理数据
    const processedData = processDataByTimeRange(rawData, params.timeRange);
    
    return processedData;
  } catch (error) {
    console.error('获取标签日志数据失败:', error);
    throw error;
  }
}

/**
 * 根据时间范围处理数据
 * @param {Array} rawData - 原始数据
 * @param {string} timeRange - 时间范围类型
 * @returns {Object} 处理后的数据
 */
function processDataByTimeRange(rawData, timeRange = 'daily') {
  // 初始化数据结构
  let labels = [];
  let inbound = [];
  let outbound = [];
  let stock = [];
  let tableData = [];

  // 根据时间范围处理数据
  switch (timeRange) {
    case 'daily':
      // 日视图 - 直接使用原始数据
      rawData.forEach(item => {
        // 格式化日期 (从 YYYY-MM-DD 到 MM/DD)
        const date = new Date(item.date);
        const formattedDate = `${date.getMonth() + 1}/${date.getDate()}`;
        
        labels.push(formattedDate);
        inbound.push(item.inbound);
        outbound.push(item.outbound);
        stock.push(item.stock);
        
        tableData.push({
          period: formattedDate,
          inbound: item.inbound,
          outbound: item.outbound,
          inventory: item.stock
        });
      });
      break;
      
    case 'monthly':
      // 月视图 - 按月聚合数据
      tableData = aggregateDataByPeriod(rawData, 'month');
      tableData.forEach(item => {
        labels.push(item.period);
        inbound.push(item.inbound);
        outbound.push(item.outbound);
        stock.push(item.inventory);
      });
      break;
      
    case 'quarterly':
      // 季度视图 - 按季度聚合数据
      tableData = aggregateDataByPeriod(rawData, 'quarter');
      tableData.forEach(item => {
        labels.push(item.period);
        inbound.push(item.inbound);
        outbound.push(item.outbound);
        stock.push(item.inventory);
      });
      break;
      
    case 'yearly':
      // 年视图 - 按年聚合数据
      tableData = aggregateDataByPeriod(rawData, 'year');
      tableData.forEach(item => {
        labels.push(item.period);
        inbound.push(item.inbound);
        outbound.push(item.outbound);
        stock.push(item.inventory);
      });
      break;
  }

  // 计算汇总数据
  const totalInbound = inbound.reduce((sum, val) => sum + val, 0);
  const totalOutbound = outbound.reduce((sum, val) => sum + val, 0);
  const lastStock = stock.length > 0 ? stock[stock.length - 1] : 0;
  
  // 计算周转率 (总出库量 / 平均库存)
  const avgStock = stock.reduce((sum, val) => sum + val, 0) / (stock.length || 1);
  const turnoverRate = avgStock > 0 ? ((totalOutbound / avgStock) * 100).toFixed(1) + '%' : '0%';

  // 构建图表数据
  const chartData = {
    labels,
    datasets: [
      {
        label: '库存',
        data: stock,
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

  // 构建汇总数据
  const summary = {
    totalInventory: lastStock,
    inboundCount: totalInbound,
    outboundCount: totalOutbound,
    turnoverRate
  };

  return {
    chartData,
    tableData,
    summary
  };
}

/**
 * 按时间周期聚合数据
 * @param {Array} data - 原始数据
 * @param {string} periodType - 周期类型 (month, quarter, year)
 * @returns {Array} 聚合后的数据
 */
function aggregateDataByPeriod(data, periodType) {
  const periodMap = new Map();
  
  data.forEach(item => {
    const date = new Date(item.date);
    let periodKey;
    
    // 根据周期类型确定周期键
    switch (periodType) {
      case 'month':
        periodKey = `${date.getFullYear()}/${date.getMonth() + 1}`;
        break;
      case 'quarter':
        const quarter = Math.floor(date.getMonth() / 3) + 1;
        periodKey = `${date.getFullYear()} Q${quarter}`;
        break;
      case 'year':
        periodKey = `${date.getFullYear()}`;
        break;
    }
    
    // 如果周期不存在，初始化
    if (!periodMap.has(periodKey)) {
      periodMap.set(periodKey, {
        period: periodKey,
        inbound: 0,
        outbound: 0,
        inventory: 0, // 将使用最后一天的库存
        dates: []
      });
    }
    
    // 累加数据
    const periodData = periodMap.get(periodKey);
    periodData.inbound += item.inbound;
    periodData.outbound += item.outbound;
    periodData.dates.push({
      date: item.date,
      stock: item.stock
    });
  });
  
  // 转换Map为数组并排序
  const result = Array.from(periodMap.values())
    .map(item => {
      // 使用周期内最后一天的库存作为周期库存
      item.dates.sort((a, b) => new Date(a.date) - new Date(b.date));
      item.inventory = item.dates[item.dates.length - 1].stock;
      delete item.dates; // 删除临时数据
      return item;
    })
    .sort((a, b) => {
      // 按周期排序
      if (periodType === 'month') {
        const [yearA, monthA] = a.period.split('/');
        const [yearB, monthB] = b.period.split('/');
        return yearA - yearB || monthA - monthB;
      } else if (periodType === 'quarter') {
        const [yearA, quarterA] = a.period.split(' ');
        const [yearB, quarterB] = b.period.split(' ');
        return yearA - yearB || quarterA.slice(1) - quarterB.slice(1);
      } else {
        return a.period - b.period;
      }
    });
  
  return result;
}

/**
 * 获取类别统计数据
 * @param {number} tagId - 标签ID
 * @returns {Promise<Array>} 类别统计数据
 */
export async function getCategoryStatistics(tagId) {
  // 这里可以调用实际的API获取类别统计数据
  // 目前使用模拟数据
  const mockCategories = [
    { category: '电子产品', count: Math.floor(Math.random() * 1000) + 500 },
    { category: '服装', count: Math.floor(Math.random() * 800) + 300 },
    { category: '家具', count: Math.floor(Math.random() * 600) + 200 },
    { category: '食品', count: Math.floor(Math.random() * 400) + 100 },
    { category: '其他', count: Math.floor(Math.random() * 200) + 50 }
  ];
  
  // 计算总数和百分比
  const total = mockCategories.reduce((sum, item) => sum + item.count, 0);
  
  return mockCategories.map(item => ({
    ...item,
    percentage: `${((item.count / total) * 100).toFixed(1)}%`
  }));
}