package handlers

import (
	"backend/db"
	"backend/models"
	"backend/utils"
	"github.com/gin-gonic/gin"
	"net/http"
)

func LoginHandler(c *gin.Context) {
	var req models.User
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "参数格式错误",
		})
		return
	}

	var user models.User
	// 查找用户名是否存在
	if err := db.DB.Where("username = ?", req.Username).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "账号不存在",
		})
		return
	}

	// 判断密码
	if user.Password != req.Password {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "密码错误",
		})
		return
	}

	// 创建 Token
	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Token 生成失败",
		})
		return
	}

	// 返回成功
	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "登录成功",
		"data": gin.H{
			"user_id": user.ID,
			"token":   token,
		},
	})
}
