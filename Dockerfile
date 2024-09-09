FROM debian:11.11-slim
LABEL maintainer="rickicode <rickicode@hijitoko.com>"
LABEL description="NoobzVPNS Docker Image"

# ENV NAME=HIJINETWORK
ENV TZ=Asia/Jakarta

COPY noobz /etc/noobzvpns

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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



RUN mv /etc/noobzvpns/noobz /usr/bin/noobz \
    && /usr/bin/noobz --add-user admin hijinetwork


EXPOSE 8880 4433
ENTRYPOINT ["/usr/bin/noobz", "--start-service", "--debug"]
