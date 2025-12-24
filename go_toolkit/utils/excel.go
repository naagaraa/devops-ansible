package utils

import (
	"fmt"

	"github.com/xuri/excelize/v2"
)

// ReadExcel baca file Excel dan return array 2 dimensi string
func ReadExcel(filePath string, sheetName string) ([][]string, error) {
	f, err := excelize.OpenFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("gagal buka file: %w", err)
	}

	rows, err := f.GetRows(sheetName)
	if err != nil {
		return nil, fmt.Errorf("gagal baca sheet: %w", err)
	}

	return rows, nil
}
