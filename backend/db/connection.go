package db

import (
	"log"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DBs = make(map[string]*gorm.DB)

func InitMultiDB() {
	// core_db
	coreDSN := "root:123456@tcp(8.130.70.249:3306)/core_db?charset=utf8mb4&parseTime=True&loc=Local"
	coreDB, err := gorm.Open(mysql.Open(coreDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 core_db 失败: %v", err)
	}
	DBs["core_db"] = coreDB

	// shop_db
	shopDSN := "root:123456@tcp(8.130.70.249:3306)/shop_db?charset=utf8mb4&parseTime=True&loc=Local"
	shopDB, err := gorm.Open(mysql.Open(shopDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 shop_db 失败: %v", err)
	}
	DBs["shop_db"] = shopDB

	// manufacturer_db
	factoryDSN := "root:123456@tcp(8.130.70.249:3306)/manufacturer_db?charset=utf8mb4&parseTime=True&loc=Local"
	factoryDB, err := gorm.Open(mysql.Open(factoryDSN), &gorm.Config{})
	if err != nil {
		log.Fatalf("连接 manufacturer_db 失败: %v", err)
	}
	DBs["manufacturer_db"] = factoryDB

	log.Println("所有数据库连接成功")
}

func GetDBByRole(roleID int) *gorm.DB {
	switch roleID {
	case 2, 3:
		return DBs["shop_db"]
	case 4, 5:
		return DBs["manufacturer_db"]
	default:
		return DBs["core_db"]
	}
}
