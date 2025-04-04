package models

import "time"

type BoundRecord struct {
	ID            int       `gorm:"primaryKey" json:"id"`
	ShopID        int       `gorm:"column:shop_id" json:"shop_id"`
	ProductID     int       `gorm:"column:product_id" json:"product_id"`
	OperationType string    `gorm:"column:operation_type" json:"operation_type"`
	Quantity      int       `gorm:"column:quantity" json:"quantity"`
	Operator      string    `gorm:"column:operator" json:"operator"`
	LogDate       time.Time `gorm:"column:log_date" json:"log_date"`

	ProductCode string `gorm:"column:product_code" json:"product_code"`
	Category    string `gorm:"column:category" json:"category"`
	Name        string `gorm:"column:product_name"`
	Spec        string `gorm:"column:spec" json:"spec"`
	Location    string `gorm:"column:location" json:"location"`
	Remarks     string `gorm:"column:remarks" json:"remarks"`

	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`
}

func (BoundRecord) TableName() string {
	return "product_logs"
}
