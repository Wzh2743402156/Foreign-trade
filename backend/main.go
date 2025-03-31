package main

import (
	"backend/db"
	"backend/routes"
)

func main() {
	db.InitDB()
	r := routes.SetupRouter()
	r.Run(":8080")
}
