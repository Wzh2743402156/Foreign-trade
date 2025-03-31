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

const form = ref({ username: '', password: '' })
const error = ref('')
const router = useRouter()

const handleLogin = async () => {
  error.value = ''
  try {
    const res = await axios.post('http://localhost:8080/api/login', form.value)

    if (res.data.success) {
      const token = res.data.data.token
      const userId = res.data.data.user_id

      localStorage.setItem('token', token)
      localStorage.setItem('user_id', userId)

      router.push('/dashboard') // 登录成功跳转页面
    } else {
      error.value = res.data.error || '登录失败'
    }
  } catch (e) {
    error.value = e.response?.data?.error || '连接服务器失败'
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

input {
    width: 100%;
    margin: 10px 0;
    padding: 8px;
}

.error {
    color: red;
    margin-top: 10px;
}
</style>