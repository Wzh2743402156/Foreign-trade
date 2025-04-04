package com.example.scanner.scanner;

import android.content.Context;
import android.util.Log;

import com.example.scanner.session.UserSession;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import redis.clients.jedis.Jedis;

public class RedisSender {
    private static final String TAG = "RedisSender zhihanwang";

    /**
     * 临时连接 Redis 并发送数据（带用户标识）
     */
    public static void sendToRedis(Context context, String raw) {
        try {
            // 读取 env.properties.properties 中的 Redis 配置
            InputStream is = context.getAssets().open("env.properties");
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            Map<String, String> envMap = new HashMap<>();

            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("=")) {
                    String[] parts = line.split("=", 2);
                    envMap.put(parts[0].trim(), parts[1].trim());
                }
            }

            String host = envMap.get("REDIS_HOST");
            int port = Integer.parseInt(envMap.get("REDIS_PORT"));
            String password = envMap.get("REDIS_PASSWORD");

            // 拼接 Redis 的 key，推荐结构：scan_records:{userId}
            String userKey = UserSession.userId != null ? UserSession.userId : "anonymous";
            String redisKey = "scan_records:" + userKey;

            Jedis tempJedis = new Jedis(host, port);
            tempJedis.auth(password);
            tempJedis.lpush(redisKey, raw);
            tempJedis.close();

            Log.d(TAG, "✅ Redis 发送成功 key=" + redisKey + " data=" + raw);

        } catch (Exception e) {
            Log.e(TAG, "❌ Redis 发送失败: " + e.getMessage());
        }
    }
}
