package routes

import (
	"backend/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// CORS 支持
	r.Use(middleware.CORSMiddleware())

	// 登录相关（无需鉴权）
	RegisterAuthRoutes(r)

	// 用户信息相关（需要鉴权）
	RegisterUserRoutes(r)

	// 店铺模块
	RegisterShopRoutes(r)

	// 扫码出入库模块
	RegisterBoundRoutes(r)

	// TODO: 注册 Boss 和 Factory 路由
	// RegisterBossRoutes(r)
	// RegisterFactoryRoutes(r)

	return r
}
