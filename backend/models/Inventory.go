// models/inventory.go
package models

type Inventory struct {
	ID              uint   `json:"id"`
	ShopID          uint   `json:"shop_id"`
	ProductID       uint   `json:"product_id"`
	CurrentQuantity int    `json:"current_quantity"`
	InboundTotal    int    `json:"inbound_total"`
	OutboundTotal   int    `json:"outbound_total"`
	AlertLow        int    `json:"alert_low"`
	AlertHigh       int    `json:"alert_high"`
	UpdatedAt       string `json:"updated_at"`
}

func (Inventory) TableName() string {
	return "inventory"
}
