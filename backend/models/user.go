package models

type User struct {
	ID       uint   `gorm:"primaryKey"`
	Username string `gorm:"unique" json:"username"`
	Password string `json:"password"`
}
