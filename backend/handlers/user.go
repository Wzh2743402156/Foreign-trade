package handlers

import (
	"backend/db"
	"backend/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

// 获取用户详细信息（含用户名、角色、权限、店铺/工厂名等）
func GetUserDetail(c *gin.Context) {
	userRaw, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未登录"})
		return
	}

	user, ok := userRaw.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "用户数据异常"})
		return
	}

	// 初始化返回值
	resp := gin.H{
		"username":   user.Username,
		"role_id":    user.RoleID,
		"permission": user.Permission,
	}

	// 可选：添加店铺或工厂名称
	shopDB := db.DBs["shop_db"]

	// 获取商店或工厂名
	if user.RoleID == 2 || user.RoleID == 3 {
		var shop struct {
			ID   int
			Name string
		}
		err := shopDB.Raw("SELECT id, name FROM shops WHERE id = ?", user.ShopID).Scan(&shop).Error
		if err == nil {
			resp["shop_id"] = shop.ID
			resp["shop_name"] = shop.Name
		}
	}

	factoryDB := db.DBs["factory_db"]
	if user.RoleID == 4 || user.RoleID == 5 {
		var factory struct {
			ID   int
			Name string
		}
		err := factoryDB.Raw("SELECT id, name FROM factories WHERE id = ?", user.FactoryID).Scan(&factory).Error
		if err == nil {
			resp["factory_id"] = factory.ID
			resp["factory_name"] = factory.Name
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    resp,
	})
}
