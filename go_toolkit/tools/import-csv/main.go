package main

import (
	"crypto/sha256"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"time"

	"database/sql"
	"go_toolkit/config"

	_ "github.com/go-sql-driver/mysql"
)

func generatePassword(nik string) string {
	hash := sha256.Sum256([]byte(nik))
	return fmt.Sprintf("%x", hash)[:12] // ambil 12 karakter awal
}

func getTTLFromJadwal(db *sql.DB, nip string) *time.Time {
	var ttl time.Time
	err := db.QueryRow(`SELECT tanggal_lahir FROM hse_mcu_jadwal WHERE nip = ? LIMIT 1`, nip).Scan(&ttl)
	if err != nil {
		// TTL tidak ditemukan, pakai default
		defaultTTL, _ := time.Parse("2006-01-02", "1990-01-01")
		return &defaultTTL
	}
	return &ttl
}

func main() {
	db := config.ConnectDB()
	defer db.Close()

	file, err := os.Open("export1.csv") // ganti nama file kalau beda
	if err != nil {
		log.Fatal("❌ Gagal buka CSV:", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		log.Fatal("❌ Gagal baca CSV:", err)
	}

	for i, row := range records {
		if i == 0 {
			continue // skip header
		}

		cardDevice := row[0]
		nik := row[1]
		nama := row[2]

		password := generatePassword(nik)
		active := "Y"
		now := time.Now()
		ttl := getTTLFromJadwal(db, nik)

		_, err := db.Exec(`
			INSERT INTO hse_mcu_karyawan_resiko (
				nip, nama, card_device, password, active, created_at, updated_at,
				departemen_id, divisi_id, area_kerja_id, ttl, jenis_kelamin, email,
				no_handphone, gol_darah, lama_kerja, status_pernikahan, posisi,
				auth_token, token_expires_at, hr_karyawan_id, created_by, updated_by
			) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		`, nik, nama, cardDevice, password, active, now, now,
			nil, nil, nil,
			*ttl, "", nil,
			nil, nil, nil,
			nil, nil,
			nil, nil, nil,
			999, 999)

		if err != nil {
			log.Printf("❌ Gagal insert NIK %s: %v\n", nik, err)
			continue
		}

		fmt.Printf("✅ Berhasil insert: %s (%s)\n", nik, nama)
	}

	fmt.Println("✅ Import CSV selesai ke tabel hse_mcu_karyawan_resiko.")
}
