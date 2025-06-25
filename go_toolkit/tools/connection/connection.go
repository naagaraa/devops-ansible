package main

import (
	"fmt"
	"log"

	"go_toolkit/config"
)

func main() {
	db := config.ConnectDB()
	defer func() {
		if err := db.Close(); err != nil {
			log.Fatalf("❌ Gagal menutup koneksi DB: %v", err)
		}
	}()

	fmt.Println("✅ Koneksi ke database berhasil.")
}
