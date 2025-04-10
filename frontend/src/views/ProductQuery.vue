<template>
  <div>
    <!-- 搜索区域 -->
    <div class="bg-white rounded-2xl shadow mb-6 p-6">
      <div class="flex flex-wrap gap-4 items-center">
        <select v-model="searchField" @change="onSearch" class="w-40 border rounded-xl px-4 py-2 text-sm shadow-sm">
          <option value="name">商品名称</option>
          <option value="specification">规格</option>
          <option value="tag">标签</option>
        </select>
        <input v-model="keyword" type="text" placeholder="请输入关键词..."
          class="flex-1 border border-gray-300 rounded-xl px-4 py-2 text-sm shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500" />
        <select v-model="filters.status" class="w-44 border rounded-xl px-4 py-2 text-sm shadow-sm">
          <option value="">所有状态</option>
          <option value="1">入工厂</option>
          <option value="2">出工厂</option>
          <option value="3">入商店</option>
          <option value="4">出商店</option>
        </select>
        <select v-model="filters.shop_id" class="w-44 border rounded-xl px-4 py-2 text-sm shadow-sm">
          <option value="">所有店铺</option>
          <option v-for="shop in shops" :key="shop.id" :value="shop.id">{{ shop.name }}</option>
        </select>
        <select v-model="filters.factory_id" class="w-44 border rounded-xl px-4 py-2 text-sm shadow-sm">
          <option value="">所有工厂</option>
          <option v-for="factory in factories" :key="factory.id" :value="factory.id">{{ factory.name }}</option>
        </select>
        <select v-model="pageSize" @change="goToPage(1)" class="w-44 border rounded-xl px-4 py-2 text-sm shadow-sm">
          <option :value="10">每页 10 条</option>
          <option :value="20">每页 20 条</option>
          <option :value="50">每页 50 条</option>
        </select>
        <button @click="onSearch"
          class="bg-blue-600 text-white px-5 py-2 rounded-xl hover:bg-blue-700 text-sm shadow">搜索</button>
      </div>
    </div>

    <!-- 商品列表 -->
    <div class="bg-white rounded-2xl shadow overflow-x-auto">
      <table class="min-w-full text-sm">
        <thead class="bg-gray-100 text-gray-700 text-sm uppercase">
          <tr>
            <th class="px-5 py-3 text-left">商品名称</th>
            <th class="px-5 py-3 text-left">规格</th>
            <th class="px-5 py-3 text-left">状态</th>
            <th class="px-5 py-3 text-left">标签</th>
            <th class="px-5 py-3 text-left">所属店铺</th>
            <th class="px-5 py-3 text-left">所属工厂</th>
            <th class="px-5 py-3 text-left">备注</th>
            <th class="px-5 py-3 text-left">操作</th>
          </tr>
        </thead>
        <tbody class="text-gray-800 divide-y divide-gray-100">
          <tr v-for="item in products" :key="item.id" class="hover:bg-gray-50">
            <td class="px-5 py-3 font-medium">{{ item.name }}</td>
            <td class="px-5 py-3">{{ item.specification }}</td>
            <td class="px-5 py-3">
              <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClassMap[item.status]">
                {{ getStatusText(item.status) }}
              </span>
            </td>
            <td class="px-5 py-3">
              <span v-for="(tagName, index) in (item.tag_names || []).slice(0, 3)" :key="index"
                class="inline-block bg-blue-100 text-blue-800 rounded-full px-3 py-1 mr-1 mb-1 text-xs">
                {{ tagName }}
              </span>

              <span v-if="(item.tag_names?.length || 0) > 3" @click="viewProduct(item)"
                class="inline-block bg-gray-200 text-gray-700 rounded-full px-2 py-1 text-xs cursor-pointer hover:bg-gray-300 transition">
                +{{ item.tag_names.length - 3 }} 查看全部
              </span>
            </td>

            <td class="px-5 py-3">{{ item.shop_name || getShopName(item.shop_id) }}</td>
            <td class="px-5 py-3">{{ item.factory_name || getFactoryName(item.factory_id) }}</td>
            <td class="px-5 py-3 text-gray-500">{{ item.remark }}</td>
            <td class="px-5 py-3 flex gap-2">
              <button
                class="px-3 py-1 text-xs rounded-lg border border-blue-500 text-blue-600 hover:bg-blue-100 transition"
                @click="viewProduct(item)">
                查看详情
              </button>
              <button
                class="px-3 py-1 text-xs rounded-lg border border-indigo-500 text-indigo-600 hover:bg-indigo-100 transition"
                @click="openEditModal(item)">
                编辑标签
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 分页控件 -->
    <div class="px-4 py-6 flex items-center justify-between border-t border-gray-200">
      <p class="text-sm text-gray-700">
        当前第 <strong>{{ currentPage }}</strong> 页，共 <strong>{{ totalPages }}</strong> 页，合计 <strong>{{ total }}</strong>
        条记录
      </p>
      <div class="flex space-x-1">
        <button @click="goToPage(1)" :disabled="currentPage === 1" class="px-3 py-1 border rounded-xl">首页</button>
        <button @click="goToPage(currentPage - 1)" :disabled="currentPage === 1"
          class="px-3 py-1 border rounded-xl">上一页</button>

        <span v-if="pageRange[0] > 1">...</span>
        <button v-for="page in pageRange" :key="page" @click="goToPage(page)"
          class="px-4 py-1 rounded-xl border text-sm font-medium"
          :class="{ 'bg-blue-600 text-white': page === currentPage }">
          {{ page }}
        </button>
        <span v-if="pageRange[pageRange.length - 1] < totalPages">...</span>

        <button @click="goToPage(currentPage + 1)" :disabled="currentPage === totalPages"
          class="px-3 py-1 border rounded-xl">下一页</button>
        <button @click="goToPage(totalPages)" :disabled="currentPage === totalPages"
          class="px-3 py-1 border rounded-xl">尾页</button>
      </div>
    </div>

    <!-- 查看商品详情弹窗 -->
    <div v-if="showDetailModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
      <div class="bg-white rounded-xl p-6 shadow-xl w-full max-w-md">
        <div class="text-lg font-semibold mb-4">商品详情</div>
        <div class="space-y-2 text-sm text-gray-700">
          <p><strong>商品编号：</strong>{{ selectedProduct.code }}</p>
          <p><strong>商品名称：</strong>{{ selectedProduct.name }}</p>
          <p><strong>规格：</strong>{{ selectedProduct.specification }}</p>
          <p><strong>状态：</strong>{{ getStatusText(selectedProduct.status) }}</p>
          <p><strong>标签：</strong>
            <span v-for="tag in selectedProduct.tag_names || []" :key="tag"
              class="inline-block bg-blue-100 text-blue-800 rounded-full px-2 py-1 mr-1 text-xs">
              {{ tag }}
            </span>
          </p>
          <p><strong>所属店铺：</strong>{{ selectedProduct.shop_name || getShopName(selectedProduct.shop_id) }}</p>
          <p><strong>所属工厂：</strong>{{ selectedProduct.factory_name || getFactoryName(selectedProduct.factory_id) }}</p>
          <p><strong>备注：</strong>{{ selectedProduct.remark }}</p>
        </div>
        <div class="mt-6 text-right">
          <button @click="showDetailModal = false"
            class="bg-gray-100 hover:bg-gray-200 text-sm px-4 py-2 rounded-xl">关闭</button>
        </div>
      </div>
    </div>
    <!-- 编辑商品弹窗 -->
    <div v-if="showEditModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
      <div class="bg-white rounded-xl p-6 shadow-xl w-full max-w-xl">
        <div class="text-lg font-semibold mb-4">编辑商品</div>

        <div class="grid grid-cols-2 gap-4 text-sm text-gray-700">
          <div>
            <label class="block mb-1 font-medium">商品名称</label>
            <input v-model="editForm.name" type="text" class="w-full border rounded px-3 py-2" />
          </div>

          <div>
            <label class="block mb-1 font-medium">规格</label>
            <input v-model="editForm.specification" type="text" class="w-full border rounded px-3 py-2" />
          </div>

          <div>
            <label class="block mb-1 font-medium">状态</label>
            <input type="text" class="w-full border rounded px-3 py-2 bg-gray-100 cursor-not-allowed text-gray-700"
              :value="getStatusText(editForm.status)" readonly />
          </div>


          <div>
            <label class="block mb-1 font-medium">备注</label>
            <input v-model="editForm.remark" type="text" class="w-full border rounded px-3 py-2" />
          </div>

          <div class="col-span-2">
            <label class="block mb-1 font-medium">标签</label>
            <div v-if="tagLoading" class="text-gray-400 text-sm">标签加载中...</div>
            <div v-else class="flex flex-wrap gap-2">
              <span v-for="tag in allTags" :key="tag.id" @click="toggleTag(tag.id)"
                class="cursor-pointer px-3 py-1 rounded-full border text-xs"
                :class="editForm.tag_ids.includes(tag.id) ? 'bg-blue-500 text-white border-blue-500' : 'text-gray-600 border-gray-300 hover:bg-gray-100'">
                {{ tag.name }}
              </span>
            </div>

          </div>
        </div>

        <div class="mt-6 text-right space-x-2">
          <button @click="showEditModal = false"
            class="px-4 py-2 rounded border border-gray-300 hover:bg-gray-100 text-sm">取消</button>
          <button @click="submitEdit"
            class="px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700 text-sm">保存修改</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import axios from 'axios'

