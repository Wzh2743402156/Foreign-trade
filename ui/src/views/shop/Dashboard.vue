<template>
    <div class="shop-dashboard">
      <aside class="sidebar">
        <ul>
          <li :class="{ active: isActive('/shop/inventory') }">
            <router-link to="/shop/inventory">库存信息</router-link>
          </li>
          <li :class="{ active: isActive('/shop/notifications') }">
            <router-link to="/shop/notifications">消息通知</router-link>
          </li>
        </ul>
      </aside>
  
      <main class="content">
        <router-view />
      </main>
    </div>
  </template>
  
  <script setup>
  import { useRoute } from 'vue-router'
  import { defineOptions } from 'vue'
  
  defineOptions({
    name: 'Dashboard'
  })
  
  const route = useRoute()
  
  const isActive = (path) => {
    return route.path === path
  }
  </script>
  
  <style scoped>
  .shop-dashboard {
    display: flex;
  }
  
  .sidebar {
    width: 200px;
    background-color: #f5f5f5;
    height: 100vh;
    padding-top: 20px;
  }
  
  .sidebar ul {
    list-style: none;
    padding: 0;
  }
  
  .sidebar li {
    margin: 10px 0;
    padding: 10px 20px;
  }
  
  .sidebar li.active {
    background-color: #42b983;
    color: white;
  }
  
  .content {
    flex-grow: 1;
    padding: 20px;
  }
  </style>
  