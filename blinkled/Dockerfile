FROM debian:stable-slim AS builder

#Install packages
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/

COPY blinkled.sh /app/
RUN chmod +x /app/blinkled.sh

WORKDIR /app/

ENTRYPOINT ["/app/blinkled.sh"]
