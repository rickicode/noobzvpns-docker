FROM debian:11.9-slim as noobzvpns
LABEL maintainer="rickicode <rickicode@hijitoko.com>"
LABEL description="NoobzVPNS Docker Image"

# ENV NAME=HIJINETWORK
ENV TZ=Asia/Jakarta

# RUN sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/id.archive.ubuntu.com/g' /etc/apt/sources.list \
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=$TZ apt-get install -y --no-install-recommends \
    libffi-dev \
    openssl \
    libssl-dev \
    bzip2 \
    python2 \
    zlib1g-dev \
    libncurses5-dev \
    tk-dev \
    libc6-dev \
    htop \
    socat \
    cron \
    tzdata \
    bzip2 \
    zlib1g \
    readline-common \
    libncursesw5 \
    tk \
    libc-bin \
    musl-dev \
    gcc \
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
