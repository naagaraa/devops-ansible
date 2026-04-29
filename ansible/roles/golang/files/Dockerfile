
# ---- Stage 1: Builder ----
# Gunakan golang:1.24-alpine sebagai base image untuk proses build (cache invalidation - 20260427)
FROM golang:1.24-alpine AS builder

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Salin file go.mod dan go.sum terlebih dahulu untuk memanfaatkan cache layer Docker
COPY go.mod go.sum ./

# Unduh dependensi
RUN go mod download

# Salin sisa kode sumber aplikasi
COPY . .

# Build aplikasi Go
# CGO_ENABLED=0: Memastikan binary bersifat statically linked.
# GOOS=linux GOARCH=amd64: Menentukan target OS dan arsitektur secara eksplisit.
# -ldflags="-s -w": Menghapus simbol debug dan informasi DWARF, mengurangi ukuran binary.
# -o /app/artisan: Menentukan path output dan nama executable 'artisan' dari ./cmd/artisan
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/artisan ./cmd/artisan

# ---- Stage 2: Runtime ----
# Gunakan gcr.io/distroless/static-debian12 untuk lingkungan runtime yang minimal dan aman.
# Image ini hanya berisi aplikasi dan dependensi runtime langsungnya, tanpa shell.
FROM gcr.io/distroless/static-debian12 AS runtime

# Tentukan direktori kerja
WORKDIR /app

# Salin binary yang sudah dikompilasi secara statis dari stage builder
COPY --from=builder /app/artisan /app/artisan

# Atur aplikasi untuk berjalan sebagai non-root user.
# distroless/static-debian12 tidak memiliki user/group default yang sudah ada.
# Jika aplikasi Anda memerlukan permission user spesifik, Anda biasanya perlu membuat user dan group di sini.
# Untuk banyak aplikasi Go yang dikompilasi dengan CGO_ENABLED=0, menjalankan sebagai root di container
# seringkali dapat diterima jika tidak melakukan operasi yang memerlukan hak akses khusus.
# Namun, untuk mengikuti praktik terbaik dan permintaan prompt:
# Kita akan mencoba menjalankan sebagai user ID 1000, yang umum untuk user non-root pertama.
# Jika aplikasi Anda memerlukan permission user tertentu atau gagal karena user ID, sesuaikan ini.
USER 1000

# Ekspos port yang akan didengarkan oleh aplikasi.
# PENTING: Ini harus sesuai dengan port yang dikonfigurasi aplikasi Go Anda.
# Jika aplikasi Anda menggunakan environment variable untuk port, pastikan itu diatur dengan benar.
EXPOSE 8080

# Healthcheck dihilangkan karena gcr.io/distroless/static-debian12 tidak menyertakan
# tool seperti `curl` atau `wget` yang diperlukan untuk health check eksternal.
# Untuk setup production-ready, pertimbangkan:
# 1. Membuat aplikasi Go Anda mengekspos endpoint /healthz yang mengembalikan 200 OK.
# 2. Menggunakan image runtime yang lebih inklusif jika tool health check eksternal adalah wajib.

# Tentukan command untuk menjalankan aplikasi
ENTRYPOINT ["/app/artisan"]
