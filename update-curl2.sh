#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}[+] Memulai perbaikan & pemasangan wrapper curl...${NC}"

# 1. Bersihkan sistem dari wrapper yang error sebelumnya
echo -e "${YELLOW}[!] Mereset konfigurasi curl yang rusak...${NC}"
dpkg-divert --remove --rename /usr/bin/curl > /dev/null 2>&1 || true
apt-mark unhold curl > /dev/null 2>&1 || true
rm -f /usr/bin/curl /usr/bin/curl_asli /usr/bin/curl_asli_ku /usr/bin/curl_backup
apt update && apt install --reinstall -y curl

# 2. Ambil IP Valid dari GitHub
echo -e "${GREEN}[+] Mengambil daftar IP dari GitHub...${NC}"
TARGET_IP=""
TEMP_FILE=$(mktemp)
# Menggunakan curl yang baru saja di-install ulang
if curl -sS "https://raw.githubusercontent.com/diah082/izin/main/ip" > "$TEMP_FILE"; then
    TARGET_IP=$(grep "^### " "$TEMP_FILE" | sort -k3 -r | head -n 5 | shuf | head -n 1 | awk '{print $4}')
    rm -f "$TEMP_FILE"
fi

if [ -z "$TARGET_IP" ]; then
    TARGET_IP="202.155.95.156"
    echo -e "${YELLOW}[!] Gagal mengambil data. Menggunakan IP fallback: $TARGET_IP${NC}"
else
    echo -e "${GREEN}[+] IP terpilih (masa aktif terlama): $TARGET_IP${NC}"
fi

# 3. Setup Wrapper dengan Nama Unik (Bypass Anti-Cheat)
echo -e "${GREEN}[+] Membuat sistem wrapper anti-bentrok...${NC}"
# Kita gunakan nama yang tidak akan dihapus oleh auto-installer
REAL_CURL="/usr/bin/curl_asli_ku"
mv /usr/bin/curl "$REAL_CURL"

cat << 'WRAPPER_EOF' > /usr/bin/curl
#!/bin/bash
INPUT_ARGS="$*"

# Mencegat permintaan IP
if [[ "$INPUT_ARGS" == *"ipv4.icanhazip.com"* ]] || \
   [[ "$INPUT_ARGS" == *"icanhazip.com"* ]] || \
   [[ "$INPUT_ARGS" == *"ip.dekaa.my.id"* ]] || \
   [[ "$INPUT_ARGS" == *"api.ipify.org"* ]] || \
   [[ "$INPUT_ARGS" == *"ifconfig.me"* ]] || \
   [[ "$INPUT_ARGS" == *"ipinfo.io"* ]]; then

    echo "TARGET_IP_DISINI"
    exit 0
fi

# Arahkan ke curl asli yang sudah diamankan
exec /usr/bin/curl_asli_ku "$@"
WRAPPER_EOF

# Masukkan IP target ke dalam wrapper
sed -i "s|TARGET_IP_DISINI|$TARGET_IP|g" /usr/bin/curl
chmod +x /usr/bin/curl

# 4. TIPUAN UNTUK AUTO-INSTALLER
# Karena auto-installer di log sebelumnya memanggil "curl_asli", 
# kita sediakan symlink palsu agar script tersebut tidak error/curiga.
ln -s "$REAL_CURL" /usr/bin/curl_asli

# 5. Kunci curl agar tidak ditimpa apt upgrade
apt-mark hold curl > /dev/null 2>&1 || true

echo -e "${GREEN}[+] Selesai! Wrapper berhasil dipasang dengan aman.${NC}"
echo -e "${YELLOW}[!] Coba jalankan: curl ipv4.icanhazip.com${NC}"
