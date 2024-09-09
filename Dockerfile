FROM debian:11.11-slim
LABEL maintainer="rickicode <rickicode@hijitoko.com>"
LABEL description="NoobzVPNS Docker Image"

ENV TZ=Asia/Jakarta

# Salin file dan folder
COPY noobz/ /etc/noobzvpns/
COPY init.sh /opt/init.sh

# Instalasi dependensi
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=$TZ apt-get install -y --no-install-recommends \
    htop \
    openssl \
    libssl-dev \
    wget \
    curl \
    bash \
    jq \
    dnsutils \
    nano \
    screen \
    ca-certificates \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Berikan izin eksekusi untuk skrip init.sh
RUN chmod +x /opt/init.sh

# Ekspos port
EXPOSE 8880 4433

# Jalankan skrip init.sh saat container dimulai
ENTRYPOINT ["/opt/init.sh"]
