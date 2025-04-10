import axios from 'axios';

// 创建axios实例
const apiClient = axios.create({
  baseURL: process.env.VUE_APP_API_URL || '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

// 请求拦截器
apiClient.interceptors.request.use(
  config => {
    // 可以在这里添加认证令牌等
    // const token = localStorage.getItem('token');
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`;
    // }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
apiClient.interceptors.response.use(
  response => {
    return response;
  },
  error => {
    // 处理错误响应
    if (error.response) {
      // 服务器返回错误状态码
      console.error('API错误:', error.response.status, error.response.data);
      
      // 可以根据状态码处理不同的错误
      switch (error.response.status) {
        case 401:
          // 未授权，可以重定向到登录页面
          // window.location.href = '/login';
          break;
        case 403:
          // 禁止访问
          console.error('没有权限访问此资源');
          break;
        case 404:
          // 资源不存在
          console.error('请求的资源不存在');
          break;
        case 500:
          // 服务器错误
          console.error('服务器错误');
          break;
        default:
          console.error('未知错误');
      }
    } else if (error.request) {
      // 请求已发送但没有收到响应
      console.error('网络错误，无法连接到服务器');
    } else {
      // 请求配置出错
      console.error('请求配置错误:', error.message);
    }
    
    return Promise.reject(error);
  }
);

export default apiClient;