package routes

import (
	"backend/handlers"
	"github.com/gin-gonic/gin"
)

func RegisterShopRoutes(r *gin.Engine) {
	shop := r.Group("/api/shop")
	{
		shop.GET("/inventory", handlers.GetInventoryByShopID) // 商品状态概览查询
		shop.GET("/stats", handlers.GetShopStats)             // 数据统计查询
		shop.POST("/update_alert", handlers.UpdateAlertLine)  // 警戒线修改
		shop.GET("/products", handlers.GetProductsByShop)     // 商品查询
		shop.DELETE("/products/:id", handlers.DeleteProduct)  // 删除商品
	}
}
