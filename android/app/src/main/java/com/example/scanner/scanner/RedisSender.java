package com.example.scanner.scanner;

import android.util.Log;

public class RedisSender {
    public static void sendToRedis(String raw) {
        Log.d("RedisSender zhihanwang", "🟡 正在准备发送到 Redis: " + raw);
        try {
            Thread.sleep(300); // 模拟耗时
            Log.d("RedisSender zhihanwang", "✅ Redis 发送成功: " + raw);
        } catch (Exception e) {
            Log.e("RedisSender zhihanwang", "❌ Redis 发送失败: " + e.getMessage());
        }
    }
}
