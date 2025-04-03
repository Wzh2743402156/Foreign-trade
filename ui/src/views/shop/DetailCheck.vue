<template>
    <div class="p-4">
        <!-- 搜索栏 -->
        <div class="category-bar">
            <!-- 左侧：搜索栏 -->
            <div class="flex items-center gap-2">
                <input v-model="searchQuery" @keyup.enter="fetchData" placeholder="搜索商品名称..." class="search-input" />
                <button @click="fetchData" class="btn-search">搜索</button>
            </div>

            <!-- 右侧：筛选类别 -->
            <div class="flex gap-2 flex-wrap items-center">
                <span class="text-gray-700 font-medium">筛选类别：</span>
                <button v-for="cat in uniqueCategories" :key="cat" class="category-button"
                    :class="{ active: cat === selectedCategory }" @click="selectCategory(cat)">
                    {{ cat }}
                </button>
                <button class="reset-button" @click="resetCategory">全部</button>
            </div>
        </div>


        <!-- 表格 -->
        <table class="product-table">
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
                <tr v-for="item in paginatedData" :key="item.id">
                    <td>{{ item.name }}</td>
                    <td>{{ item.category }}</td>
                    <td>{{ item.spec }}</td>
                    <td>{{ item.location }}</td>
                    <td><a :href="`/api/download_code/${item.product_code}`" class="text-blue-600 underline">下载</a></td>
                    <td>
                        <button @click="editItem(item)" class="text-green-600 hover:underline">编辑</button>
                        <button @click="deleteItem(item.id)" class="text-red-600 hover:underline ml-2">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- 分页控制：左侧分页条数 + 右侧分页按钮 -->
        <div class="page-control">
            <div class="page-size">
                <label class="text-sm text-gray-700 mr-2">每页</label>
                <select v-model="pageSize" @change="fetchData" class="page-select">
                    <option :value="10">10 条</option>
                    <option :value="20">20 条</option>
                    <option :value="50">50 条</option>
                </select>
            </div>

            <div class="page-btns">
                <button class="btn-page" @click="goToPage(1)" :disabled="currentPage === 1">首页</button>
                <button class="btn-page" @click="prevPage" :disabled="currentPage === 1">上一页</button>
                <template v-for="page in visiblePages" :key="page">
                    <span v-if="page === '...'" class="btn-page disabled">...</span>
                    <button v-else class="btn-page" :class="{ active: currentPage === page }" @click="goToPage(page)">
                        {{ page }}
                    </button>
                </template>
                <button class="btn-page" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
                <button class="btn-page" @click="goToPage(totalPages)"
                    :disabled="currentPage === totalPages">末页</button>
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import axios from 'axios'

const allData = ref([])
const searchQuery = ref('')
const selectedCategory = ref('')
const currentPage = ref(1)
const pageSize = ref(10)

const fetchData = async () => {
    const shopId = localStorage.getItem('shop_id') || 1
    const res = await axios.get(`http://localhost:8080/api/shop/products?shop_id=${shopId}`)
    let list = res.data.data

    if (searchQuery.value.trim()) {
        list = list.filter(item => item.name.toLowerCase().includes(searchQuery.value.toLowerCase()))
    }
    if (selectedCategory.value) {
        list = list.filter(item => item.category === selectedCategory.value)
    }

    allData.value = list
}

const uniqueCategories = computed(() => [...new Set(allData.value.map(i => i.category))])
const selectCategory = (content) => {
    selectedCategory.value = content
    currentPage.value = 1
    fetchData()
}
const resetCategory = () => {
    selectedCategory.value = ''
    currentPage.value = 1
    fetchData()
}

const paginatedData = computed(() => {
    const start = (currentPage.value - 1) * pageSize.value
    return allData.value.slice(start, start + pageSize.value)
})

const totalPages = computed(() => Math.ceil(allData.value.length / pageSize.value))

const visiblePages = computed(() => {
    const total = totalPages.value
    const cur = currentPage.value
    const pages = []

    if (total <= 5) {
        for (let i = 1; i <= total; i++) pages.push(i)
    } else {
        if (cur <= 3) {
            pages.push(1, 2, 3, 4, 5, '...')
        } else if (cur >= total - 2) {
            pages.push('...', total - 4, total - 3, total - 2, total - 1, total)
        } else {
            pages.push('...', cur - 2, cur - 1, cur, cur + 1, cur + 2, '...')
        }
    }
    return pages
})

const goToPage = (p) => {
    if (typeof p === 'number') currentPage.value = p
}
const prevPage = () => goToPage(currentPage.value - 1)
const nextPage = () => goToPage(currentPage.value + 1)
const editItem = (item) => alert('编辑功能开发中：' + item.name)
const deleteItem = async (id) => {
    if (confirm('确认删除该商品吗？')) {
        await axios.delete(`/api/shop/products/${id}`)
        fetchData()
    }
}

onMounted(fetchData)
watch(pageSize, () => currentPage.value = 1)
</script>


<style scoped>
/* 输入框样式 */
.search-input {
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
    width: 240px;
    font-size: 14px;
}

/* 搜索按钮 */
.btn-search {
    background-color: #42b983;
    color: white;
    padding: 8px 16px;
    border-radius: 6px;
    transition: 0.2s ease;
    font-size: 14px;
}

.btn-search:hover {
    background-color: #36996c;
}

/* 表格区域 */
.product-table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    font-size: 14px;
}

.product-table th,
.product-table td {
    padding: 12px;
    text-align: center;
    border: 1px solid #f0f0f0;
}

.product-table thead {
    background-color: #f9fafb;
    font-weight: 600;
    color: #333;
}

.product-table tbody tr:hover {
    background-color: #eef5ff;
}

/* 类别筛选按钮 */
.category-button {
    padding: 6px 12px;
    background: #f0f0f0;
    border-radius: 6px;
    font-size: 13px;
    cursor: pointer;
    border: 1px solid transparent;
    transition: 0.2s ease;
}

.category-button:hover {
    background: #e2e8f0;
}

.category-button.active {
    background: #42b983;
    color: white;
    font-weight: bold;
    border-color: #42b983;
}

.reset-button {
    color: #666;
    font-size: 13px;
    cursor: pointer;
    text-decoration: underline;
}

/* 分页控制整体区域 */
.page-control {
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 12px 16px;
    margin-top: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

/* 分页下拉区 */
.page-size {
    display: flex;
    align-items: center;
    gap: 8px;
}

.page-select {
    min-width: 90px;
    padding: 6px 10px;
    font-size: 14px;
    border-radius: 6px;
    border: 1px solid #d1d5db;
    background-color: white;
    color: #333;
}

/* 分页按钮组 */
.page-btns {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    justify-content: flex-end;
}

/* 分页按钮样式 */
.btn-page {
    padding: 6px 12px;
    font-size: 13px;
    border: 1px solid #d0d7de;
    background-color: white;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-page:hover:not(.disabled):not(.active) {
    background-color: #f3f4f6;
    border-color: #b5b5b5;
}

.btn-page.active {
    background-color: #42b983;
    color: white;
    border-color: #42b983;
    font-weight: bold;
}

.btn-page.disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* 垂直对齐统一 */
.flex-center {
    display: flex;
    align-items: center;
}

/* 响应式布局优化 */
@media (max-width: 640px) {
    .page-control {
        flex-direction: column;
        align-items: flex-start;
    }

    .page-btns {
        justify-content: center;
        width: 100%;
    }
}

/* 筛选栏对齐搜索框 */
.category-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 10px;
    margin-bottom: 16px;
    margin-top: -8px;
    padding-left: 2px;
}
</style>
