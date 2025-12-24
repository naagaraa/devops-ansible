package utils

import "strings"

// EscapeString memastikan tanda kutip tunggal dan backslash tidak bikin query error
func EscapeString(str string) string {
	str = strings.ReplaceAll(str, "'", "''")    // Escape '
	str = strings.ReplaceAll(str, "\\", "\\\\") // Escape \
	return str
}
