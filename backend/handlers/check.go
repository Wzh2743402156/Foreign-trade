package handlers

import (
	"backend/db"
	"backend/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

type CheckRequest struct {
	Barcode string `json:"barcode"`
}

func CheckProduct(c *gin.Context) {
	var req CheckRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "参数错误"})
		return
	}

	factoryDB := db.DBs["factory_db"]
	var product models.Product
	if err := factoryDB.Where("intl_barcode = ?", req.Barcode).First(&product).Error; err != nil {
		c.JSON(http.StatusOK, gin.H{"exists": false})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"exists":  true,
		"product": product,
	})
}
