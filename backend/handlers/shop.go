package handlers

import (
	"backend/db"
	"backend/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetInventoryByShopID(c *gin.Context) {
	shopID := c.Query("shop_id")
	if shopID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "shop_id 不能为空"})
		return
	}

	shopDB := db.DBs["shop_db"]
	var inventory []models.Inventory
	if err := shopDB.Where("shop_id = ?", shopID).Find(&inventory).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "查询失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": inventory})
}

func GetShopStats(c *gin.Context) {
	shopID := c.Query("shop_id")
	if shopID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "shop_id 不能为空"})
		return
	}

	shopDB := db.DBs["shop_db"]
	var stats []models.ShopDailyStats
	if err := shopDB.Raw("SELECT date, total_in, total_out, stock FROM shop_daily_stats WHERE shop_id = ? ORDER BY date ASC", shopID).Scan(&stats).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "统计数据查询失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": stats})
}
