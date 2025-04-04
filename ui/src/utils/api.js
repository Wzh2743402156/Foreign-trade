import axios from 'axios';

// 从 .env 文件中读取 API URL
export const config = {
  apiUrl: import.meta.env.VITE_API_URL,  // 使用 VITE_API_URL 环境变量
};

// 创建 axios 实例
const api = axios.create({
  baseURL: config.apiUrl,
  timeout: 10000,
});

// 请求拦截器
api.interceptors.request.use(
  (request) => {
    const token = localStorage.getItem('token');
    if (token) {
      request.headers['Authorization'] = `Bearer ${token}`;
    }
    return request;
  },
  (error) => Promise.reject(error)
);

// 响应拦截器
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error(error);
    return Promise.reject(error);
  }
);

const request = (method, url, data = {}, config = {}) => {
  switch (method.toLowerCase()) {
    case 'get':
      return api.get(url, { params: data, ...config });
    case 'post':
      return api.post(url, data, config);
    case 'put':
      return api.put(url, data, config);
    case 'delete':
      return api.delete(url, { data, ...config });
    default:
      throw new Error('Unsupported HTTP method');
  }
};

export const apiMethods = {
  get: (url, data, config) => request('get', url, data, config),
  post: (url, data, config) => request('post', url, data, config),
  put: (url, data, config) => request('put', url, data, config),
  delete: (url, data, config) => request('delete', url, data, config),
};