const filters = ref({
  keyword: '',
  status: '',
  shop_id: 1,
  factory_id: ''
})
const selectedProduct = ref({})
const showDetailModal = ref(false)
const products = ref([])
const shops = ref([])
const factories = ref([])

const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

const showEditModal = ref(false)
const editForm = ref({})
const allTags = ref([])
const tagLoading = ref(false)
const searchField = ref('name')
const keyword = ref('')


const totalPages = computed(() => Math.ceil(total.value / pageSize.value))

const pageRange = computed(() => {
  const range = []
  const max = 5
  let start = Math.max(1, currentPage.value - Math.floor(max / 2))
  let end = Math.min(totalPages.value, start + max - 1)
  if (end - start < max - 1) start = Math.max(1, end - max + 1)
  for (let i = start; i <= end; i++) range.push(i)
  return range
})

const statusClassMap = {
  1: 'bg-blue-100 text-blue-800',
  2: 'bg-green-100 text-green-800',
  3: 'bg-yellow-100 text-yellow-800',
  4: 'bg-red-100 text-red-800'
}

onMounted(() => {
  fetchShops()
  fetchFactories()
  fetchAllTags()
  fetchProducts()
})

watch(filters, () => {
  currentPage.value = 1
  fetchProducts()
}, { deep: true })

