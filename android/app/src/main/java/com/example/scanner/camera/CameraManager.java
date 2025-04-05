package com.example.scanner.camera;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.OptIn;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ExperimentalGetImage;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;

import com.example.scanner.scanner.BarcodeProcessor;
import com.example.scanner.scanner.QrcodeProcessor;
import com.example.scanner.scanner.ScannerCallback;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.mlkit.vision.barcode.BarcodeScanner;
import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
import com.google.mlkit.vision.barcode.BarcodeScanning;
import com.google.mlkit.vision.barcode.common.Barcode;
import com.google.mlkit.vision.common.InputImage;

import java.util.concurrent.ExecutionException;

public class CameraManager {

    private final Context context;
    private final PreviewView previewView;
    private final LifecycleOwner lifecycleOwner;
    private final String mode;  // "qrcode" or "barcode"
    private final ScannerCallback callback;

    private boolean isScanning = false; // 防抖

    public CameraManager(LifecycleOwner owner,
                         PreviewView previewView,
                         String mode,
                         ScannerCallback callback) {
        this.context = (Context) owner;
        this.lifecycleOwner = owner;
        this.previewView = previewView;
        this.mode = mode;
        this.callback = callback;
    }

    private BarcodeScanner getScannerByMode() {
        BarcodeScannerOptions options;

        if ("qrcode".equals(mode)) {
            options = new BarcodeScannerOptions.Builder()
                    .setBarcodeFormats(Barcode.FORMAT_QR_CODE)
                    .build();
        } else {
            // 条形码常用几种
            options = new BarcodeScannerOptions.Builder()
                    .setBarcodeFormats(
                            Barcode.FORMAT_EAN_13,
                            Barcode.FORMAT_UPC_A,
                            Barcode.FORMAT_UPC_E,
                            Barcode.FORMAT_CODE_128,
                            Barcode.FORMAT_CODE_39,
                            Barcode.FORMAT_ITF
                    )
                    .build();
        }

        return BarcodeScanning.getClient(options);
    }

    public void startCamera() {
        ListenableFuture<ProcessCameraProvider> future = ProcessCameraProvider.getInstance(context);
        future.addListener(() -> {
            try {
                ProcessCameraProvider provider = future.get();
                Preview preview = new Preview.Builder().build();
                preview.setSurfaceProvider(previewView.getSurfaceProvider());

                ImageAnalysis analysis = new ImageAnalysis.Builder()
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .build();

                // 绑定分析器
                analysis.setAnalyzer(ContextCompat.getMainExecutor(context),
                        image -> analyzeImage(image)
                );

                provider.unbindAll();
                provider.bindToLifecycle(
                        lifecycleOwner,
                        CameraSelector.DEFAULT_BACK_CAMERA,
                        preview,
                        analysis
                );
            } catch (ExecutionException | InterruptedException e) {
                e.printStackTrace();
            }
        }, ContextCompat.getMainExecutor(context));
    }

    @OptIn(markerClass = ExperimentalGetImage.class)
    private void analyzeImage(ImageProxy imageProxy) {
        if (imageProxy.getImage() == null) {
            imageProxy.close();
            Log.d("CameraManager zhihanwang", "图像为空，跳过处理");
            return;
        }

        // 如果外部说不能扫，或者内部已锁定，则跳过
        if (!callback.canScan() || isScanning) {
            imageProxy.close();
//            Log.d("CameraManager zhihanwang", "无法扫描，跳过此帧");
            return;
        }

        InputImage image = InputImage.fromMediaImage(
                imageProxy.getImage(),
                imageProxy.getImageInfo().getRotationDegrees()
        );

        BarcodeScanner scanner = getScannerByMode();

        scanner.process(image)
                .addOnSuccessListener(barcodes -> {
                    if (!barcodes.isEmpty()) {
                        isScanning = true; // 锁定

                        Barcode barcode = barcodes.get(0);
                        String rawValue = barcode.getRawValue();
                        Log.d("CameraManager zhihanwang", "当前模式：" + mode + "，扫描结果：" + rawValue);

                        // 分别调用
                        if ("qrcode".equals(mode)) {
                            Log.d("CameraManager zhihanwang", "调用二维码处理");
                            new QrcodeProcessor(callback).handleQrcode(barcode);
                        } else {
                            Log.d("CameraManager zhihanwang", "调用条形码处理");
                            new BarcodeProcessor(callback).handleBarcode(barcode);
                        }

                        // 延迟 0.8s 再次允许
                        new Handler(Looper.getMainLooper())
                                .postDelayed(() -> {
                                    isScanning = false;
                                    Log.d("CameraManager zhihanwang", "扫描解锁，准备下一次扫描");
                                }, 800);
                    } else {
//                        Log.d("CameraManager zhihanwang", "没有识别到二维码");
                    }
                })
                .addOnFailureListener(e -> {
                    Log.e("CameraManager zhihanwang", "识别失败：", e);
                })
                .addOnCompleteListener(task -> {
                    imageProxy.close();
//                    Log.d("CameraManager zhihanwang", "图像处理完成，释放资源");
                });
    }


}
