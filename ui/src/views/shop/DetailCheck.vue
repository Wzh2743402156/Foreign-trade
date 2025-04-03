<template>
    <div class="product-page">
      <div class="page-header">
        <h2>商品管理</h2>
        <button class="btn-add">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
          添加商品
        </button>
      </div>
  
      <!-- 搜索和筛选区域 -->
      <div class="filter-container">
        <div class="search-wrapper">
          <div class="search-box">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="search-icon"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <input 
              v-model="searchQuery" 
              @keyup.enter="fetchData" 
              placeholder="搜索商品名称..." 
              class="search-input" 
            />
            <button v-if="searchQuery" @click="clearSearch" class="clear-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
          </div>
          <button @click="fetchData" class="btn-search">
            <span>搜索</span>
          </button>
        </div>
  
        <div class="category-filter">
          <div class="filter-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
            <span>筛选类别：</span>
          </div>
          <div class="category-buttons">
            <button 
              v-for="cat in uniqueCategories" 
              :key="cat" 
              class="category-button"
              :class="{ active: cat === selectedCategory }" 
              @click="selectCategory(cat)"
            >
              {{ cat }}
            </button>
            <button 
              class="reset-button" 
              @click="resetCategory"
              :class="{ 'hidden': !selectedCategory }"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
              重置筛选
            </button>
          </div>
        </div>
      </div>
  
      <!-- 数据统计 -->
      <div class="data-stats">
        <div class="stat-item">
          <div class="stat-label">总商品数</div>
          <div class="stat-value">{{ allData.length }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">当前筛选</div>
          <div class="stat-value">{{ filteredCount }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">当前页面</div>
          <div class="stat-value">{{ paginatedData.length }}</div>
        </div>
      </div>
  
      <!-- 表格区域 -->
      <div class="table-container">
        <div v-if="loading" class="loading-overlay">
          <div class="spinner"></div>
          <span>加载中...</span>
        </div>
        
        <table class="product-table" :class="{ 'loading': loading }">
          <thead>
            <tr>
              <th>商品名称</th>
              <th>类别</th>
              <th>规格</th>
              <th>库存位置</th>
              <th>商品编码</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="paginatedData.length === 0">
              <td colspan="6" class="empty-data">
                <div class="empty-content">
                  <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                  <p>暂无数据</p>
                  <button @click="resetAndFetch" class="btn-reset">重置筛选条件</button>
                </div>
              </td>
            </tr>
            <tr v-for="item in paginatedData" :key="item.id" class="data-row">
              <td>
                <div class="product-name">{{ item.name }}</div>
              </td>
              <td>
                <span class="category-tag">{{ item.category }}</span>
              </td>
              <td>{{ item.spec }}</td>
              <td>
                <div class="location-tag">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                  {{ item.location }}
                </div>
              </td>
              <td>
                <a :href="`/api/download_code/${item.product_code}`" class="download-link">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                  下载条码
                </a>
              </td>
              <td>
                <div class="action-buttons">
                  <button @click="editItem(item)" class="btn-edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                    编辑
                  </button>
                  <button @click="deleteItem(item.id)" class="btn-delete">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                    删除
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- 分页控制 -->
      <div class="pagination-container">
        <div class="page-size">
          <label>每页显示</label>
          <select v-model="pageSize" @change="handlePageSizeChange" class="page-select">
            <option :value="10">10 条</option>
            <option :value="20">20 条</option>
            <option :value="50">50 条</option>
          </select>
        </div>
  
        <div class="page-info">
          显示 {{ startItem }}-{{ endItem }} 条，共 {{ allData.length }} 条
        </div>
  
        <div class="page-buttons">
          <button 
            class="btn-page" 
            @click="goToPage(1)" 
            :disabled="currentPage === 1"
            title="首页"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="11 17 6 12 11 7"></polyline><polyline points="18 17 13 12 18 7"></polyline></svg>
          </button>
          <button 
            class="btn-page" 
            @click="prevPage" 
            :disabled="currentPage === 1"
            title="上一页"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
          </button>
          
          <template v-for="page in visiblePages" :key="page">
            <span v-if="page === '...'" class="page-ellipsis">...</span>
            <button 
              v-else 
              class="btn-page" 
              :class="{ active: currentPage === page }" 
              @click="goToPage(page)"
            >
              {{ page }}
            </button>
          </template>
          
          <button 
            class="btn-page" 
            @click="nextPage" 
            :disabled="currentPage === totalPages"
            title="下一页"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
          </button>
          <button 
            class="btn-page" 
            @click="goToPage(totalPages)" 
            :disabled="currentPage === totalPages"
            title="末页"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 17 18 12 13 7"></polyline><polyline points="6 17 11 12 6 7"></polyline></svg>
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, watch } from 'vue'
  import axios from 'axios'
  
  // 状态变量
  const allData = ref([])
  const searchQuery = ref('')
  const selectedCategory = ref('')
  const currentPage = ref(1)
  const pageSize = ref(10)
  const loading = ref(false)
  
  // 获取数据
  const fetchData = async () => {
    try {
      loading.value = true
      const shopId = localStorage.getItem('shop_id') || 1
      const res = await axios.get(`http://localhost:8080/api/shop/products?shop_id=${shopId}`)
      let list = res.data.data || []
  
      if (searchQuery.value.trim()) {
        list = list.filter(item => 
          item.name.toLowerCase().includes(searchQuery.value.toLowerCase())
        )
      }
      
      if (selectedCategory.value) {
        list = list.filter(item => item.category === selectedCategory.value)
      }
  
      allData.value = list
    } catch (error) {
      console.error('获取数据失败:', error)
    } finally {
      loading.value = false
    }
  }
  
  // 清除搜索
  const clearSearch = () => {
    searchQuery.value = ''
    fetchData()
  }
  
  // 重置所有筛选条件
  const resetAndFetch = () => {
    searchQuery.value = ''
    selectedCategory.value = ''
    currentPage.value = 1
    fetchData()
  }
  
  // 计算属性
  const uniqueCategories = computed(() => [...new Set(allData.value.map(i => i.category))])
  
  const filteredCount = computed(() => allData.value.length)
  
  const paginatedData = computed(() => {
    const start = (currentPage.value - 1) * pageSize.value
    return allData.value.slice(start, start + pageSize.value)
  })
  
  const totalPages = computed(() => Math.max(1, Math.ceil(allData.value.length / pageSize.value)))
  
  const startItem = computed(() => {
    if (allData.value.length === 0) return 0
    return (currentPage.value - 1) * pageSize.value + 1
  })
  
  const endItem = computed(() => {
    return Math.min(currentPage.value * pageSize.value, allData.value.length)
  })
  
  const visiblePages = computed(() => {
    const total = totalPages.value
    const cur = currentPage.value
    const pages = []
  
    if (total <= 5) {
      for (let i = 1; i <= total; i++) pages.push(i)
    } else {
      if (cur <= 3) {
        pages.push(1, 2, 3, 4, 5)
        if (total > 5) pages.push('...')
      } else if (cur >= total - 2) {
        if (total > 5) pages.push('...')
        pages.push(total - 4, total - 3, total - 2, total - 1, total)
      } else {
        pages.push('...', cur - 1, cur, cur + 1, '...')
      }
    }
    return pages
  })
  
  // 方法
  const selectCategory = (category) => {
    selectedCategory.value = category
    currentPage.value = 1
    fetchData()
  }
  
  const resetCategory = () => {
    selectedCategory.value = ''
    currentPage.value = 1
    fetchData()
  }
  
  const goToPage = (page) => {
    if (typeof page === 'number') currentPage.value = page
  }
  
  const prevPage = () => goToPage(currentPage.value - 1)
  const nextPage = () => goToPage(currentPage.value + 1)
  
  const handlePageSizeChange = () => {
    currentPage.value = 1
    fetchData()
  }
  
  const editItem = (item) => {
    alert('编辑功能开发中：' + item.name)
  }
  
  const deleteItem = async (id) => {
    if (confirm('确认删除该商品吗？')) {
      try {
        loading.value = true
        await axios.delete(`/api/shop/products/${id}`)
        fetchData()
      } catch (error) {
        console.error('删除失败:', error)
      } finally {
        loading.value = false
      }
    }
  }
  
  // 生命周期钩子
  onMounted(fetchData)
  watch(pageSize, () => currentPage.value = 1)
  </script>
  
  <style scoped>
  /* 基础样式 */
  .product-page {
    padding: 24px;
    background-color: #f8fafc;
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    max-width: 1200px;
    margin: 0 auto;
    font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  }
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
  }
  
  .page-header h2 {
    font-size: 22px;
    font-weight: 600;
    color: #1e293b;
    margin: 0;
  }
  
  .btn-add {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background-color: #3b82f6;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .btn-add:hover {
    background-color: #2563eb;
    transform: translateY(-1px);
  }
  
  /* 搜索和筛选区域 */
  .filter-container {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .search-wrapper {
    display: flex;
    gap: 12px;
  }
  
  .search-box {
    position: relative;
    flex: 1;
    max-width: 400px;
  }
  
  .search-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    color: #64748b;
  }
  
  .search-input {
    width: 100%;
    padding: 10px 12px 10px 40px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    color: #334155;
    background-color: white;
    transition: all 0.2s ease;
  }
  
  .search-input:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }
  
  .clear-btn {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .clear-btn:hover {
    color: #64748b;
  }
  
  .btn-search {
    padding: 10px 20px;
    background-color: #3b82f6;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .btn-search:hover {
    background-color: #2563eb;
  }
  
  .category-filter {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 12px;
  }
  
  .filter-label {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #475569;
    font-weight: 500;
    font-size: 14px;
  }
  
  .category-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .category-button {
    padding: 6px 12px;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 13px;
    color: #475569;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .category-button:hover {
    background-color: #e2e8f0;
  }
  
  .category-button.active {
    background-color: #3b82f6;
    color: white;
    border-color: #3b82f6;
    font-weight: 500;
  }
  
  .reset-button {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 6px 12px;
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 13px;
    color: #64748b;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .reset-button:hover {
    background-color: #f1f5f9;
    color: #475569;
  }
  
  .reset-button.hidden {
    display: none;
  }
  
  /* 数据统计 */
  .data-stats {
    display: flex;
    gap: 16px;
    margin-bottom: 16px;
  }
  
  .stat-item {
    background-color: white;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 12px 16px;
    min-width: 120px;
  }
  
  .stat-label {
    font-size: 13px;
    color: #64748b;
    margin-bottom: 4px;
  }
  
  .stat-value {
    font-size: 18px;
    font-weight: 600;
    color: #334155;
  }
  
  /* 表格区域 */
  .table-container {
    position: relative;
    margin-bottom: 20px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  }
  
  .loading-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.8);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 10;
  }
  
  .spinner {
    width: 30px;
    height: 30px;
    border: 3px solid #e2e8f0;
    border-top-color: #3b82f6;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 8px;
  }
  
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
  
  .product-table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    font-size: 14px;
  }
  
  .product-table.loading {
    opacity: 0.6;
  }
  
  .product-table th,
  .product-table td {
    padding: 14px 16px;
    text-align: left;
    border-bottom: 1px solid #f1f5f9;
  }
  
  .product-table th {
    background-color: #f8fafc;
    font-weight: 600;
    color: #475569;
    white-space: nowrap;
  }
  
  .product-table tbody tr {
    transition: background-color 0.2s ease;
  }
  
  .product-table tbody tr:hover {
    background-color: #f1f5f9;
  }
  
  .empty-data {
    text-align: center;
    padding: 60px 0;
  }
  
  .empty-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: #94a3b8;
  }
  
  .btn-reset {
    padding: 8px 16px;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 13px;
    color: #475569;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .btn-reset:hover {
    background-color: #e2e8f0;
  }
  
  .product-name {
    font-weight: 500;
    color: #334155;
  }
  
  .category-tag {
    display: inline-block;
    padding: 4px 8px;
    background-color: #f1f5f9;
    border-radius: 4px;
    font-size: 12px;
    color: #475569;
  }
  
  .location-tag {
    display: flex;
    align-items: center;
    gap: 4px;
    color: #64748b;
  }
  
  .download-link {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    color: #3b82f6;
    text-decoration: none;
    transition: color 0.2s ease;
  }
  
  .download-link:hover {
    color: #2563eb;
    text-decoration: underline;
  }
  
  .action-buttons {
    display: flex;
    gap: 8px;
    justify-content: center;
  }
  
  .btn-edit,
  .btn-delete {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 6px 10px;
    border-radius: 6px;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .btn-edit {
    background-color: rgba(16, 185, 129, 0.1);
    color: #10b981;
    border: 1px solid rgba(16, 185, 129, 0.2);
  }
  
  .btn-edit:hover {
    background-color: rgba(16, 185, 129, 0.2);
  }
  
  .btn-delete {
    background-color: rgba(239, 68, 68, 0.1);
    color: #ef4444;
    border: 1px solid rgba(239, 68, 68, 0.2);
  }
  
  .btn-delete:hover {
    background-color: rgba(239, 68, 68, 0.2);
  }
  
  /* 分页控制 */
  .pagination-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px;
    background-color: white;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    flex-wrap: wrap;
    gap: 16px;
  }
  
  .page-size {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #64748b;
    font-size: 14px;
  }
  
  .page-select {
    padding: 6px 10px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background-color: white;
    color: #334155;
    font-size: 14px;
    cursor: pointer;
  }
  
  .page-info {
    color: #64748b;
    font-size: 14px;
  }
  
  .page-buttons {
    display: flex;
    align-items: center;
    gap: 4px;
  }
  
  .btn-page {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 32px;
    height: 32px;
    padding: 0 8px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background-color: white;
    color: #475569;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .btn-page:hover:not(:disabled) {
    background-color: #f1f5f9;
    border-color: #cbd5e1;
  }
  
  .btn-page.active {
    background-color: #3b82f6;
    color: white;
    border-color: #3b82f6;
    font-weight: 500;
  }
  
  .btn-page:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  .page-ellipsis {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 32px;
    height: 32px;
    color: #64748b;
    font-size: 14px;
  }
  
  /* 响应式设计 */
  @media (max-width: 768px) {
    .filter-container {
      flex-direction: column;
    }
    
    .search-wrapper {
      width: 100%;
    }
    
    .search-box {
      max-width: none;
    }
    
    .data-stats {
      flex-direction: column;
    }
    
    .pagination-container {
      flex-direction: column;
      align-items: flex-start;
    }
    
    .page-buttons {
      width: 100%;
      justify-content: center;
    }
    
    .action-buttons {
      flex-direction: column;
    }
  }
  </style>