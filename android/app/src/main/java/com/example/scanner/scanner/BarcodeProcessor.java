package com.example.scanner.scanner;

import android.util.Log;

import com.google.mlkit.vision.barcode.common.Barcode;

import org.json.JSONObject;

/**
 * 针对条码
 */
public class BarcodeProcessor {
    private final ScannerCallback callback;

    public BarcodeProcessor(ScannerCallback callback) {
        this.callback = callback;
    }

    public void handleBarcode(Barcode barcode) {
        String rawValue = barcode.getRawValue();
        if (rawValue == null || rawValue.isEmpty()) return;

        try {
            JSONObject obj = new JSONObject(rawValue);
            // 可能包含 "product_id", "type" 等
            String productId = obj.optString("product_id");
            String type = obj.optString("type");
            Log.d("BarcodeProcessor zhihanwang", "✅ 解析成功: productId=" + productId);

            callback.onScanResult(rawValue, true, type);
        } catch (Exception e) {
            // 如果 JSON 解析失败
            Log.w("BarcodeProcessor zhihanwang", "⚠️ 不合法的JSON：" + rawValue);
            callback.onScanResult(rawValue, false, null);
        }
    }
}
