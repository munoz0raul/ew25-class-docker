FROM debian:stable-slim AS builder

#Install packages
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY blinkled-web.sh /app/
RUN chmod +x /app/blinkled-web.sh
WORKDIR /app/

ENTRYPOINT ["/app/blinkled-web.sh"]

