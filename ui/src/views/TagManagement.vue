<template>
    <div>
      <!-- 搜索和操作 -->
      <div class="bg-white rounded-lg shadow-sm mb-4">
        <div class="p-4 border-b border-gray-100">
          <div class="flex flex-wrap gap-3">
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
            
            <button 
              @click="searchTags"
              class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              搜索
            </button>
            
            <button 
              @click="showCreateTagModal = true"
              class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 ml-auto"
            >
              新建标签
            </button>
          </div>
        </div>
      </div>
      
      <!-- 标签列表 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <div v-for="tag in filteredTags" :key="tag.id" class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="p-4 border-b border-gray-100 flex justify-between items-center">
            <div class="flex items-center">
              <div 
                class="w-3 h-3 rounded-full mr-2"
                :style="{ backgroundColor: tag.color }"
              ></div>
              <h3 class="text-sm font-medium text-gray-900">{{ tag.name }}</h3>
            </div>
            <div class="flex space-x-1">
              <button 
                @click="editTag(tag)"
                class="p-1 text-gray-500 hover:text-gray-700 rounded-full hover:bg-gray-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                </svg>
              </button>
              <button 
                @click="deleteTag(tag)"
                class="p-1 text-gray-500 hover:text-red-700 rounded-full hover:bg-gray-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
          <div class="p-4">
            <div class="grid grid-cols-2 gap-2 text-xs">
              <div class="bg-gray-50 p-2 rounded">
                <div class="text-gray-500 mb-1">关联商品</div>
                <div class="font-medium">{{ tag.productCount }}</div>
              </div>
              <div class="bg-gray-50 p-2 rounded">
                <div class="text-gray-500 mb-1">创建时间</div>
                <div class="font-medium">{{ tag.createdAt }}</div>
              </div>
              <div class="bg-gray-50 p-2 rounded">
                <div class="text-gray-500 mb-1">库存警戒下限</div>
                <div class="font-medium">{{ tag.alertLow }}</div>
              </div>
              <div class="bg-gray-50 p-2 rounded">
                <div class="text-gray-500 mb-1">库存警戒上限</div>
                <div class="font-medium">{{ tag.alertHigh }}</div>
              </div>
            </div>
            <div class="mt-3">
              <div class="text-xs text-gray-500 mb-1">描述</div>
              <div class="text-sm text-gray-700">{{ tag.description || '无描述' }}</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 创建标签模态框 (简化版) -->
      <div v-if="showCreateTagModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium text-gray-900">创建新标签</h3>
            <button @click="showCreateTagModal = false" class="text-gray-500 hover:text-gray-700">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">标签名称</label>
              <input 
                v-model="newTag.name" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入标签名称"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">标签颜色</label>
              <div class="flex space-x-2">
                <button 
                  v-for="color in ['#EF4444', '#F59E0B', '#10B981', '#3B82F6', '#8B5CF6', '#EC4899']" 
                  :key="color"
                  @click="newTag.color = color"
                  class="w-6 h-6 rounded-full border-2"
                  :class="newTag.color === color ? 'border-gray-900' : 'border-transparent'"
                  :style="{ backgroundColor: color }"
                ></button>
              </div>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">描述</label>
              <textarea 
                v-model="newTag.description" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入标签描述"
                rows="3"
              ></textarea>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">库存警戒下限</label>
                <input 
                  v-model="newTag.alertLow" 
                  type="number" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">库存警戒上限</label>
                <input 
                  v-model="newTag.alertHigh" 
                  type="number" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
            </div>
          </div>
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="showCreateTagModal = false"
              class="px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              取消
            </button>
            <button 
              @click="createTag"
              class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              创建
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  
  // 状态
  const searchQuery = ref('');
  const tags = ref([]);
  const showCreateTagModal = ref(false);
  const newTag = ref({
    name: '',
    color: '#3B82F6',
    description: '',
    alertLow: 10,
    alertHigh: 100
  });
  
  // 模拟数据
  onMounted(() => {
    // 模拟API调用获取标签数据
    tags.value = [
      { 
        id: 1, 
        name: '电子产品', 
        color: '#3B82F6', 
        productCount: 25, 
        createdAt: '2023-01-15', 
        alertLow: 10, 
        alertHigh: 100,
        description: '所有电子类产品，包括手机、电脑等'
      },
      { 
        id: 2, 
        name: '家具', 
        color: '#10B981', 
        productCount: 15, 
        createdAt: '2023-02-20', 
        alertLow: 5, 
        alertHigh: 50,
        description: '所有家具类产品，包括桌椅、沙发等'
      },
      { 
        id: 3, 
        name: '服装', 
        color: '#F59E0B', 
        productCount: 40, 
        createdAt: '2023-03-10', 
        alertLow: 15, 
        alertHigh: 150,
        description: '所有服装类产品，包括上衣、裤子等'
      },
      { 
        id: 4, 
        name: '食品', 
        color: '#EF4444', 
        productCount: 30, 
        createdAt: '2023-04-05', 
        alertLow: 20, 
        alertHigh: 200,
        description: '所有食品类产品，包括零食、饮料等'
      },
      { 
        id: 5, 
        name: '玩具', 
        color: '#8B5CF6', 
        productCount: 20, 
        createdAt: '2023-05-01', 
        alertLow: 10, 
        alertHigh: 80,
        description: '所有玩具类产品，包括积木、玩偶等'
      }
    ];
  });
  
  // 计算属性
  const filteredTags = computed(() => {
    if (!searchQuery.value) {
      return tags.value;
    }
    
    const query = searchQuery.value.toLowerCase();
    return tags.value.filter(tag => 
      tag.name.toLowerCase().includes(query) || 
      (tag.description && tag.description.toLowerCase().includes(query))
    );
  });
  
  // 方法
  function searchTags() {
    // 实际应用中可能需要调用API
    console.log('搜索标签:', searchQuery.value);
  }
  
  function editTag(tag) {
    // 实际应用中应打开编辑模态框
    console.log('编辑标签:', tag);
  }
  
  function deleteTag(tag) {
    // 实际应用中应显示确认对话框
    console.log('删除标签:', tag);
    
    if (confirm(`确定要删除标签 "${tag.name}" 吗？`)) {
      // 模拟删除操作
      tags.value = tags.value.filter(t => t.id !== tag.id);
    }
  }
  
  function createTag() {
    // 模拟创建标签
    const newTagObj = {
      id: tags.value.length + 1,
      name: newTag.value.name,
      color: newTag.value.color,
      description: newTag.value.description,
      alertLow: parseInt(newTag.value.alertLow),
      alertHigh: parseInt(newTag.value.alertHigh),
      productCount: 0,
      createdAt: new Date().toISOString().split('T')[0]
    };
    
    tags.value.push(newTagObj);
    
    // 重置表单
    newTag.value = {
      name: '',
      color: '#3B82F6',
      description: '',
      alertLow: 10,
      alertHigh: 100
    };
    
    // 关闭模态框
    showCreateTagModal.value = false;
  }
  </script>