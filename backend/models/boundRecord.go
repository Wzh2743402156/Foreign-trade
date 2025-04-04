package models

import "time"

type BoundRecord struct {
	ID            uint      `gorm:"primaryKey"`
	ShopID        uint      `json:"shop_id"`
	ProductID     uint      `json:"product_id"`
	Quantity      int       `json:"quantity"`
	Operator      string    `json:"operator"`
	Date          time.Time `json:"date"`
	OperationType string    `json:"operation_type"`
	Remarks       string    `json:"remarks"`
}

func (BoundRecord) TableName() string {
	return "product_logs"
}
