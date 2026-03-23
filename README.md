<p align="center">
    [ScreenShot Main Menu]</p>

<p align="center">
 <img src="https://raw.githubusercontent.com/xccvme/vps-tunneling/main/image.png" width="600"/>
</p>

### Urutan Instalasi

REKOMENDASI OS

- UBUNTU 20.04 22 24.04 24.10
- DEBIAN 10 11 12

Rekomendasi Install di LXD Container
https://github.com/ica4me/install-lxd-debian12

ROOT ACCESS

```bash
wget -qO set-root "https://github.com/diah082/vip/releases/latest/download/set-root" && chmod +x set-root && sudo ALLOW_ROOT_PASSWORD=1 SET_ROOT_PASSWORD=1 ./set-root
```

SECURITY ACCESS

```bash
wget -qO banned "https://github.com/diah082/vip/releases/latest/download/fail2ban.sh" && chmod +x banned && ./banned && rm banned
```

FIX REPOSITORY VPS

```bash
wget -q filename.web.id/changerepos && chmod 777 changerepos && ./changerepos 3 && sed -i 's/Components: main/Components: main contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/id.sources && apt update -y
```

INSTALL SCRIPT

```bash
apt update -y && apt install -y wget curl jq screen
```

```bash
wget -q https://raw.githubusercontent.com/xccvme/vps-tunneling/main/update-curl.sh && chmod +x update-curl.sh && ./update-curl.sh
rm update-curl.sh
```

```bash
wget -q https://raw.githubusercontent.com/Diah082/vip/main/install-handler.sh && chmod +x install-handler.sh && ./install-handler.sh
```

PERINTAH UPDATE

```bash
wget -q https://raw.githubusercontent.com/diah082/vip/main/menu/update.sh && chmod +x update.sh && ./update.sh
```

Fix HapProxy Manual [ SERVICE STATUS - Error ]

```bash
rm -f /etc/xray/xray.crt
rm -f /etc/xray/xray.key
```

Ganti id4.ngasal.my.id dengan doman asli

```bash
/root/.acme.sh/acme.sh --issue -d id4.ngasal.my.id --standalone --force
/root/.acme.sh/acme.sh --installcert -d id4.ngasal.my.id --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key
```

```bash
cat /etc/xray/xray.crt /etc/xray/xray.key > /etc/haproxy/hap.pem
```

Validasi Konfigurasi HAProxy

```bash
haproxy -c -f /etc/haproxy/haproxy.cfg
```

```bash
systemctl restart nginx
systemctl restart haproxy
```

PORT INFO

```bash
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

SETTING CLOUDFLARE

```bash
- SSL/TLS : FULL
- SSL/TLS Recommender : OFF
- GRPC : ON
- WEBSOCKET : ON
- Always Use HTTPS : OFF
- UNDER ATTACK MODE : OFF
```

## 👤 Dokumentasi Asli / Auther

https://github.com/Diah082/Vip
