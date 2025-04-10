package com.example.scanner.activity;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
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
import androidx.appcompat.app.AlertDialog;
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
    private ImageView barcodeDot, qrcodeDot, settingsBtn, barcode_img, qrcode_img;
    private LinearLayout layoutBarcode, layoutQrcode;
    private PreviewView previewView;

    // true=出库，false=入库
    private boolean isOutbound = true;
    // 是否允许继续识别
    private boolean scannerEnabled = true;
    // 新增遮罩布局
    private LinearLayout scanResultOverlay;
    private TextView scanResultMessage;
    private ImageView scanResultIcon;

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
        barcode_img = findViewById(R.id.barcode_img);

        layoutQrcode = findViewById(R.id.layout_qrcode);
        qrcodeDot = findViewById(R.id.qrcode_dot);
        qrcodeText = findViewById(R.id.qrcode_text);
        qrcode_img = findViewById(R.id.qrcode_img);

        settingsBtn = findViewById(R.id.settings);

        isOutbound = true;
        scannerEnabled = true;

        // 初始化扫描结果提示框
        scanResultOverlay = findViewById(R.id.scanResultOverlay);
        scanResultMessage = findViewById(R.id.scanResultMessage);
        scanResultIcon = findViewById(R.id.scanResultIcon);
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
            barcode_img.setColorFilter(Color.parseColor("#FFEB3B"), PorterDuff.Mode.SRC_IN);

            qrcodeText.setTextColor(Color.WHITE);
            qrcodeDot.setVisibility(View.INVISIBLE);
            qrcode_img.setColorFilter(Color.parseColor("#FFFFFF"), PorterDuff.Mode.SRC_IN);
        } else {
            qrcodeText.setTextColor(Color.YELLOW);
            qrcodeDot.setVisibility(View.VISIBLE);
            qrcode_img.setColorFilter(Color.parseColor("#FFEB3B"), PorterDuff.Mode.SRC_IN);

            barcodeText.setTextColor(Color.WHITE);
            barcodeDot.setVisibility(View.INVISIBLE);
            barcode_img.setColorFilter(Color.parseColor("#FFFFFF"), PorterDuff.Mode.SRC_IN);
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

            new ScanProcessor().handleOutbound(this, raw, success -> {
                Log.d("ScannerMainPage zhihanwang", "🚀 已触发 ScanProcessor.handleOutbound(), success=" + success);

                // 回到UI线程
                runOnUiThread(() -> {
                    LottieDialog.dismiss(); // 关闭加载动画
                    if (success) {
                        showScanResult("✅ 操作成功", R.drawable.success_icon, R.raw.success_sound, success);
                    } else {
                        showScanResult("❌ 操作失败，请检查数据", R.drawable.failure_icon, R.raw.failure_sound, success);
                        Log.e("ScannerMainPage zhihanwang", "Backend response failed. Please check the request parameters.");
                    }
                });
            });

        } else {
            // 入库逻辑
            disableScanner();

            // 显示loading
            LottieDialog.showLoading(this, "正在入库中...");

            new ScanProcessor().handleInbound(this, raw, success -> {
                Log.d("ScannerMainPage zhihanwang", "🚀 已触发 ScanProcessor.handleInbound(), success=" + success);

                // 回到UI线程
                runOnUiThread(() -> {
                    LottieDialog.dismiss(); // 关闭加载动画

                    if (success) {
                        showScanResult("✅ 操作成功", R.drawable.success_icon, R.raw.success_sound, success);
                    } else {
                        showScanResult("❌ 操作失败，请检查数据", R.drawable.failure_icon, R.raw.failure_sound, success);
                        Log.e("ScannerMainPage zhihanwang", "Backend response failed. Please check the request parameters.");
                    }
                });
            });
        }
    }

    private void showScanResult(String message, int iconResId, int soundResId, boolean isSuccess) {
        // 创建 AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(this)
                .setTitle("扫描结果")
                .setMessage(message)
                .setIcon(iconResId)
                .setCancelable(false); // 禁止点击外部取消

        if (isSuccess) {
            // 如果成功，1秒后自动消失
            builder.setPositiveButton("确定", null); // 不设置点击事件，自动消失
        } else {
            // 如果失败，要求用户点击确定
            builder.setPositiveButton("确定", (dialog, which) -> {
                dialog.dismiss();
                enableScanner(); // 恢复扫描
            });
        }

        // 显示对话框
        AlertDialog dialog = builder.create();
        dialog.show();

        // 播放音效
        try {
            MediaPlayer mediaPlayer = MediaPlayer.create(this, soundResId);
            if (mediaPlayer != null) {
                mediaPlayer.start();
            }
        } catch (Exception e) {
            Log.e("ScannerMainPage", "Error playing sound: " + e.getMessage());
        }

        // 如果扫描成功，延时1秒后自动关闭对话框
        if (isSuccess) {
            new Handler().postDelayed(() -> {
                dialog.dismiss();
                enableScanner(); // 恢复扫描
            }, 1200);  // 1000毫秒 = 1秒
        }
    }


}
