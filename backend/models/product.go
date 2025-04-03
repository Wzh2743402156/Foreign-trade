package models

type Product struct {
	ID          uint   `json:"id"`
	ShopID      uint   `json:"shop_id"`
	ProductCode string `json:"product_code"`
	IntlBarcode string `json:"intl_barcode"`
	Name        string `json:"name"`
	Category    string `json:"category"`
	Spec        string `json:"spec"`
	Location    string `json:"location"`
	Remarks     string `json:"remarks"`
}

func (Product) TableName() string {
	return "products"
}
