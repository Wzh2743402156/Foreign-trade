package routes

import (
	"backend/handlers"
	"github.com/gin-gonic/gin"
)

func RegisterShopRoutes(r *gin.Engine) {
	shop := r.Group("/api/shop")
	{
		shop.GET("/inventory", handlers.GetInventoryByShopID)
		shop.GET("/stats", handlers.GetShopStats)
	}
}
