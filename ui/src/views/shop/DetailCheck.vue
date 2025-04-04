<template>
  <div class="product-management">
    <!-- 数据概览卡片 -->
    <div class="stats-cards">
      <div class="stat-card">
        <div class="stat-icon total">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <rect x="8" y="3" width="8" height="6" rx="1"></rect>
            <path d="M8 9h8"></path>
            <path d="M8 12h8"></path>
            <path d="M8 15h8"></path>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ allData.length }}</div>
          <div class="stat-label">总商品数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon filtered">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ filteredCount }}</div>
          <div class="stat-label">当前筛选</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon current">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="3" y1="9" x2="21" y2="9"></line>
            <line x1="9" y1="21" x2="9" y2="9"></line>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ paginatedData.length }}</div>
          <div class="stat-label">当前页面</div>
        </div>
      </div>
    </div>

    <!-- 搜索和筛选区域 -->
    <div class="filter-section">
      <div class="search-container">
        <div class="search-box">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="search-icon">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input v-model="searchQuery" @keyup.enter="fetchData" placeholder="搜索商品名称..." class="search-input" />
          <button v-if="searchQuery" @click="clearSearch" class="clear-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        <button @click="fetchData" class="btn-search">
          搜索
        </button>
      </div>

      <div class="filter-container">
        <div class="filter-label">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
          </svg>
          <span>筛选类别：</span>
        </div>
        <div class="category-tags">
          <button v-for="cat in uniqueCategories" :key="cat" class="category-tag"
            :class="{ active: cat === selectedCategory }" @click="selectCategory(cat)">
            {{ cat }}
          </button>
          <button class="reset-tag" @click="resetCategory" :class="{ 'hidden': !selectedCategory }">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
              <path d="M3 3v5h5"></path>
            </svg>
            重置筛选
          </button>
        </div>
      </div>
    </div>

    <!-- 表格区域 -->
    <div class="table-section">
      <div v-if="loading" class="loading-overlay">
        <div class="spinner"></div>
        <span>加载中...</span>
      </div>

      <div class="table-container">
        <table class="data-table" :class="{ 'loading': loading }">
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
                  <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                  </svg>
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
                <span class="category-badge">{{ item.category }}</span>
              </td>
              <td>{{ item.spec }}</td>
              <td>
                <div class="location-tag">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                    <circle cx="12" cy="10" r="3"></circle>
                  </svg>
                  {{ item.location }}
                </div>
              </td>
              <td>
                <a :href="`/api/download_code/${item.product_code}`" class="download-link">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                  </svg>
                  下载条码
                </a>
              </td>
              <td>
                <div class="action-buttons">
                  <button @click="editItem(item)" class="btn-edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                    编辑
                  </button>
                  <button @click="deleteItem(item.id)" class="btn-delete">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <polyline points="3 6 5 6 21 6"></polyline>
                      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                      <line x1="10" y1="11" x2="10" y2="17"></line>
                      <line x1="14" y1="11" x2="14" y2="17"></line>
                    </svg>
                    删除
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页控制 -->
      <div class="pagination">
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

        <div class="page-controls">
          <button class="page-btn" @click="goToPage(1)" :disabled="currentPage === 1" title="首页">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="11 17 6 12 11 7"></polyline>
              <polyline points="18 17 13 12 18 7"></polyline>
            </svg>
          </button>
          <button class="page-btn" @click="prevPage" :disabled="currentPage === 1" title="上一页">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="15 18 9 12 15 6"></polyline>
            </svg>
          </button>

          <template v-for="page in visiblePages" :key="page">
            <span v-if="page === '...'" class="page-ellipsis">...</span>
            <button v-else class="page-btn" :class="{ active: currentPage === page }" @click="goToPage(page)">
              {{ page }}
            </button>
          </template>

          <button class="page-btn" @click="nextPage" :disabled="currentPage === totalPages" title="下一页">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
          </button>
          <button class="page-btn" @click="goToPage(totalPages)" :disabled="currentPage === totalPages" title="末页">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="13 17 18 12 13 7"></polyline>
              <polyline points="6 17 11 12 6 7"></polyline>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { apiMethods } from '@/utils/api';

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
    const res = await apiMethods.get(`/shop/products?shop_id=${shopId}`);
    console.log(res.data)
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
      await apiMethods.delete(`/shop/products/${id}`);
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
.product-management {
  width: 100%;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: #1e293b;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #0f172a;
  margin: 0;
}

