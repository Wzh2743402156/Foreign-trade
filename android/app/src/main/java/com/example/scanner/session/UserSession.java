package com.example.scanner.session;

public class UserSession {
    public static String username;
    public static String userId;
    public static String role;         // "shop", "factory", "admin"
    public static String shopId;
    public static String factoryId;

    public static void clear() {
        username = null;
        userId = null;
        role = null;
        shopId = null;
        factoryId = null;
    }
}
