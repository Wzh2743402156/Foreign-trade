package db

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DBs = make(map[string]*gorm.DB)

func InitMultiDB() {
	// 加载 .env 文件
	if err := godotenv.Load(".env"); err != nil {
		log.Println("未找到 .env 文件，使用系统环境变量")
	}

	// 从环境变量读取 DSN
	coreDSN := os.Getenv("CORE_DSN")
	shopDSN := os.Getenv("SHOP_DSN")
	factoryDSN := os.Getenv("FACTORY_DSN")

	// 检查是否缺失
	if coreDSN == "" || shopDSN == "" || factoryDSN == "" {
		log.Fatal("数据库 DSN 环境变量未配置完整")
	}

	// core_db
	coreDB, err := gorm.Open(mysql.Open(coreDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 core_db 失败: %v", err)
	}
	DBs["core_db"] = coreDB

	// shop_db
	shopDB, err := gorm.Open(mysql.Open(shopDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 shop_db 失败: %v", err)
	}
	DBs["shop_db"] = shopDB

	// factory_db
	factoryDB, err := gorm.Open(mysql.Open(factoryDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 factory_db 失败: %v", err)
	}
	DBs["factory_db"] = factoryDB

	log.Println("✅ 所有数据库连接成功（通过 .env）")
}

func GetDBByRole(roleID int) *gorm.DB {
	switch roleID {
	case 2, 3:
		return DBs["shop_db"]
	case 4, 5:
		return DBs["factory_db"]
	default:
		return DBs["core_db"]
	}
}
