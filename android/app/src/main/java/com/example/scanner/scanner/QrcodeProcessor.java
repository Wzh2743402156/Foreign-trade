package com.example.scanner.scanner;

import android.util.Log;
import com.google.mlkit.vision.barcode.common.Barcode;
import org.json.JSONObject;

/**
 * 针对二维码
 */
public class QrcodeProcessor {
    private final ScannerCallback callback;

    public QrcodeProcessor(ScannerCallback callback) {
        this.callback = callback;
    }

    public void handleQrcode(Barcode barcode) {
        String rawValue = barcode.getRawValue();
        if (rawValue == null || rawValue.isEmpty()) return;

        // 输出二维码的原始值，帮助排查问题
        Log.d("QrcodeProcessor zhihanwang", "二维码扫描结果: " + rawValue);

        // 尝试解析为 JSON 格式
        try {
            JSONObject obj = new JSONObject(rawValue);
            Log.d("QrcodeProcessor zhihanwang", "✅ 解析成功: " + obj.toString());

            String type = obj.optString("type");
            // 将二维码的 rawValue 传递给 onScanResult 方法
            callback.onScanResult(rawValue, true, type);
        } catch (Exception e) {
            // 不是 JSON 格式，直接当作条形码处理
            Log.w("QrcodeProcessor zhihanwang", "⚠️ 不合法的JSON：" + rawValue);

            // 直接将 rawValue 传递给 callback，作为条形码处理
            callback.onScanResult(rawValue, false, null);
        }
    }
}
