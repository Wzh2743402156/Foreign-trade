package pkg

import (
	"context"
	"log"
	"os"

	"github.com/go-redis/redis/v8"
	"github.com/joho/godotenv"
)

var RedisClient *redis.Client
var Ctx = context.Background()

func init() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Println("⚠️ 未加载 .env 文件，使用系统环境变量")
	}

	addr := os.Getenv("REDIS_HOST") + ":" + os.Getenv("REDIS_PORT")
	password := os.Getenv("REDIS_PASSWORD")

	RedisClient = redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: password,
		DB:       0,
	})

	// 可选：测试连接
	if _, err := RedisClient.Ping(Ctx).Result(); err != nil {
		log.Fatalf("❌ Redis 连接失败: %v", err)
	} else {
		log.Println("✅ Redis 连接成功")
	}
}
