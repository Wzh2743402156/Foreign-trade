<template>
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            库存管理系统
          </h2>
          <p class="mt-2 text-center text-sm text-gray-600">
            请登录您的账号
          </p>
        </div>
        <form class="mt-8 space-y-6" @submit.prevent="handleLogin">
          <div class="rounded-md shadow-sm -space-y-px">
            <div>
              <label for="account" class="sr-only">账号</label>
              <input
                id="account"
                v-model="account"
                name="account"
                type="text"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                placeholder="账号"
              />
            </div>
            <div>
              <label for="password" class="sr-only">密码</label>
              <input
                id="password"
                v-model="password"
                name="password"
                type="password"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                placeholder="密码"
              />
            </div>
          </div>
  
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input
                id="remember-me"
                v-model="rememberMe"
                name="remember-me"
                type="checkbox"
                class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
              />
              <label for="remember-me" class="ml-2 block text-sm text-gray-900">
                记住我
              </label>
            </div>
          </div>
  
          <div>
            <button
              type="submit"
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              :disabled="isLoading"
            >
              <span v-if="isLoading" class="absolute left-0 inset-y-0 flex items-center pl-3">
                <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              </span>
              {{ isLoading ? '登录中...' : '登录' }}
            </button>
          </div>
          
          <div v-if="errorMessage" class="text-red-500 text-center text-sm">
            {{ errorMessage }}
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import { useRouter } from 'vue-router';
  
  const router = useRouter();
  
  // 状态
  const account = ref('');
  const password = ref('');
  const rememberMe = ref(false);
  const isLoading = ref(false);
  const errorMessage = ref('');
  
  // 模拟用户数据
  const mockUsers = [
    { id: 1, name: '管理员', account: 'admin', password: 'admin123', permission: 1 },
    { id: 2, name: '工厂用户', account: 'factory', password: 'factory123', permission: 2, factory_id: 1 },
    { id: 3, name: '商店用户', account: 'shop', password: 'shop123', permission: 3, shop_id: 1 }
  ];
  
  // 方法
  async function handleLogin() {
    errorMessage.value = '';
    isLoading.value = true;
    
    try {
      // 模拟API请求延迟
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // 查找用户
      const user = mockUsers.find(u => 
        u.account === account.value && u.password === password.value
      );
      
      if (user) {
        // 登录成功，存储用户信息
        const { password, ...userInfo } = user; // 移除密码
        localStorage.setItem('user', JSON.stringify(userInfo));
        
        // 重定向到首页
        router.push('/');
      } else {
        // 登录失败
        errorMessage.value = '账号或密码错误';
      }
    } catch (error) {
      errorMessage.value = '登录失败，请稍后再试';
      console.error('Login error:', error);
    } finally {
      isLoading.value = false;
    }
  }
  </script>