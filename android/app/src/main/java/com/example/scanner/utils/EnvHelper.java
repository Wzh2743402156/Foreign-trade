package com.example.scanner.utils;

import android.content.Context;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class EnvHelper {
    public static String getValue(Context context, String key) {
        try {
            InputStream is = context.getAssets().open("env.properties");
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("=")) {
                    String[] parts = line.split("=", 2);
                    if (parts[0].trim().equals(key)) {
                        return parts[1].trim();
                    }
                }
            }
        } catch (Exception e) {
            Log.e("EnvHelper zhihanwang", "读取 env 失败: " + e.getMessage());
        }
        return null;
    }
}
