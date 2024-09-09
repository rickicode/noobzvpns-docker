FROM debian:11.11-slim
LABEL maintainer="rickicode <rickicode@hijitoko.com>"
LABEL description="NoobzVPNS Docker Image"

# ENV NAME=HIJINETWORK
ENV TZ=Asia/Jakarta

COPY noobz/ /etc/noobzvpns/
COPY init.sh /opt/init.sh

# RUN sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/id.archive.ubuntu.com/g' /etc/apt/sources.list \
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
    && chmod +x /opt/init.sh \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 8880 4433
ENTRYPOINT ["/opt/init.sh"]
