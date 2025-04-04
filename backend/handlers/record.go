package handlers

import (
	"backend/db"
	"backend/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

type RecordRequest struct {
	Barcode  string `json:"barcode"`
	Operator string `json:"operator"`
}

func InsertOutboundRecord(c *gin.Context) {
	var req RecordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "参数错误"})
		return
	}

	shopDB := db.DBs["shop_db"]

	// 查找商品
	var product models.Product
	if err := shopDB.Where("intl_barcode = ?", req.Barcode).First(&product).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "找不到对应商品"})
		return
	}

	// 构造出库记录
	record := models.BoundRecord{
		ShopID:        product.ShopID,
		ProductID:     product.ID,
		Quantity:      1, // 默认每次出库1个，可拓展
		Operator:      req.Operator,
		Date:          time.Now(),
		OperationType: "outbound",
		Remarks:       "扫码出库",
	}

	if err := shopDB.Create(&record).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "记录保存失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"recordId": record.ID,
	})
}
