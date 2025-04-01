package models

import "time"

type User struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Username  string    `gorm:"unique" json:"username"`
	Password  string    `json:"password"`
	RoleID    int       `gorm:"column:role_id" json:"role_id"`
	ShopID    int       `gorm:"column:shop_id" json:"shop_id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
