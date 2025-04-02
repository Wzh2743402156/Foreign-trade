package com.example.scanner;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.opengl.Visibility;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.button.MaterialButtonToggleGroup;

public class ScannerMainPage extends AppCompatActivity {

    private String currentMode = "barcode"; // 默认识别模式
    private TextView barcodeText, qrcodeText;
    private ImageView barcodeDot, qrcodeDot, settingsBtn;
    private LinearLayout layoutBarcode, layoutQrcode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 设置全屏（隐藏状态栏）
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_scanner_main_page);
        EdgeToEdge.enable(this);

        initViews(); // 组件初始化
        boundInit(); // 顶部出入库按钮
        animationScan(); // 扫描线动画
        switchBottom(); // 底部扫描逻辑切换
        main2settings(); //设置按钮点击监听
    }

    // 绑定控件
    private void initViews() {
        layoutBarcode = findViewById(R.id.layout_barcode);
        barcodeDot = findViewById(R.id.barcode_dot);
        barcodeText = findViewById(R.id.barcode_text);

        layoutQrcode = findViewById(R.id.layout_qrcode);
        qrcodeDot = findViewById(R.id.qrcode_dot);
        qrcodeText = findViewById(R.id.qrcode_text);

        settingsBtn = findViewById(R.id.settings);
    }

    // 顶部“入库/出库”按钮逻辑
    private void boundInit() {
        MaterialButton btnIn = findViewById(R.id.btn_in);
        MaterialButton btnOut = findViewById(R.id.btn_out);
        MaterialButtonToggleGroup modeToggle = findViewById(R.id.mode_toggle);

        modeToggle.addOnButtonCheckedListener((group, checkedId, isChecked) -> {
            if (isChecked) {
                if (checkedId == R.id.btn_in) {
                    btnIn.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#FFEB3B")));
                    btnIn.setTextColor(Color.BLACK);
                    btnIn.setText("✅ 入库");

                    btnOut.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#2E7D32")));
                    btnOut.setTextColor(Color.WHITE);
                    btnOut.setText("出库");
                } else if (checkedId == R.id.btn_out) {
                    btnOut.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#FFEB3B")));
                    btnOut.setTextColor(Color.BLACK);
                    btnOut.setText("✅ 出库");

                    btnIn.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor("#2E7D32")));
                    btnIn.setTextColor(Color.WHITE);
                    btnIn.setText("入库");
                }
            }
        });
    }

    // 中间动画扫描线
    private void animationScan() {
        ImageView scanLine = findViewById(R.id.scan_line);

        // 每次完整的扫描动画（渐显 + 滑动 + 淡出）
        AnimationSet animationSet = new AnimationSet(true);

        // 渐显动画，缓慢出现
        AlphaAnimation fadeIn = new AlphaAnimation(0f, 1f);
        fadeIn.setDuration(500); // 渐显时间 500ms，确保平滑

        // 滑动动画，正常从上到下
        TranslateAnimation slide = new TranslateAnimation(
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 0f,
                Animation.RELATIVE_TO_PARENT, 1f
        );
        slide.setDuration(2000); // 滑动时间 1500ms，确保平滑

        // 淡出动画，缓慢消失
        AlphaAnimation fadeOut = new AlphaAnimation(1f, 0f);
        fadeOut.setDuration(500); // 淡出时间 500ms
        fadeOut.setStartOffset(2000); // 在滑动结束后开始淡出

        // 加入动画
        animationSet.addAnimation(fadeIn);
        animationSet.addAnimation(slide);
        animationSet.addAnimation(fadeOut);

        // 每次结束后再重新启动（手动循环）
        animationSet.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {}

            @Override
            public void onAnimationEnd(Animation animation) {
                // 重新开始动画
                scanLine.postDelayed(() -> scanLine.startAnimation(animationSet), 10); // 小延迟再重新启动
            }

            @Override
            public void onAnimationRepeat(Animation animation) {}
        });

        scanLine.startAnimation(animationSet);
    }

    // 底部按钮切换扫码模式
    private void switchBottom() {
        layoutBarcode.setOnClickListener(v -> {
            currentMode = "barcode";
            barcodeText.setTextColor(Color.YELLOW);
            barcodeDot.setVisibility(View.VISIBLE);

            qrcodeText.setTextColor(Color.WHITE);
            qrcodeDot.setVisibility(View.INVISIBLE);
            // TODO: 启动条形码识别逻辑
        });

        layoutQrcode.setOnClickListener(v -> {
            currentMode = "qrcode";
            qrcodeText.setTextColor(Color.YELLOW);
            qrcodeDot.setVisibility(View.VISIBLE);

            barcodeText.setTextColor(Color.WHITE);
            barcodeDot.setVisibility(View.INVISIBLE);
            // TODO: 启动二维码识别逻辑
        });
    }

    // 从主页监听设置按钮点击并切换
    private void main2settings() {
        settingsBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent m2sIntent = new Intent(ScannerMainPage.this, SettingPage.class);
                startActivity(m2sIntent);
            }
        });
    }
}
