package com.example.scanner.overlay;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

public class ScannerOverlayView extends View {
    private Paint maskPaint;
    private Rect frameRect;

    public ScannerOverlayView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        maskPaint = new Paint();
        maskPaint.setColor(0x88000000); // 半透明黑色
    }

    public void setFrame(Rect rect) {
        this.frameRect = rect;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (frameRect == null) return;

        int width = getWidth();
        int height = getHeight();

        // 画上下左右遮罩区域
        canvas.drawRect(0, 0, width, frameRect.top, maskPaint); // 上
        canvas.drawRect(0, frameRect.bottom, width, height, maskPaint); // 下
        canvas.drawRect(0, frameRect.top, frameRect.left, frameRect.bottom, maskPaint); // 左
        canvas.drawRect(frameRect.right, frameRect.top, width, frameRect.bottom, maskPaint); // 右
    }
}
