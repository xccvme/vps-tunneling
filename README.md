<p align="center">
    [ScreenShot Main Menu]</p>

<p align="center">
 <img src="https://raw.githubusercontent.com/xccvme/vps-tunneling/main/image.png" width="600"/>
</p>

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
