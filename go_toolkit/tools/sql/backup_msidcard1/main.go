package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"log"
	"os"

	"go_toolkit/config"
)

func main() {
	db := config.ConnectDB()
	defer db.Close()

	nikList := []string{
		"010212-10349", "010310-11596", "010404-11796", "010405-11564", "010512-11015",
		"010904-2963", "011112-11946", "011211-9949", "140918-27976", "040304-962",
		"040313-12514", "040405-11785", "040412-10772", "050104-323", "050608-6753",
		"050712-11315", "060117-23708", "060913-13626", "080904-3030", "081112-11976",
		"091213-14389", "100214-15029", "110515-18641", "110713-13352", "110713-13355",
		"110713-13399", "120220-31712", "120220-31740", "120314-15263", "121010-8658",
		"121118-28297", "121211-10065", "130312-10587", "130511-9370", "131106-6221",
		"140711-9502", "140711-9529", "140813-13468", "141011-9685", "141111-9876",
		"150114-14756", "150305-4692", "151114-17318", "160711-11779", "160818-27869",
		"161013-14025", "190210-8009", "190210-8011", "190406-6023", "201004-3671",
		"201211-10152", "210113-12118", "210114-14797", "210114-14830", "210306-5950",
		"210311-9151", "210311-9189", "210412-10852", "210511-11757", "221209-11593",
		"230120-31458", "230209-7062", "230317-24371", "230604-2306", "240214-15112",
		"240613-13258", "240613-13269", "240613-13275", "241114-17512", "250504-11657",
		"250809-7669", "270111-8970", "270111-8971", "270207-6407", "270615-19144",
		"270812-11383", "270812-11406", "270813-13548", "280109-6913", "280220-31912",
		"281004-4019", "291004-4071", "301004-4156", "310506-6066", "310511-9399",
		"310513-13121", "240222-39019", "010223-43440", "140223-43717", "131221-38490",
		"241122-42634",
	}

	query := `
		SELECT CARDNODEVICE, NIK, EMPNM, DEPTID
		FROM MSIDCARD
		WHERE NIK = ?
		ORDER BY CHANGEDON DESC
		LIMIT 1
	`

	// Buat file CSV
	file, err := os.Create("export1.csv")
	if err != nil {
		log.Fatalf("❌ Gagal membuat file CSV: %v", err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	// Header CSV
	writer.Write([]string{"CARDNODEVICE", "NIK", "EMPNM", "DEPTID"})

	// Loop dan isi baris CSV
	for _, nik := range nikList {
		var cardNode, nikResult, empnm, deptid string
		err := db.QueryRow(query, nik).Scan(&cardNode, &nikResult, &empnm, &deptid)

		if err != nil {
			if err == sql.ErrNoRows {
				fmt.Printf("❌ NIK %s: Data tidak ditemukan.\n", nik)
				continue
			}
			log.Printf("❌ NIK %s: Gagal query: %v\n", nik, err)
			continue
		}

		record := []string{cardNode, nikResult, empnm, deptid}
		if err := writer.Write(record); err != nil {
			log.Printf("❌ Gagal menulis CSV untuk NIK %s: %v\n", nik, err)
		}
	}

	fmt.Println("✅ Export selesai! File: export.csv")
}
