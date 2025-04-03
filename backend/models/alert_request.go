package models

type UpdateAlertRequest struct {
	ShopID    uint `json:"shop_id"`
	ProductID uint `json:"product_id"`
	AlertLow  int  `json:"alert_low"`
	AlertHigh int  `json:"alert_high"`
}
