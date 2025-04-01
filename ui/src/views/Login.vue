<template>
  <div class="login-container">
    <h2>登录系统</h2>
    <form @submit.prevent="handleLogin">
      <input v-model="form.username" placeholder="用户名" required />
      <input v-model="form.password" type="password" placeholder="密码" required />
      <button type="submit">登录</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const form = ref({ username: '', password: '' })
const error = ref('')

const handleLogin = async () => {
  error.value = ''
  try {
    const res = await axios.post('http://localhost:8080/api/login', form.value)

    if (res.data.success) {
      const token = res.data.data.token
      const roleId = Number(res.data.data.role_id)
      const shopId = Number(res.data.data.shop_id)
      const factoryId = Number(res.data.data.factory_id)

      // 缓存数据
      localStorage.setItem('token', token)
      localStorage.setItem('role_id', roleId)
      localStorage.setItem('shop_id', shopId)
      localStorage.setItem('factory_id', factoryId)

      console.log("res", res.data.data)

      if (roleId === 1) {
        router.push('/boss/dashboard')
      } else if (roleId === 2 || roleId === 3) {
        router.push('/shop')
      } else {
        alert('无权限')
      }
    } else {
      error.value = res.data.message || '登录失败'
    }
  } catch (err) {
    error.value = err.response?.data?.error || '连接服务器失败'
  }
}
</script>

<style scoped>
.login-container {
  max-width: 300px;
  margin: 100px auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
}
.error {
  color: red;
  margin-top: 10px;
}
</style>
