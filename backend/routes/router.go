package routes

import (
	"backend/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// 加入 CORS 中间件
	r.Use(middleware.CORSMiddleware())

	RegisterAuthRoutes(r)
	RegisterShopRoutes(r)
	// RegisterBossRoutes(r)

	return r
}
