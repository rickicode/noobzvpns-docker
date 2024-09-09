FROM debian:11.9-slim as noobzvpns
LABEL maintainer="rickicode <rickicode@hijitoko.com>"
LABEL description="NoobzVPNS Docker Image"

# ENV NAME=HIJINETWORK
ENV TZ=Asia/Jakarta

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
    && mkdir -p /etc/noobzvpns /var/log/noobzvpns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY noobz /etc/noobzvpns

RUN /usr/bin/noobz --add-user admin hijinetwork


EXPOSE 8880 4433
ENTRYPOINT ["/usr/bin/noobz", "--start-service" "--debug"]
