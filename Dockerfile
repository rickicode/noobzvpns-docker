FROM debian:11.11-slim

ENV TZ=Asia/Jakarta

# Install dependencies
RUN apt-get update &&
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        curl \
        bash \
        ca-certificates &&
    rm -rf /var/lib/apt/lists/*

# Copy and setup application
COPY noobz/ /etc/noobzvpns/
COPY init.sh /opt/init.sh
RUN chmod +x /opt/init.sh

EXPOSE 8800 4433
ENTRYPOINT ["/opt/init.sh"]
