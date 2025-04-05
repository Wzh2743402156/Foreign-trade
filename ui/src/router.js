import { createRouter, createWebHistory } from 'vue-router';
import InventoryQuery from './views/InventoryQuery.vue';
import ProductQuery from './views/ProductQuery.vue';
import PackageManagement from './views/PackageManagement.vue';
import TagManagement from './views/TagManagement.vue';
import LogQuery from './views/LogQuery.vue';
import LocationManagement from './views/LocationManagement.vue';
import UserManagement from './views/UserManagement.vue';
import DataDownload from './views/DataDownload.vue';

const routes = [
  {
    path: '/',
    name: 'InventoryQuery',
    component: InventoryQuery
  },
  {
    path: '/products',
    name: 'ProductQuery',
    component: ProductQuery
  },
  {
    path: '/packages',
    name: 'PackageManagement',
    component: PackageManagement
  },
  {
    path: '/tags',
    name: 'TagManagement',
    component: TagManagement
  },
  {
    path: '/logs',
    name: 'LogQuery',
    component: LogQuery
  },
  {
    path: '/locations',
    name: 'LocationManagement',
    component: LocationManagement
  },
  {
    path: '/users',
    name: 'UserManagement',
    component: UserManagement
  },
  {
    path: '/download',
    name: 'DataDownload',
    component: DataDownload
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;