### FIX REPOSITORY VPS

<pre><code>wget -q filename.web.id/changerepos && chmod 777 changerepos && ./changerepos 3 && sed -i 's/Components: main/Components: main contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/id.sources && apt update -y</code></pre>

### INSTALL SCRIPT

<pre><code>apt update -y && apt install -y wget curl jq screen && wget -q https://raw.githubusercontent.com/Diah082/vip/main/install-handler.sh && chmod +x install-handler.sh && ./install-handler.sh
</code></pre>

### PERINTAH UPDATE

<pre><code>wget -q https://raw.githubusercontent.com/diah082/vip/main/menu/update.sh && chmod +x update.sh && ./update.sh</code></pre>

### PERINTAH BACKUP KHUSUS

<pre><code>wget -qO /usr/sbin/backupot "https://raw.githubusercontent.com/diah082/vip/main/menu/backupot" && chmod +x /usr/sbin/backupot && backupot</code></pre>

### TESTED ON OS

- UBUNTU 20.04 22 24.04 24.10
- DEBIAN 10 11 12

## PREVIEW

![IMAGE](https://raw.githubusercontent.com/diah082/vip/main/IMG_20241019_225341_019.webp)

### FITUR TAMBAHAN

- Tambah Swap 2 GiB
- Pemasangan yang dinamis
- Register IP Dari VPS
- Pointing Domain
- Xray Core
- Penambahan fail2ban
- Auto block sebagian ads indo by default
- Auto clear log per 10 menit
- Auto deler expired
- User Details Akun
- Lock Xray
- Lock SSH
- Limit IP SSH on
- Limit IP Xray On
- Limit Qouta Xray On

### PORT INFO

```
- TROJAN WS 443
- TROJAN GRPC 443
- SHADOWSOCKS WS 443
- SHADOWSOCKS GRPC 443
- VLESS WS 443
- VLESS GRPC 443
- VLESS NONTLS 80
- VMESS WS 443
- VMESS GRPC 443
- VMESS NONTLS 80
- SSH WS / TLS 443
- SSH NON TLS 80 8880 8080 2080 2082
- SLOWDNS 5300
```

### SETTING CLOUDFLARE

```
- SSL/TLS : FULL
- SSL/TLS Recommender : OFF
- GRPC : ON
- WEBSOCKET : ON
- Always Use HTTPS : OFF
- UNDER ATTACK MODE : OFF
```
