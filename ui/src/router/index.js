import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import BossDashboard from '../views/boss/Dashboard.vue'
import ShopDashboard from '../views/shop/Dashboard.vue'
import Inventory from '../views/shop/Inventory.vue'
import Notifications from '../views/shop/Notifications.vue'
import DetailCheck from '../views/shop/DetailCheck.vue'

const routes = [
  // 默认跳到 /login
  { path: '/', redirect: '/login' },

  // 登录页
  { path: '/login', component: Login },

  // Boss 页面
  { path: '/boss/dashboard', component: BossDashboard },

  // Shop 页面
  {
    path: '/shop',
    component: ShopDashboard,
    children: [
      {
        path: '',
        redirect: '/shop/inventory'
      },
      {
        path: 'inventory',
        component: Inventory
      },
      {
        path: 'detailcheck',
        component: DetailCheck
      },
      {
        path: 'notifications',
        component: Notifications
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
