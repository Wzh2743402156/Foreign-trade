<template>
  <div class="login-wrapper">
    <div class="login-card">
      <h2 class="login-title">欢迎登录系统</h2>
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="username" class="form-label">用户名</label>
          <input 
            v-model="form.username" 
            id="username" 
            class="form-input"
            placeholder="请输入用户名"
            required
          />
        </div>

        <div class="form-group">
          <label for="password" class="form-label">密码</label>
          <input 
            v-model="form.password" 
            id="password" 
            type="password" 
            class="form-input"
            placeholder="请输入密码"
            required
          />
        </div>

        <div class="form-group">
          <button 
            type="submit" 
            class="login-button" 
            :disabled="loading"
          >
            {{ loading ? '登录中...' : '立即登录' }}
          </button>
        </div>

        <div class="error-container">
          <p v-if="error" class="error-message">{{ error }}</p>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const form = ref({ username: '', password: '' })
const error = ref('')
const loading = ref(false)

const handleLogin = async () => {
  error.value = ''
  loading.value = true
  try {
    const res = await axios.post('http://localhost:8080/api/login', form.value)

    if (res.data.success) {
      const { token, role_id, shop_id, factory_id } = res.data.data
      localStorage.setItem('token', token)
      localStorage.setItem('role_id', role_id)
      localStorage.setItem('shop_id', shop_id)
      localStorage.setItem('factory_id', factory_id)

      const routeMap = {
        1: '/boss/dashboard',
        2: '/shop',
        3: '/shop'
      }

      const path = routeMap[role_id] || '/unauthorized'
      router.push(path)
    } else {
      error.value = res.data.message || '登录失败'
    }
  } catch (err) {
    error.value = err.response?.data?.error || '连接服务器失败'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-wrapper {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
  padding: 2rem;
}

.login-card {
  background: white;
  width: 100%;
  max-width: 400px;
  padding: 3rem 2rem;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.login-title {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 2rem;
  font-weight: bold;
  font-size: 1.5rem;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  width: 100%;
}

.form-group {
  width: 100%;
}

.form-label {
  display: block;
  margin-bottom: 0.4rem;
  color: #555;
  font-size: 0.95rem;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 1rem;
  box-sizing: border-box;
  border: 1.8px solid #d0d0d0;
  border-radius: 8px;
  font-size: 1rem;
  background: #fafafa;
  transition: 0.3s ease;
}

.form-input:focus {
  border-color: #42a5f5;
  background: #fff;
  box-shadow: 0 0 0 3px rgba(66, 165, 245, 0.2);
}

.login-button {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #42a5f5, #1e88e5);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.05rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.login-button:hover {
  background: linear-gradient(135deg, #1e88e5, #42a5f5);
  transform: translateY(-1px);
}

.error-container {
  display: flex;
  justify-content: center;
  margin-top: 1rem;
}

.error-message {
  color: #e53935;
  background: #ffebee;
  border: 1px solid #ffcdd2;
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  max-width: 90%;
  word-break: break-word;
}

@media (max-width: 480px) {
  .login-card {
    padding: 2rem 1.5rem;
  }

  .login-title {
    font-size: 1.3rem;
  }

  .error-message {
    padding: 0.8rem;
  }
}
</style>