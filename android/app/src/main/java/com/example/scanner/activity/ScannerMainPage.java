package com.example.scanner.activity;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.view.PreviewView;

import com.example.scanner.R;
import com.example.scanner.camera.CameraManager;
import com.example.scanner.scanner.ScanProcessor;
import com.example.scanner.scanner.ScannerCallback;
import com.example.scanner.utils.LottieDialog;
import com.example.scanner.utils.PermissionHelper;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.button.MaterialButtonToggleGroup;

/**
 * 扫描主界面
 */
public class ScannerMainPage extends AppCompatActivity implements ScannerCallback {

    private String currentMode = "barcode";  // "barcode" 或 "qrcode"
    private TextView barcodeText, qrcodeText;
    private ImageView barcodeDot, qrcodeDot, settingsBtn;
    private LinearLayout layoutBarcode, layoutQrcode;
    private PreviewView previewView;

    // true=出库，false=入库
    private boolean isOutbound = true;
    // 是否允许继续识别
    private boolean scannerEnabled = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 全屏
        getWindow().setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
        );
        setContentView(R.layout.activity_scanner_main_page);

        EdgeToEdge.enable(this);

        initViews();
        initTopBar();
        initBottomSwitch();
        initAnimation();
        initSettingsButton();

        // 检查权限
        if (PermissionHelper.hasCameraPermission(this)) {
            startCamera();
        } else {
            PermissionHelper.requestCameraPermission(this);
        }
    }

    /**
     * 权限回调
     */
    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String[] permissions,
                                           int[] grantResults)
    {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PermissionHelper.REQUEST_CAMERA_PERMISSION
                && PermissionHelper.hasCameraPermission(this)) {
            startCamera();
        } else {
            Toast.makeText(this, "请授权摄像头权限以使用扫码功能", Toast.LENGTH_LONG).show();
        }
    }

    /**
     * 初始化摄像头
     */
    private void startCamera() {
        new CameraManager(this, previewView, currentMode, this).startCamera();
    }

    /**
     * 初始化控件
     */
    private void initViews() {
        previewView = findViewById(R.id.cameraPreview);

        // 条形码 / 二维码 UI
        layoutBarcode = findViewById(R.id.layout_barcode);
        barcodeDot = findViewById(R.id.barcode_dot);
        barcodeText = findViewById(R.id.barcode_text);

        layoutQrcode = findViewById(R.id.layout_qrcode);
        qrcodeDot = findViewById(R.id.qrcode_dot);
        qrcodeText = findViewById(R.id.qrcode_text);

        settingsBtn = findViewById(R.id.settings);

        isOutbound = true;
        scannerEnabled = true;
    }

    /**
     * 顶部按钮：入库 / 出库
     */
    private void initTopBar() {
        MaterialButton btnIn = findViewById(R.id.btn_in);
        MaterialButton btnOut = findViewById(R.id.btn_out);
        MaterialButtonToggleGroup toggle = findViewById(R.id.mode_toggle);

        toggle.addOnButtonCheckedListener((group, checkedId, isChecked) -> {
            if (isChecked) {
                if (checkedId == R.id.btn_in) {
                    // 入库
                    btnIn.setBackgroundTintList(ColorStateList.valueOf(Color.YELLOW));
                    btnIn.setTextColor(Color.BLACK);
                    btnIn.setText("✅ 入库");
                    isOutbound = false;

                    btnOut.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#2E7D32")));
                    btnOut.setTextColor(Color.WHITE);
                    btnOut.setText("出库");
                } else {
                    // 出库
                    btnOut.setBackgroundTintList(ColorStateList.valueOf(Color.YELLOW));
                    btnOut.setTextColor(Color.BLACK);
                    btnOut.setText("✅ 出库");
                    isOutbound = true;

                    btnIn.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#2E7D32")));
                    btnIn.setTextColor(Color.WHITE);
                    btnIn.setText("入库");
                }
            }
        });
    }

    /**
     * 底部按钮：barcode / qrcode
     */
    private void initBottomSwitch() {
        layoutBarcode.setOnClickListener(v -> {
            currentMode = "barcode";
            updateModeUI();
            startCamera();
        });

        layoutQrcode.setOnClickListener(v -> {
            currentMode = "qrcode";
            updateModeUI();
            startCamera();
        });
    }

    private void updateModeUI() {
        if ("barcode".equals(currentMode)) {
            barcodeText.setTextColor(Color.YELLOW);
            barcodeDot.setVisibility(View.VISIBLE);

            qrcodeText.setTextColor(Color.WHITE);
            qrcodeDot.setVisibility(View.INVISIBLE);
        } else {
            qrcodeText.setTextColor(Color.YELLOW);
            qrcodeDot.setVisibility(View.VISIBLE);

            barcodeText.setTextColor(Color.WHITE);
            barcodeDot.setVisibility(View.INVISIBLE);
        }
    }

    /**
     * 设置按钮
     */
    private void initSettingsButton() {
        settingsBtn.setOnClickListener(v -> {
            Intent intent = new Intent(ScannerMainPage.this, SettingPage.class);
            startActivity(intent);
        });
    }

    /**
     * 中间动画：扫描线
     */
    private void initAnimation() {
        ImageView scanLine = findViewById(R.id.scan_line);
        AnimationSet set = new AnimationSet(true);

        AlphaAnimation fadeIn = new AlphaAnimation(0f, 1f);
        fadeIn.setDuration(500);

        TranslateAnimation slide = new TranslateAnimation(
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 1f
        );
        slide.setDuration(2000);

        AlphaAnimation fadeOut = new AlphaAnimation(1f, 0f);
        fadeOut.setDuration(500);
        fadeOut.setStartOffset(2000);

        set.addAnimation(fadeIn);
        set.addAnimation(slide);
        set.addAnimation(fadeOut);

        set.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {}

            @Override
            public void onAnimationEnd(Animation animation) {
                scanLine.postDelayed(() -> scanLine.startAnimation(set), 10);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {}
        });

        scanLine.startAnimation(set);
    }

    /**
     * 是否出库模式
     */
    private boolean isOutboundMode() {
        return isOutbound;
    }

    /**
     * 禁用扫描
     */
    private void disableScanner() {
        scannerEnabled = false;
    }

    /**
     * 启用扫描
     */
    private void enableScanner() {
        scannerEnabled = true;
    }

    /**
     * CameraManager里会调用来判断能否继续扫描
     */
    @Override
    public boolean canScan() {
        return scannerEnabled;
    }

    /**
     * 真正扫码结果回调
     */
    @Override
    public void onScanResult(String raw, boolean isJson, String type) {
        if (!scannerEnabled) return;
        Log.d("ScannerMainPage zhihanwang", "🟡 onScanResult() raw=" + raw);

        if (isOutboundMode()) {
            disableScanner();

            // 显示loading
            LottieDialog.showLoading(this, "正在出库中...");

            new ScanProcessor().handleOutbound(raw, success -> {
                Log.d("ScannerMainPage zhihanwang", "🚀 已触发 ScanProcessor.handleOutbound(), success=" + success);

                // 回到UI线程
                runOnUiThread(() -> {
                    LottieDialog.dismiss(); // 关闭加载动画

                    if (success) {
                        Toast.makeText(this, "✅ 出库成功", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(this, "❌ 出库失败，请检查数据", Toast.LENGTH_SHORT).show();
                    }
                    enableScanner();
                });
            });
        } else {
            // TODO: 入库逻辑
        }
    }
}
