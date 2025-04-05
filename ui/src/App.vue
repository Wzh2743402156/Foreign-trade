<template>
  <div class="flex flex-col h-screen bg-gray-50">
    <!-- 顶部状态栏 - 贯穿整个屏幕宽度 -->
    <header class="bg-white border-b border-gray-200 z-10">
      <div class="flex justify-between items-center h-16 px-6">
        <!-- 左侧应用名称 -->
        <h1 class="text-xl font-bold text-blue-600">StockMaster</h1>
        
        <!-- 右侧操作区 -->
        <div class="flex items-center space-x-4">
          <!-- 搜索按钮 -->
          <button class="p-1 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>
          
          <!-- 通知按钮 -->
          <button class="p-1 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100 relative">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
            <span class="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500"></span>
          </button>
          
          <!-- 设置按钮 -->
          <button class="p-1 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
    
    <!-- 主体内容区域 - 包含侧边栏和主内容 -->
    <div class="flex flex-1 overflow-hidden">
      <!-- 侧边栏导航 -->
      <aside class="w-64 bg-white border-r border-gray-200 flex flex-col">
        <!-- 主导航菜单 -->
        <nav class="flex-1 overflow-y-auto py-4">
          <div class="space-y-1 px-2">
            <router-link 
              to="/" 
              class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
              :class="$route.path === '/' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
              库存查询
            </router-link>
            
            <router-link 
              to="/products" 
              class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
              :class="$route.path === '/products' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/products' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
              </svg>
              商品查询
            </router-link>
            
            <router-link 
              to="/download" 
              class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
              :class="$route.path === '/download' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/download' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
              </svg>
              数据下载
            </router-link>
          </div>
          
          <!-- 分类标题 -->
          <div class="mt-8">
            <h3 class="px-5 text-xs font-semibold text-gray-500 uppercase tracking-wider">
              管理功能
            </h3>
            <div class="mt-1 space-y-1 px-2">
              <router-link 
                to="/packages" 
                class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
                :class="$route.path === '/packages' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/packages' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                </svg>
                包裹管理
              </router-link>
              
              <router-link 
                to="/tags" 
                class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
                :class="$route.path === '/tags' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/tags' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                </svg>
                标签管理
              </router-link>
              
              <router-link 
                to="/logs" 
                class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
                :class="$route.path === '/logs' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/logs' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
                日志查询
              </router-link>
            </div>
          </div>
          
          <!-- 系统设置 -->
          <div class="mt-8">
            <h3 class="px-5 text-xs font-semibold text-gray-500 uppercase tracking-wider">
              系统设置
            </h3>
            <div class="mt-1 space-y-1 px-2">
              <router-link 
                to="/locations" 
                class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
                :class="$route.path === '/locations' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/locations' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                工厂/商店
              </router-link>
              
              <router-link 
                to="/users" 
                class="flex items-center px-3 py-2 text-sm font-medium rounded-md group"
                :class="$route.path === '/users' ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 h-5 w-5" :class="$route.path === '/users' ? 'text-blue-500' : 'text-gray-500 group-hover:text-gray-600'" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
                用户管理
              </router-link>
            </div>
          </div>
        </nav>
        
        <!-- 用户信息 -->
        <div class="border-t border-gray-200 p-4">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <div class="h-8 w-8 rounded-full bg-gray-300 flex items-center justify-center text-gray-600">
                U
              </div>
            </div>
            <div class="ml-3">
              <p class="text-sm font-medium text-gray-700">用户名</p>
              <a href="#" class="text-xs text-gray-500 hover:text-gray-700">退出登录</a>
            </div>
          </div>
        </div>
      </aside>
      
      <!-- 主内容区 -->
      <main class="flex-1 overflow-y-auto bg-gray-50 p-4">
        <!-- 页面标题 -->
        <div class="mb-4">
          <h2 class="text-lg font-medium text-gray-900">{{ pageTitle }}</h2>
        </div>
        
        <router-view />
      </main>
    </div>
  </div>
  </template>
  
  <script setup>
  import { computed } from 'vue';
  import { useRoute } from 'vue-router';
  
  const route = useRoute();
  
  // 页面标题
  // const pageTitle = computed(() => {
  // switch (route.path) {
  //   case '/': return '库存查询';
  //   case '/products': return '商品查询';
  //   case '/packages': return '包裹管理';
  //   case '/tags': return '标签管理';
  //   case '/logs': return '日志查询';
  //   case '/locations': return '工厂/商店';
  //   case '/users': return '用户管理';
  //   case '/download': return '数据下载';
  //   default: return '库存管理系统';
  // }
  // });
  </script>