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

func UpdateAlertLine(c *gin.Context) {
	var req models.UpdateAlertRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "参数错误"})
		return
	}

	shopDB := db.DBs["shop_db"]

	var inventory models.Inventory
	if err := shopDB.Where("shop_id = ? AND product_id = ?", req.ShopID, req.ProductID).First(&inventory).Error; err != nil {
		c.JSON(404, gin.H{"error": "库存记录不存在"})
		return
	}

	inventory.AlertLow = req.AlertLow
	inventory.AlertHigh = req.AlertHigh

	if err := shopDB.Save(&inventory).Error; err != nil {
		c.JSON(500, gin.H{"error": "保存失败"})
		return
	}

	c.JSON(200, gin.H{"success": true})
}

func GetProductsByShop(c *gin.Context) {
	shopID := c.Query("shop_id")
	if shopID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "shop_id 不能为空"})
		return
	}

	shopDB := db.DBs["shop_db"]

	var products []models.Product
	if err := shopDB.Where("shop_id = ?", shopID).Find(&products).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "数据库查询失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    products,
	})
}

func DeleteProduct(c *gin.Context) {
	id := c.Param("id")
	shopDB := db.DBs["shop_db"]

	if err := shopDB.Delete(&models.Product{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "删除失败"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true})
}