/* 数据概览卡片 */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background-color: white;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.stat-icon.total {
  background-color: #42b983;
}

.stat-icon.filtered {
  background-color: #3b82f6;
}

.stat-icon.current {
  background-color: #8b5cf6;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #0f172a;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 14px;
  color: #64748b;
}

/* 搜索和筛选区域 */
.filter-section {
  margin-bottom: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.search-container {
  display: flex;
  gap: 12px;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
  display: flex;
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #64748b;
}

.search-input {
  display: flex;
  flex: 1;
  width: 100%;
  padding: 10px 12px 10px 40px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  font-size: 14px;
  color: #334155;
  background-color: white;
  transition: all 0.2s ease;
  box-sizing: border-box;
}

.search-input:focus {
  outline: none;
  border-color: #42b983;
  box-shadow: 0 0 0 3px rgba(66, 185, 131, 0.1);
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
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  display: inline-block;
}

.btn-search:hover {
  background-color: #3aa876;
}

.filter-container {
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

.category-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-tag {
  padding: 6px 12px;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 13px;
  color: #475569;
  cursor: pointer;
  transition: all 0.2s ease;
}

.category-tag:hover {
  background-color: #e2e8f0;
}

.category-tag.active {
  background-color: #42b983;
  color: white;
  border-color: #42b983;
  font-weight: 500;
}

.reset-tag {
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

.reset-tag:hover {
  background-color: #f1f5f9;
  color: #475569;
}

.reset-tag.hidden {
  display: none;
}

/* 表格区域 */
.table-section {
  margin-bottom: 24px;
}

.table-container {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  background-color: white;
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
  border-top-color: #42b983;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 8px;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  font-size: 14px;
}

.data-table.loading {
  opacity: 0.6;
}

.data-table th,
.data-table td {
  padding: 14px 16px;
  text-align: left;
  border-bottom: 1px solid #f1f5f9;
}

.data-table th {
  background-color: #f8fafc;
  font-weight: 600;
  color: #475569;
  white-space: nowrap;
}

.data-table tbody tr {
  transition: background-color 0.2s ease;
}

.data-table tbody tr:hover {
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

.category-badge {
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
  color: #42b983;
  text-decoration: none;
  transition: color 0.2s ease;
}

.download-link:hover {
  color: #3aa876;
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
  background-color: rgba(66, 185, 131, 0.1);
  color: #42b983;
  border: 1px solid rgba(66, 185, 131, 0.2);
}

.btn-edit:hover {
  background-color: rgba(66, 185, 131, 0.2);
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
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  margin-top: 16px;
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

.page-controls {
  display: flex;
  align-items: center;
  gap: 4px;
}

.page-btn {
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

.page-btn:hover:not(:disabled) {
  background-color: #f1f5f9;
  border-color: #cbd5e1;
}

.page-btn.active {
  background-color: #42b983;
  color: white;
  border-color: #42b983;
  font-weight: 500;
}

.page-btn:disabled {
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
  .stats-cards {
    grid-template-columns: 1fr;
  }

  .search-container {
    display: flex;
    align-items: center;
    width: 100%;
    gap: 12px;
  }

  .search-box {
    position: relative;
    flex-grow: 1;
    min-width: 0;
  }

  .btn-search {
  padding: 10px 20px;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
  flex-shrink: 0;      /* 不允许被压缩 */
}


  .pagination {
    flex-direction: column;
    align-items: flex-start;
  }

  .page-controls {
    width: 100%;
    justify-content: center;
  }

  .action-buttons {
    flex-direction: column;
  }
}
</style>