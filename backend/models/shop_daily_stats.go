package models

type ShopDailyStats struct {
	Date     string `json:"date"`
	ShopID   int    `json:"shop_id"`
	TotalIn  int    `json:"total_in"`
	TotalOut int    `json:"total_out"`
	Stock    int    `json:"stock"`
}
