package middleware

import (
	"backend/models"
	"backend/utils"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func JWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 从 Header 中获取 Authorization: Bearer xxx
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "缺少或错误的Token"})
			c.Abort()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		// 验证 token
		claims, err := utils.ParseToken(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token 无效或过期"})
			c.Abort()
			return
		}

		// 保存用户信息到上下文（你可以在这里从 DB 查用户）
		user := models.User{
			ID:         claims.UserID,
			Username:   claims.Username,
			RoleID:     claims.RoleID,
			Permission: claims.Permission,
			ShopID:     claims.ShopID,
			FactoryID:  claims.FactoryID,
		}
		c.Set("user", user)

		c.Next()
	}
}
