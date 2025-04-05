import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'
import './index.css'  // 确保这是第一个导入的 CSS
// 如果您仍然需要 style.css，请在 index.css 之后导入
// import './style.css'

const app = createApp(App)
const pinia = createPinia()

app.use(router)
app.use(pinia)
app.mount('#app')