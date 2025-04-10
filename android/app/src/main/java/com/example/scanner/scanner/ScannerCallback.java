package com.example.scanner.scanner;

/**
 * 用来让 CameraManager -> Processor -> MainPage 回调
 */
public interface ScannerCallback {
    // 当识别完毕后，会调用此方法
    // raw: 扫码原始数据
    // isJson: 是否是json
    // type: 解析到的type字段
    void onScanResult(String raw, boolean isJson, String type);

    // CameraManager 定期检查，以决定能否继续扫描
    boolean canScan();
}
