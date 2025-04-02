package com.example.scanner.scanner;

import android.util.Log;

public class ScanProcessor {

    public interface OutboundCallback {
        void onComplete(boolean success);
    }

    public void handleOutbound(String rawData, OutboundCallback callback) {
        Log.d("ScanProcessor zhihanwang", "📦 handleOutbound()，收到数据：" + rawData);

        new Thread(() -> {
            try {
                // 1. 发 Redis
                Log.d("ScanProcessor zhihanwang", "📤 调用 RedisSender...");
                RedisSender.sendToRedis(rawData);

                // 2. DB检查
                boolean exists = checkInDatabase(rawData);
                Log.d("ScanProcessor zhihanwang", "🔍 数据库检查完成，是否存在：" + exists);

                if (!exists) {
                    Log.d("ScanProcessor zhihanwang", "❌ 商品不存在，出库失败");
                    callback.onComplete(false);
                    return;
                }

                // 3. 插入出库记录
                insertOutboundRecord(rawData);
                Log.d("ScanProcessor zhihanwang", "✅ 已成功插入出库记录");

                // 通知成功
                callback.onComplete(true);

            } catch (Exception e) {
                Log.e("ScanProcessor zhihanwang", "❌ 出库异常：" + e.getMessage());
                callback.onComplete(false);
            }
        }).start();
    }

    private boolean checkInDatabase(String raw) {
        // 这里做HTTP或DB查询
        return true; // 假设存在
    }

    private void insertOutboundRecord(String raw) {
        // 假装插入
        Log.d("ScanProcessor zhihanwang", "📥 正在插入 outbound 表：" + raw);
    }
}
