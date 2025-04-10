package com.example.scanner.utils;

import org.json.JSONObject;

public class JsonUtils {

    /**
     * 尝试将字符串转换为 JSONObject，如果不是合法 JSON，返回 null。
     */
    public static JSONObject tryParseJson(String raw) {
        try {
            return new JSONObject(raw);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 判断一个字符串是否为合法 JSON。
     */
    public static boolean isValidJson(String raw) {
        return tryParseJson(raw) != null;
    }
}
