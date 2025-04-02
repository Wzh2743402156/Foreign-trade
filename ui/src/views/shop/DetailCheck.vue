<template>
    <div class="p-4">
        <!-- 顶部搜索和分页选择 -->
        <div class="search-bar mb-4">
            <div class="flex items-center">
                <input v-model="searchQuery" @keyup.enter="fetchData" placeholder="搜索商品名..." />
                <button @click="fetchData">搜索</button>
            </div>
        </div>

        <!-- 表格区域 -->
        <table class="w-full border">
            <thead>
                <tr class="bg-gray-100 text-center">
                    <th class="p-2 border">商品ID</th>
                    <th class="p-2 border">商品名称</th>
                    <th class="p-2 border">库存</th>
                    <th class="p-2 border">操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="item in paginatedData" :key="item.id" class="text-center">
                    <td class="p-2 border">{{ item.id }}</td>
                    <td class="p-2 border">{{ item.name }}</td>
                    <td class="p-2 border">{{ item.stock }}</td>
                    <td class="p-2 border space-x-2">
                        <button @click="viewDetail(item)" class="text-blue-600 hover:underline">查看</button>
                        <button @click="deleteItem(item.id)" class="text-red-600 hover:underline">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- 底部分页区域 -->
        <div class="page-control">
            <!-- 左：每页选择 -->
            <div class="flex items-center gap-2">
                <label>每页</label>
                <select v-model="pageSize" @change="fetchData" class="border p-1 rounded text-sm">
                    <option :value="10">10 条</option>
                    <option :value="20">20 条</option>
                    <option :value="50">50 条</option>
                </select>
            </div>

            <!-- 右：分页按钮 -->
            <div class="flex items-center gap-1 mt-2 sm:mt-0">
                <button @click="toFirstPage" :disabled="currentPage === 1" class="btn-page"
                    :class="{ disabled: currentPage === 1 }">首页</button>
                <button @click="prevPage" :disabled="currentPage === 1" class="btn-page"
                    :class="{ disabled: currentPage === 1 }">上一页</button>
                <button v-for="page in visiblePages" :key="page" @click="goToPage(page)" class="btn-page"
                    :class="{ active: currentPage === page }">
                    {{ page }}
                </button>
                <button @click="nextPage" :disabled="currentPage === totalPages" class="btn-page"
                    :class="{ disabled: currentPage === totalPages }">下一页</button>
                <button @click="toLastPage" :disabled="currentPage === totalPages" class="btn-page"
                    :class="{ disabled: currentPage === totalPages }">末页</button>
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const allData = ref([])
const searchQuery = ref('')
const pageSize = ref(10)
const currentPage = ref(1)

const fetchData = async () => {
    const rawData = [
        { id: 1, name: 'abcdef', stock: 50 },
        { id: 2, name: 'ak', stock: 32 },
        { id: 3, name: '手机壳', stock: 20 },
        { id: 4, name: '键盘', stock: 70 },
        { id: 5, name: '耳机', stock: 90 },
        { id: 6, name: 'ak47', stock: 15 },
        { id: 7, name: 'adapter', stock: 18 },
        { id: 8, name: 'apple', stock: 88 },
        { id: 9, name: 'android', stock: 21 },
        { id: 10, name: 'amd', stock: 45 },
        { id: 11, name: 'acer', stock: 17 },
        { id: 12, name: 'asus', stock: 60 }
    ]

    const filtered = rawData.filter(item =>
        item.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )

    allData.value = filtered
    currentPage.value = 1 // 重置页码
}

const paginatedData = computed(() => {
    const start = (currentPage.value - 1) * pageSize.value
    return allData.value.slice(start, start + pageSize.value)
})

const totalPages = computed(() => Math.ceil(allData.value.length / pageSize.value))

const visiblePages = computed(() => {
    const range = []
    const start = Math.max(1, currentPage.value - 2)
    const end = Math.min(totalPages.value, currentPage.value + 2)

    for (let i = start; i <= end; i++) {
        range.push(i)
    }
    return range
})

const goToPage = (page) => {
    if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page
    }
}
const prevPage = () => goToPage(currentPage.value - 1)
const nextPage = () => goToPage(currentPage.value + 1)
const toFirstPage = () => goToPage(1)
const toLastPage = () => goToPage(totalPages.value)

const viewDetail = (item) => {
    alert(`查看商品：${item.name}`)
    // TODO: 可联表请求详情
}

const deleteItem = (id) => {
    allData.value = allData.value.filter(item => item.id !== id)
}

onMounted(fetchData)
</script>
<style scoped>
thead tr {
  border-bottom: 2px solid #333; /* 黑色粗线 */
}

table {
    border-collapse: collapse;
    width: 100%;
    margin-top: 10px;
    background-color: white;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

th,
td {
  padding: 12px;
  text-align: center; /* ✅ 让所有列都居中 */
  vertical-align: middle; /* ✅ 垂直居中 */
}

th {
    background-color: #f9fafb;
    color: #333;
    font-weight: 600;
    font-size: 14px;
}

tr:last-child td {
    border-bottom: none;
}

.btn-page {
    padding: 6px 10px;
    font-size: 13px;
    border: 1px solid #ccc;
    background-color: white;
    cursor: pointer;
    border-radius: 4px;
    transition: 0.2s ease;
}

.btn-page:hover:not(.disabled):not(.active) {
    background-color: #f0f0f0;
}

.btn-page.active {
    background-color: #42b983;
    color: white;
    font-weight: bold;
    border-color: #42b983;
}

.btn-page.disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* 顶部栏整体对齐 */
.search-bar {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    align-items: center;
}

.search-bar input {
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    width: 240px;
}

.search-bar button {
    background-color: #42b983;
    color: white;
    padding: 8px 16px;
    border-radius: 4px;
    margin-left: 10px;
    transition: 0.2s;
}

.search-bar button:hover {
    background-color: #36996c;
}

.page-control {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 16px;
    flex-wrap: wrap;
}
tbody tr:not(:last-child) {
  border-bottom: 1px solid #eee;
}

tbody tr:hover {
  background-color: #eef5ff; /* 蓝白色 */
}
</style>