watch(searchField, () => {
  if (keyword.value.trim() !== '') {
    currentPage.value = 1
    fetchProducts()
  }
})

function onSearch() {
  currentPage.value = 1
  fetchProducts()
}

async function fetchProducts() {
  const params = {
    status: filters.value.status,
    shop_id: filters.value.shop_id,
    factory_id: filters.value.factory_id,
    page: currentPage.value,
    limit: pageSize.value
  }

  const kw = keyword.value.trim()
  if (kw !== '') {
    if (searchField.value === 'tag') {
      const matched = allTags.value.find(tag => tag.name.includes(kw))
      if (matched) {
        params['tag_name'] = matched.name // ✅ 传名字，不是原始 keyword
      } else {
        params['tag_name'] = kw // ✅ fallback：防止没有匹配到时也能模糊搜索
      }
    } else {
      params[searchField.value] = kw
    }

  }

  const res = await axios.get('http://8.130.70.249:8080/api/products', { params })
  products.value = res.data.data || []
  total.value = res.data.total || 0
}

function goToPage(page) {
  if (page < 1 || page > totalPages.value) return
  currentPage.value = page
  fetchProducts()
}

function getStatusText(status) {
  const map = {
    1: '入工厂',
    2: '出工厂',
    3: '入商店',
    4: '出商店'
  }
  return map[status] || '未知状态'
}

function getShopName(id) {
  return shops.value.find(s => s.id === id)?.name || '未知店铺'
}

function getFactoryName(id) {
  return factories.value.find(f => f.id === id)?.name || '未知工厂'
}

async function fetchShops() {
  const res = await axios.get('http://8.130.70.249:8080/api/shops')
  shops.value = res.data.data || []
}

async function fetchFactories() {
  const res = await axios.get('http://8.130.70.249:8080/api/factories')
  factories.value = res.data.data || []
}

function viewProduct(item) {
  console.log('查看商品：', item)
  selectedProduct.value = item
  showDetailModal.value = true
}

function openEditModal(item) {
  console.log('编辑商品：', item)
  selectedProduct.value = item
  editForm.value = {
    id: item.id,
    name: item.name,
    specification: item.specification,
    status: item.status,
    remark: item.remark,
    tag_ids: JSON.parse(item.tag || '{}').children || []
  }
  showEditModal.value = true
  fetchAllTags()
}

function toggleTag(id) {
  const index = editForm.value.tag_ids.indexOf(id)
  if (index > -1) {
    editForm.value.tag_ids.splice(index, 1)
  } else {
    editForm.value.tag_ids.push(id)
  }
}

async function fetchAllTags() {
  tagLoading.value = true
  try {
    const res = await axios.get('http://8.130.70.249:8080/api/tags/with_alert', {
      params: {
        shop_id: filters.value.shop_id
      }
    })
    allTags.value = res.data.data || []
  } catch (e) {
    console.error('标签加载失败', e)
  } finally {
    tagLoading.value = false
  }
}

async function submitEdit() {
  const payload = {
    id: editForm.value.id,
    name: editForm.value.name,
    specification: editForm.value.specification,
    status: editForm.value.status,
    remark: editForm.value.remark,
    tag: JSON.stringify({ children: editForm.value.tag_ids })
  }
  await axios.post('http://8.130.70.249:8080/api/products/update', payload)
  showEditModal.value = false
  fetchProducts()
}
</script>

<style scoped>
th,
td {
  white-space: nowrap;
}

button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}
</style>