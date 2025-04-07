<template>
  <router-link
    :to="to"
    class="flex items-center px-3 py-2 text-sm font-medium rounded-md group transition-all"
    :class="$route.path === to ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-100'"
  >
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="icons[icon]" />
    </svg>
    <span v-show="showText" class="transition-opacity duration-300">{{ text }}</span>
  </router-link>
</template>

<script setup>
import { computed, inject, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const props = defineProps({
  to: String,
  text: String,
  icon: String,
})

const route = useRoute()
const isCollapsed = inject('isCollapsed', ref(false))
const showText = ref(!isCollapsed.value)

watch(isCollapsed, (collapsed) => {
  if (collapsed) {
    showText.value = false
  } else {
    // 延迟展示文字（等待 sidebar 展开动画完成）
    setTimeout(() => {
      showText.value = true
    }, 250) // 与侧边栏 transition 时间一致
  }
})

// 图标路径映射
const icons = {
  home: 'M3 12l2-2m0 0l7-7 7 7m-9 2v8m0 0h4m-4 0H5a2 2 0 01-2-2v-5a2 2 0 012-2h3m13 0h-3a2 2 0 00-2 2v5a2 2 0 002 2h3a2 2 0 002-2v-5a2 2 0 00-2-2z',
  box: 'M20 12H4m16 0l-8-8m8 8l-8 8M4 12l8-8M4 12l8 8',
  download: 'M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4',
  package: 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4',
  tag: 'M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z',
  file: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2',
  map: 'M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z M15 11a3 3 0 11-6 0 3 3 0 016 0z',
  user: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z'
}
</script>
