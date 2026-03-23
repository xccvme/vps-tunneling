#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] Memulai pemasangan wrapper curl manipulasi IP${NC}"


if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[-] Script ini harus dijalankan sebagai root (sudo).${NC}"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}[!] curl tidak ditemukan. Menginstall curl...${NC}"
    apt update && apt install -y curl
fi

CURL_CMD="curl"
if [ -f "/usr/bin/curl_asli" ]; then
    CURL_CMD="/usr/bin/curl_asli"
fi

echo -e "${GREEN}[+] Mengambil daftar IP dari GitHub...${NC}"
TARGET_IP=""
TEMP_FILE=$(mktemp)
if $CURL_CMD -sS "https://raw.githubusercontent.com/diah082/izin/main/ip" > "$TEMP_FILE"; then
    TARGET_IP=$(grep "^### " "$TEMP_FILE" | sort -k3 -r | head -n 5 | shuf | head -n 1 | awk '{print $4}')
    rm -f "$TEMP_FILE"
else
    echo -e "${YELLOW}[!] Gagal mengambil data dari GitHub. Menggunakan IP fallback.${NC}"
    rm -f "$TEMP_FILE"
fi

if [ -z "$TARGET_IP" ]; then
    TARGET_IP="202.155.95.156"
    echo -e "${YELLOW}[!] Menggunakan IP fallback: $TARGET_IP${NC}"
else
    echo -e "${GREEN}[+] IP terpilih (masa aktif paling lama): $TARGET_IP${NC}"
fi

if [ ! -f "/usr/bin/curl_asli" ]; then
    echo -e "${GREEN}[+] Membackup curl asli ke /usr/bin/curl_asli...${NC}"
    mv /usr/bin/curl /usr/bin/curl_asli
else
    echo -e "${GREEN}[+] Backup curl_asli sudah ada, melewati backup.${NC}"
fi

echo -e "${GREEN}[+] Membuat wrapper curl di /usr/bin/curl...${NC}"
cat << 'WRAPPER_EOF' > /usr/bin/curl
#!/bin/bash
INPUT_ARGS="$*"

# Daftar layanan pengecekan IP publik yang sering digunakan
if [[ "$INPUT_ARGS" == *"ipv4.icanhazip.com"* ]] || \
   [[ "$INPUT_ARGS" == *"icanhazip.com"* ]] || \
   [[ "$INPUT_ARGS" == *"ip.dekaa.my.id"* ]] || \
   [[ "$INPUT_ARGS" == *"api.ipify.org"* ]] || \
   [[ "$INPUT_ARGS" == *"ifconfig.me"* ]] || \
   [[ "$INPUT_ARGS" == *"ipinfo.io"* ]] || \
   [[ "$INPUT_ARGS" == *"checkip.amazonaws.com"* ]] || \
   [[ "$INPUT_ARGS" == *"ident.me"* ]] || \
   [[ "$INPUT_ARGS" == *"ipecho.net"* ]] || \
   [[ "$INPUT_ARGS" == *"wgetip.com"* ]] || \
   [[ "$INPUT_ARGS" == *"myip.opendns.com"* ]]; then

    echo "$TARGET_IP"
    exit 0
fi

# Untuk permintaan lain, jalankan curl asli
exec /usr/bin/curl_asli "$@"
WRAPPER_EOF

sed -i "s|\$TARGET_IP|$TARGET_IP|g" /usr/bin/curl
chmod +x /usr/bin/curl

echo -e "${GREEN}[+] Menerapkan perlindungan apt-mark hold curl...${NC}"
apt-mark hold curl > /dev/null 2>&1 || true

echo -e "${GREEN}[+] Menerapkan dpkg-divert untuk perlindungan permanen...${NC}"
if ! dpkg-divert --list | grep -q "/usr/bin/curl"; then
    mv /usr/bin/curl /tmp/curl_wrapper
    mv /usr/bin/curl_asli /usr/bin/curl
    dpkg-divert --add --rename --divert /usr/bin/curl_asli /usr/bin/curl
    mv /tmp/curl_wrapper /usr/bin/curl
    chmod +x /usr/bin/curl
    echo -e "${GREEN}[+] dpkg-divert berhasil diterapkan.${NC}"
else
    echo -e "${GREEN}[+] dpkg-divert sudah aktif.${NC}"
fi

echo -e "${GREEN}[+] Selesai! Wrapper curl manipulasi IP telah terpasang.${NC}"
echo -e "${YELLOW}[!] Coba jalankan: curl ipv4.icanhazip.com${NC}"
echo -e "${YELLOW}[!] Hasil yang diharapkan: $TARGET_IP${NC}"