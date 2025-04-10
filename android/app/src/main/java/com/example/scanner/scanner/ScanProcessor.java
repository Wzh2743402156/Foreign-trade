package com.example.scanner.scanner;

import android.content.Context;
import android.util.Log;

import com.example.scanner.session.UserSession;
import com.example.scanner.utils.EnvHelper;

import org.json.JSONObject;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class ScanProcessor {

    public interface OutboundCallback {
        void onComplete(boolean success);
    }

    //出库
    public void handleOutbound(Context context, String rawData, OutboundCallback callback) {
        Log.d("ScanProcessor zhihanwang", "📦 handleOutbound()，收到数据：" + rawData);

        new Thread(() -> {
            try {
                // 1. 发送 HTTP 请求并等待结果
                boolean result = sendToBackendForOutbound(context, rawData);
                Log.d("ScanProcessor zhihanwang", "🌐 后端响应结果：" + result);

                if (result) {
                    // 2. 如果后端操作成功，发送到 Redis
                    RedisSender.sendToRedis(context, rawData);
                }

                callback.onComplete(result);

            } catch (Exception e) {
                Log.e("ScanProcessor zhihanwang", "❌ 出库异常：" + e.getMessage());
                callback.onComplete(false);
            }
        }).start();
    }

    private boolean sendToBackendForOutbound(Context context, String barcode) {
        try {
            // 获取 API 地址
            String baseUrl = EnvHelper.getValue(context, "API_BASE_URL");
            if (baseUrl == null) {
                Log.e("ScanProcessor zhihanwang", "❌ 未找到 API_BASE_URL");
                return false;
            }

            String urlStr = baseUrl + "/api/outbound";
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            // 构造 JSON 请求体
            JSONObject json = new JSONObject();
            json.put("barcode", barcode);
            json.put("operator", UserSession.username != null ? UserSession.username : "anonymous");

            OutputStream os = conn.getOutputStream();
            os.write(json.toString().getBytes("UTF-8"));
            os.close();

            int responseCode = conn.getResponseCode();
            Log.d("ScanProcessor zhihanwang", "📨 HTTP 响应码: " + responseCode);

            return responseCode == 200;

        } catch (Exception e) {
            Log.e("ScanProcessor zhihanwang", "❌ 调用后端接口失败: " + e.getMessage());
            return false;
        }
    }

    // 入库
    public void handleInbound(Context context, String rawData, OutboundCallback callback) {
        Log.d("ScanProcessor zhihanwang", "📦 handleInbound()，收到数据：" + rawData);

        new Thread(() -> {
            try {
                // 1. 发送 HTTP 请求
                boolean result = sendToBackendForInbound(context, rawData);
                Log.d("ScanProcessor zhihanwang", "🌐 后端响应结果：" + result);

                callback.onComplete(result);

            } catch (Exception e) {
                Log.e("ScanProcessor zhihanwang", "❌ 入库异常：" + e.getMessage());
                callback.onComplete(false);
            }
        }).start();
    }

    private boolean sendToBackendForInbound(Context context, String barcode) {
        try {
            // 获取 API 地址
            String baseUrl = EnvHelper.getValue(context, "API_BASE_URL");
            if (baseUrl == null) {
                Log.e("ScanProcessor zhihanwang", "❌ 未找到 API_BASE_URL");
                return false;
            }

            String urlStr = baseUrl + "/api/inbound";  // 假设入库 API 路径是 /api/inbound
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            // 构造 JSON 请求体
            JSONObject json = new JSONObject();
            json.put("barcode", barcode);
            json.put("operator", UserSession.username != null ? UserSession.username : "anonymous");

            OutputStream os = conn.getOutputStream();
            os.write(json.toString().getBytes("UTF-8"));
            os.close();

            int responseCode = conn.getResponseCode();
            Log.d("ScanProcessor zhihanwang", "📨 HTTP 响应码: " + responseCode);

            return responseCode == 200;

        } catch (Exception e) {
            Log.e("ScanProcessor zhihanwang", "❌ 调用入库后端接口失败: " + e.getMessage());
            return false;
        }
    }

}
