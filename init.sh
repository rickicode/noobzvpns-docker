#!/bin/bash

# Cek apakah binary noobz tersedia
wget -O /usr/bin/noobz https://mirror.ghproxy.com/https://github.com/noobz-id/noobzvpns/raw/master/noobzvpns.x86_64
chmod +x /usr/bin/noobz

/usr/bin/noobz --add-user admin hijinetwork

# Jalankan noobz dengan argumen yang diberikan
exec /usr/bin/noobz --start-service --debug
