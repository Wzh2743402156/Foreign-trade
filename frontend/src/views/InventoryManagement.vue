<template>
  <div class="min-h-screen bg-gray-50 p-4 sm:p-6">
    <header class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">库存管理系统</h1>
      <p class="text-gray-500">实时监控库存变化，优化库存管理</p>
    </header>
    
    <main>
      <InventoryDashboard />
    </main>
    
    <footer class="mt-8 text-center text-sm text-gray-500">
      <p>© {{ new Date().getFullYear() }} 库存管理系统 - 版本 1.0.0</p>
    </footer>
  </div>
</template>

<script setup>
import InventoryDashboard from './views/InventoryQuery.vue';
</script>