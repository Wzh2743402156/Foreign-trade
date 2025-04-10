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
            // 尝试解析为 JSON（QR Code 模式）
            JSONObject obj = new JSONObject(rawValue);
            String productId = obj.optString("product_id");
            String type = obj.optString("type");
            Log.d("BarcodeProcessor zhihanwang", "✅ 解析成功: productId=" + productId);
            callback.onScanResult(rawValue, true, type);
        } catch (Exception e) {
            // 非 JSON，可能是普通 EAN-13 条码
            if (isValidEAN13(rawValue)) {
                Log.d("BarcodeProcessor zhihanwang", "✅ 合法 EAN13 条形码: " + rawValue);
                callback.onScanResult(rawValue, false, "ean13");
            } else {
                Log.w("BarcodeProcessor zhihanwang", "⛔ 非法条码，已忽略: " + rawValue);
            }
        }
    }

    /**
     * 检查是否为合法的 EAN13 条形码（校验位算法）
     */
    private boolean isValidEAN13(String code) {
        if (code == null || code.length() != 13 || !code.matches("\\d{13}")) return false;
        int sum = 0;
        for (int i = 0; i < 12; i++) {
            int digit = Character.getNumericValue(code.charAt(i));
            sum += (i % 2 == 0) ? digit : digit * 3;
        }
        int checkDigit = (10 - (sum % 10)) % 10;
        return checkDigit == Character.getNumericValue(code.charAt(12));
    }
}
