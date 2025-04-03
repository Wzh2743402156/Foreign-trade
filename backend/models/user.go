package models

import "time"

type User struct {
	ID         int       `gorm:"primaryKey" json:"id"`
	Username   string    `gorm:"unique" json:"username"`
	Password   string    `json:"password"`
	RoleID     int       `gorm:"column:role_id" json:"role_id"`
	Permission string    `json:"permission"`
	ShopID     int       `gorm:"column:shop_id" json:"shop_id"`
	FactoryID  int       `gorm:"factory_id" json:"factory_id"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}
