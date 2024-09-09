#!/bin/bash

# Cek apakah binary noobz tersedia
echo "Downloading Binary..."
wget -O /usr/bin/noobz https://mirror.ghproxy.com/https://github.com/noobz-id/noobzvpns/raw/master/noobzvpns.x86_64
chmod +x /usr/bin/noobz

echo "Downloading Config..."
# Download file konfigurasi dan sertifikat
wget -q -O /etc/noobzvpns/cert.pem https://0ms.dev/mirrors/raw.githubusercontent.com/rickicode/noobzvpns-docker/main/noobz/cert.pem
wget -q -O /etc/noobzvpns/key.pem https://0ms.dev/mirrors/raw.githubusercontent.com/rickicode/noobzvpns-docker/main/noobz/key.pem
wget -q -O /etc/noobzvpns/config.json https://raw.githubusercontent.com/rickicode/noobzvpns-docker/main/noobz/config.json

# Cek dan update PORT_TLS jika variabel lingkungan tersedia
if [ -n "$PORT_TLS" ] && [[ "$PORT_TLS" =~ ^[0-9]+$ ]]; then
    echo "Mengubah PORT_TLS di config.json menjadi $PORT_TLS"
    # Ubah PORT_TLS di config.json
    sed -i "s/4433/$PORT_TLS/g" /etc/noobzvpns/config.json
fi

if [ -n "$PORT_NTLS" ] && [[ "$PORT_NTLS" =~ ^[0-9]+$ ]]; then
    echo "Mengubah PORT_TLS di config.json menjadi $PORT_NTLS"
    # Ubah PORT_NTLS di config.json
    sed -i "s/8800/$PORT_NTLS/g" /etc/noobzvpns/config.json
fi

if [ ! -f "/usr/bin/noobz" ]; then
    wget -O /usr/bin/noobz https://mirror.ghproxy.com/https://github.com/noobz-id/noobzvpns/raw/master/noobzvpns.x86_64
    chmod +x /usr/bin/noobz
fi

# Tambah user admin ke noobz
/usr/bin/noobz --add-user admin hijinetwork

# Jalankan noobz dengan argumen yang diberikan
exec /usr/bin/noobz --start-service --debug
