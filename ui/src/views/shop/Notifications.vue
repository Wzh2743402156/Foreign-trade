<template>
    <div class="notifications">
      <h2>系统通知</h2>
      <ul>
        <li v-for="msg in messages" :key="msg.id">
          <strong>[{{ msg.date }}]</strong> {{ msg.content }}
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    name: "Notifications",
    data() {
      return {
        messages: [
          { id: 1, date: "2025-04-01", content: "库存预警：洗发水数量低于10件。" },
          { id: 2, date: "2025-04-02", content: "系统升级将于4月5日进行。" }
        ]
      };
    }
  };
  </script>
  
  <style scoped>
  ul {
    margin-top: 20px;
  }
  li {
    margin-bottom: 10px;
  }
  </style>
  