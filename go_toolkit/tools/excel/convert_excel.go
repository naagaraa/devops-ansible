package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"go_toolkit/utils"

	"github.com/xuri/excelize/v2"
)

func main() {
    file := "data.xlsx"
    sheet := "Sheet1"
    table := "target_table"

    f, err := excelize.OpenFile(file)
    if err != nil {
        log.Fatalf("Gagal buka excel: %v", err)
    }

    rows, err := f.GetRows(sheet)
    if err != nil {
        log.Fatalf("Gagal baca sheet: %v", err)
    }

    if len(rows) < 2 {
        log.Fatal("Data kosong")
    }

    columns := rows[0]
    out, _ := os.Create("convert_output.sql")
    defer out.Close()

    for i, row := range rows[1:] {
        if len(row) == 0 {
            continue
        }

        values := make([]string, len(columns))
        for j := range columns {
            if j < len(row) {
                values[j] = "'" + utils.EscapeString(row[j]) + "'"
            } else {
                values[j] = "NULL"
            }
        }

        sql := fmt.Sprintf("INSERT INTO %s (%s) VALUES (%s);\n",
            table,
            strings.Join(columns, ", "),
            strings.Join(values, ", "),
        )

        out.WriteString(sql)
        fmt.Printf("Row %d exported\n", i+1)
    }

    fmt.Println("Selesai convert excel ke SQL.")
}
