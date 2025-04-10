package com.example.scanner.utils;

import android.app.Dialog;
import android.content.Context;
import android.view.Window;
import android.view.WindowManager;

import com.airbnb.lottie.LottieAnimationView;
import com.airbnb.lottie.LottieDrawable;
import com.example.scanner.R;

public class LottieDialog {
    private static Dialog dialog;

    public static void showLoading(Context context, String message) {
        dialog = new Dialog(context);
        dialog.setContentView(R.layout.dialog_lottie_loading);
        dialog.setCancelable(false);

        Window window = dialog.getWindow();
        if (window != null) {
            window.setBackgroundDrawableResource(android.R.color.transparent);
            window.setLayout(WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.WRAP_CONTENT);
        }

        dialog.show();

        // 设置动画
        LottieAnimationView lav = dialog.findViewById(R.id.lottie_view);
        lav.setAnimation("loading.json");      // 从 assets/loading.json 加载
        lav.setRepeatCount(LottieDrawable.INFINITE);
        lav.playAnimation();
    }

    public static void dismiss() {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
    }
}
