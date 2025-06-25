package config

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func ConnectDB() *sql.DB {
	// Ganti sesuai kebutuhan lo
	host := "127.0.0.1"
	port := "3306"
	user := "nagara"
	password := "password;"
	dbname := "pas"

	// host := "192.168.154.44"
	// port := "3306"
	// user := "support"
	// password := "support123"
	// dbname := "parking"

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4",
		user, password, host, port, dbname)

	// dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8",
	// 	user, password, host, port, dbname)

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("❌ Gagal buka koneksi DB: %v", err)
	}

	if err := db.Ping(); err != nil {
		log.Fatalf("❌ Ping ke DB gagal: %v", err)
	}

	return db
}
