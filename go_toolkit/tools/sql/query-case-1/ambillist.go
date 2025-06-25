package main

import (
	"fmt"
	"log"

	"go_toolkit/config"
)

func main() {
	db := config.ConnectDB()
	defer db.Close()

	rows, err := db.Query("SELECT nip FROM hse_mcu_jadwal WHERE card_device IS NULL")
	if err != nil {
		log.Fatalf("Gagal query: %v", err)
	}
	defer rows.Close()

	var nip string
	count := 0

	fmt.Println("NIP yang belum punya card_device:")
	fmt.Println("----------------------------------")
	for rows.Next() {
		if err := rows.Scan(&nip); err != nil {
			log.Fatalf("Gagal scan NIP: %v", err)
		}
		fmt.Println(nip)
		count++
	}

	if err := rows.Err(); err != nil {
		log.Fatalf("Error pada rows: %v", err)
	}

	fmt.Printf("\nTotal NIP ditemukan: %d\n", count)
}
