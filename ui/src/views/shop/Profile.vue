<template>
    <div class="profile-container">
        <h2 class="title">👤 个人中心</h2>

        <div class="profile-card">
            <div class="avatar-wrapper">
                <img class="avatar" :src="avatarUrl" alt="头像" />
            </div>
            <div class="info">
                <p><strong>用户名：</strong>{{ user.username }}</p>
                <p><strong>角色：</strong>{{ roleText }}</p>
                <p v-if="user.permission"><strong>权限：</strong>{{ user.permission }}</p>
                <p v-if="user.role_id === 2 || user.role_id === 3"><strong>所属商店：</strong>{{ user.shop_id }}</p>
                <p v-if="user.role_id === 4 || user.role_id === 5"><strong>所属工厂：</strong>{{ user.factory_id }}</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'

const user = ref({
    username: '',
    role_id: null,
    permission: '',
    shop_id: null,
    factory_id: null
})

const avatarUrl = 'https://i.pravatar.cc/100?img=5'

// 可选角色映射
const roleMap = {
    1: '管理员',
    2: '店长',
    3: '店员',
    4: '厂家',
    5: '厂家员工'
}
const roleText = computed(() => roleMap[user.value.role_id] || '未知角色')

// 获取用户信息（可对接真实接口）
async function fetchUserInfo() {
    const res = await axios.get('http://localhost:8080/api/user/profile', {
        headers: {
            Authorization: 'Bearer ' + localStorage.getItem('token')
        }
    })
    // console.log("Shop Profile token ", localStorage.getItem('token')) // 密文 token 打印 有风险
    console.log("Shop Profile Page res ", res.data)

    user.value = res.data.data
}

onMounted(() => {
    fetchUserInfo()
})
</script>

<style scoped>
.profile-container {
    padding: 32px;
    background-color: #f9fafb;
}

.title {
    font-size: 22px;
    font-weight: bold;
    margin-bottom: 24px;
    color: #2c3e50;
}

.profile-card {
    display: flex;
    align-items: center;
    background: #ffffff;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    max-width: 600px;
}

.avatar-wrapper {
    margin-right: 24px;
}

.avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #dcdfe6;
}

.info p {
    font-size: 16px;
    margin-bottom: 10px;
    color: #333;
}
</style>