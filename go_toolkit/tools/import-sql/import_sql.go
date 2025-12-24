package main

import (
	"os"
	"strings"

	"go_toolkit/config"
	"log"
)

func main() {
	db := config.ConnectDB()
	defer db.Close()

	content, err := os.ReadFile("backup_output.sql")
	if err != nil {
		log.Fatalf("Gagal baca file: %v", err)
	}

	queries := strings.Split(string(content), ";")
	for _, q := range queries {
		q = strings.TrimSpace(q)
		if q == "" || strings.HasPrefix(q, "--") {
			continue
		}

		_, err := db.Exec(q)
		if err != nil {
			log.Printf("Gagal eksekusi: %v\nSQL: %s\n", err, q)
		}
	}

	log.Println("Import selesai.")
}
