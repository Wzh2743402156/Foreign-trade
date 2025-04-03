import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import VChart from 'vue-echarts'
import 'element-plus/theme-chalk/el-message.css'
import { ElMessage } from 'element-plus'


createApp(App).use(router).mount('#app')
