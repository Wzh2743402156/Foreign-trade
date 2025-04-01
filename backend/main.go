package main

import (
	"backend/db"
	"backend/routes"
)

func main() {
	db.InitMultiDB()

	r := routes.SetupRouter()

	r.Run(":8080")
}
