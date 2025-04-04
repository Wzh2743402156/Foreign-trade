package handlers

import (
	"backend/db"
	"backend/models"
	"backend/pkg"
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
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

	var product models.Product
	if err := shopDB.Where("intl_barcode = ?", req.Barcode).First(&product).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "找不到对应商品"})
		return
	}

	if product.Status == "outbound" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "商品已出库，不能重复出库"})
		return
	}

	var inventory models.Inventory
	if err := shopDB.Where("product_id = ? AND shop_id = ?", product.ID, product.ShopID).First(&inventory).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "库存记录不存在"})
		return
	}
	if inventory.CurrentQuantity < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "库存不足"})
		return
	}

	record := models.BoundRecord{
		ShopID:        product.ShopID,
		ProductID:     product.ID,
		Quantity:      1,
		Operator:      req.Operator,
		LogDate:       time.Now(),
		OperationType: "outbound",
		Remarks:       "扫码出库",
		ProductCode:   product.ProductCode,
		Category:      product.Category,
		Name:          product.Name,
		Spec:          product.Spec,
		Location:      product.Location,
	}

	tx := shopDB.Begin()
	if err := tx.Create(&record).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "出库记录创建失败"})
		return
	}

	inventory.CurrentQuantity -= 1
	inventory.OutboundTotal += 1
	if err := tx.Save(&inventory).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新库存失败"})
		return
	}

	product.Status = "outbound"
	if err := tx.Save(&product).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新产品状态失败"})
		return
	}
	tx.Commit()

	// ✅ 主动回调 Redis 服务
	go func() {
		ackUrl := os.Getenv("REDIS_ACK_URL")
		payload := map[string]string{
			"barcode": req.Barcode,
			"user":    req.Operator,
		}
		data, _ := json.Marshal(payload)
		resp, err := http.Post(ackUrl, "application/json", bytes.NewBuffer(data))
		if err != nil {
			log.Println("❌ Redis ack 回调失败:", err)
		} else {
			defer resp.Body.Close()
			log.Println("✅ Redis ack 回调成功")
		}
	}()

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"recordId": record.ID,
	})
}

func ConfirmAck(c *gin.Context) {
	var body struct {
		Barcode string `json:"barcode"`
		User    string `json:"user"`
	}
	if err := c.BindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "参数错误"})
		return
	}

	redisKey := fmt.Sprintf("scan_records:%s", body.User)
	_, err := pkg.RedisClient.LRem(pkg.Ctx, redisKey, 1, body.Barcode).Result()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Redis 删除失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true})
}
