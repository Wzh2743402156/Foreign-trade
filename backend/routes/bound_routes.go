package routes

import (
	"backend/handlers"
	"github.com/gin-gonic/gin"
)

func RegisterBoundRoutes(r *gin.Engine) {
	// 出入库相关接口
	bound := r.Group("/api")
	{
		bound.POST("/outbound", handlers.InsertOutboundRecord)
		// 可选：后续新增入库接口
		// bound.POST("/inbound", handlers.InsertInboundRecord)
	}
}
