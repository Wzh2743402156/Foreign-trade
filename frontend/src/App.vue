<template>
  <div class="flex flex-col h-screen bg-gray-50">
    <!-- 顶部 -->
    <header class="bg-white border-b border-gray-200 z-10">
      <div class="flex justify-between items-center h-16 px-6">
        <div class="flex items-center gap-4">
          <button @click="toggleSidebar" class="text-gray-600 hover:text-black">
            <svg v-if="!isCollapsed" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
          <h1 class="text-xl font-bold text-blue-600">StockMaster</h1>
        </div>
        <!-- 右上按钮 -->
        <div class="flex items-center space-x-4">
          <!-- 省略图标按钮略 -->
        </div>
      </div>
    </header>

    <!-- 主体内容 -->
    <div class="flex flex-1 overflow-hidden">
      <!-- 侧边栏 -->
      <aside
        :class="['bg-white border-r border-gray-200 flex flex-col transition-all duration-300', isCollapsed ? 'w-20' : 'w-64']">
        <nav class="flex-1 overflow-y-auto py-4">
          <h3 v-if="!isCollapsed" class="px-5 text-xs text-gray-500 uppercase">基础功能</h3>
          <div class="space-y-1 px-2">
            <MenuLink to="/" icon="home" text="库存查询" />
            <MenuLink to="/products" icon="box" text="商品查询" />
            <MenuLink to="/download" icon="download" text="数据下载" />
          </div>
          <div class="mt-8">
            <h3 v-if="!isCollapsed" class="px-5 text-xs text-gray-500 uppercase">管理功能</h3>
            <div class="space-y-1 px-2">
              <MenuLink to="/packages" icon="package" text="包裹管理" />
              <MenuLink to="/tags" icon="tag" text="标签管理" />
              <MenuLink to="/logs" icon="file" text="日志查询" />
            </div>
          </div>
          <div class="mt-8">
            <h3 v-if="!isCollapsed" class="px-5 text-xs text-gray-500 uppercase">系统设置</h3>
            <div class="space-y-1 px-2">
              <MenuLink to="/locations" icon="map" text="工厂/商店" />
              <MenuLink to="/users" icon="user" text="用户管理" />
            </div>
          </div>
        </nav>
        <!-- 用户信息 -->
        <div class="border-t border-gray-200 p-4">
          <div class="flex items-center">
            <div class="h-8 w-8 rounded-full bg-gray-300 flex items-center justify-center text-gray-600">U</div>
            <div v-if="!isCollapsed" class="ml-3">
              <p class="text-sm font-medium text-gray-700">用户名</p>
              <a href="#" class="text-xs text-gray-500 hover:text-gray-700">退出登录</a>
            </div>
          </div>
        </div>
      </aside>

      <!-- 主内容区 -->
      <main class="flex-1 overflow-y-auto bg-gray-50 p-4">
        <h2 class="text-lg font-medium text-gray-900 mb-4">{{ pageTitle }}</h2>
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, provide } from 'vue'
import { useRoute } from 'vue-router'
import MenuLink from './components/MenuLink.vue'

const isCollapsed = ref(false)
const toggleSidebar = () => isCollapsed.value = !isCollapsed.value
provide('isCollapsed', isCollapsed)

const route = useRoute()
const pageTitle = computed(() => {
  switch (route.path) {
    case '/': return '库存查询'
    case '/products': return '商品查询'
    case '/packages': return '包裹管理'
    case '/tags': return '标签管理'
    case '/logs': return '日志查询'
    case '/locations': return '工厂/商店'
    case '/users': return '用户管理'
    case '/download': return '数据下载'
    default: return '库存管理系统'
  }
})
</script>
