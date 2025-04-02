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

        try {
            JSONObject obj = new JSONObject(rawValue);
            Log.d("QrcodeProcessor zhihanwang", "✅ 解析成功: " + obj.toString());

            String type = obj.optString("type");
            callback.onScanResult(rawValue, true, type);
        } catch (Exception e) {
            Log.w("QrcodeProcessor zhihanwang", "⚠️ 不合法的JSON：" + rawValue);
            callback.onScanResult(rawValue, false, null);
        }
    }
}
