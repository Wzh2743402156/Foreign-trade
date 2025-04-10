<template>
  <div>
    <!-- 搜索和操作 -->
    <div class="bg-white rounded-2xl shadow p-4 mb-6">
      <div class="flex flex-wrap gap-3 items-center">
        <div class="relative flex-1 min-w-[200px]">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="搜索标签名称..."
            class="w-full pl-8 pr-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
          />
          <div class="absolute inset-y-0 left-0 pl-2 flex items-center pointer-events-none">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>
        <button @click="showCreateModal = true" class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700">新增标签</button>
        <button @click="searchTags" class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700">搜索</button>
      </div>
    </div>

    <!-- 标签卡片列表 -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="tag in filteredTags" :key="tag.id" class="bg-white rounded-2xl shadow-lg border border-gray-100 hover:shadow-xl transition">
        <div class="p-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="text-base font-semibold text-gray-800">{{ tag.name }}</h3>
          <div class="flex gap-2">
            <button @click="editTag(tag)" class="text-blue-500 hover:underline text-sm">编辑</button>
            <button @click="deleteTag(tag.id)" class="text-red-500 hover:underline text-sm">删除</button>
          </div>
        </div>
        <div class="p-4 space-y-3 text-sm">
          <div class="grid grid-cols-2 gap-3">
            <div class="bg-teal-50 text-teal-800 p-3 rounded-lg">
              <div class="text-xs text-gray-500">关联商品</div>
              <div class="font-semibold text-base">{{ tag.productCount }}</div>
            </div>
            <div class="bg-indigo-50 text-indigo-800 p-3 rounded-lg">
              <div class="text-xs text-gray-500">创建时间</div>
              <div class="font-semibold text-base">{{ formatDate(tag.createdAt) }}</div>
            </div>
            <div class="bg-amber-50 text-amber-800 p-3 rounded-lg">
              <div class="text-xs text-gray-500">库存警戒下限</div>
              <div class="font-semibold text-base">{{ tag.alertLow }}</div>
            </div>
            <div class="bg-sky-50 text-sky-800 p-3 rounded-lg">
              <div class="text-xs text-gray-500">库存警戒上限</div>
              <div class="font-semibold text-base">{{ tag.alertHigh }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑模态框 -->
    <div v-if="showEditModal" class="fixed inset-0 bg-black bg-opacity-40 flex justify-center items-center z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
        <h2 class="text-lg font-semibold mb-4">编辑标签</h2>
        <input v-model="editForm.name" type="text" class="w-full border rounded p-2 mb-4" placeholder="请输入新的标签名" />
        <div class="grid grid-cols-2 gap-4 mb-4">
          <input v-model.number="editForm.alertLow" type="number" class="border rounded p-2" placeholder="库存警戒下限" />
          <input v-model.number="editForm.alertHigh" type="number" class="border rounded p-2" placeholder="库存警戒上限" />
        </div>
        <div class="flex justify-end gap-3">
          <button @click="showEditModal = false" class="px-4 py-2 bg-gray-200 rounded">取消</button>
          <button @click="confirmEdit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">保存</button>
        </div>
      </div>
    </div>

    <!-- 新增模态框 -->
    <div v-if="showCreateModal" class="fixed inset-0 bg-black bg-opacity-40 flex justify-center items-center z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
        <h2 class="text-lg font-semibold mb-4">新增标签</h2>
        <input v-model="createForm.name" type="text" class="w-full border rounded p-2 mb-4" placeholder="请输入标签名" />
        <div class="grid grid-cols-2 gap-4 mb-4">
          <input v-model.number="createForm.alertLow" type="number" class="border rounded p-2" placeholder="库存警戒下限" />
          <input v-model.number="createForm.alertHigh" type="number" class="border rounded p-2" placeholder="库存警戒上限" />
        </div>
        <div class="flex justify-end gap-3">
          <button @click="showCreateModal = false" class="px-4 py-2 bg-gray-200 rounded">取消</button>
          <button @click="confirmCreate" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">创建</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'

const searchQuery = ref('')
const tags = ref([])
const showEditModal = ref(false)
const showCreateModal = ref(false)
const editForm = ref({ id: null, name: '', alertLow: 0, alertHigh: 100 })
const createForm = ref({ name: '', alertLow: 0, alertHigh: 100 })
const shopId = 1
const factoryId = 0

onMounted(fetchTags)

async function fetchTags() {
  try {
    const res = await axios.get(`http://8.130.70.249:8080/api/tags/with_alert?shop_id=${shopId}`)
    if (res.data.success) {
      tags.value = res.data.data
    }
  } catch (error) {
    console.error('获取标签失败:', error)
  }
}

const filteredTags = computed(() => {
  if (!searchQuery.value) return tags.value
  const q = searchQuery.value.toLowerCase()
  return tags.value.filter(tag => tag.name.toLowerCase().includes(q))
})

function searchTags() {
  fetchTags()
}

function formatDate(dateStr) {
  const d = new Date(dateStr)
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

async function editTag(tag) {
  try {
    const alertRes = await axios.post('http://8.130.70.249:8080/api/alert/get', { tag_id: tag.id })
    editForm.value = {
      id: tag.id,
      name: tag.name,
      alertLow: alertRes.data.alert_low || 0,
      alertHigh: alertRes.data.alert_high || 100
    }
    showEditModal.value = true
  } catch (error) {
    console.error('获取告警信息失败:', error)
  }
}

async function confirmEdit() {
  try {
    await axios.post('http://8.130.70.249:8080/api/tags/update', {
      id: editForm.value.id,
      name: editForm.value.name
    })
    await axios.post('http://8.130.70.249:8080/api/alert/set', {
      tag_id: editForm.value.id,
      alert_low: editForm.value.alertLow,
      alert_high: editForm.value.alertHigh
    })
    showEditModal.value = false
    fetchTags()
  } catch (error) {
    console.error('编辑标签失败:', error)
  }
}

async function deleteTag(id) {
  if (!confirm('确定删除该标签吗？')) return
  try {
    await axios.delete(`http://8.130.70.249:8080/api/tags/delete/${id}`)
    fetchTags()
  } catch (error) {
    console.error('删除标签失败:', error)
  }
}

async function confirmCreate() {
  if (!createForm.value.name) return
  try {
    await axios.post('http://8.130.70.249:8080/api/tags/create', {
      name: createForm.value.name,
      shop_id: shopId,
      factory_id: factoryId
    })
    const idRes = await axios.get(`http://8.130.70.249:8080/api/tags/id?name=${createForm.value.name}&shop_id=${shopId}`)
    const tagId = idRes.data.tag_id
    await axios.post('http://8.130.70.249:8080/api/alert/set', {
      tag_id: tagId,
      alert_low: createForm.value.alertLow,
      alert_high: createForm.value.alertHigh
    })
    showCreateModal.value = false
    createForm.value = { name: '', alertLow: 0, alertHigh: 100 }
    fetchTags()
  } catch (error) {
    console.error('创建标签失败:', error)
  }
}
</script>

<style scoped>
button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>