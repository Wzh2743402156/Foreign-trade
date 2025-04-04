package models

type Product struct {
	ID            int    `gorm:"column:id"`
	ShopID        int    `gorm:"column:shop_id"`
	FactoryID     int    `gorm:"column:factory_id"`
	ProductCode   string `gorm:"column:product_code"`
	Category      string `gorm:"column:category"`
	Name          string `gorm:"column:name"`
	Spec          string `gorm:"column:spec"`
	Location      string `gorm:"column:location"`
	IntlBarcode   string `gorm:"column:intl_barcode"`
	PackageID     int    `gorm:"column:package_id"`
	PackageStatus string `gorm:"column:package_status"`
	Status        string `gorm:"column:status"`
}

func (Product) TableName() string {
	return "products"
}
