FROM debian:stable-slim AS builder
RUN  echo "-------multi-stage--------------"

#Install packages for the builder stage
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY helloworld.c /app/
WORKDIR /app/
RUN gcc helloworld.c -o helloworld
RUN  echo "-------Final Stage--------------"

FROM debian:stable-slim AS final-stage

#Install packages for the final stage
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY --from=builder /app/helloworld /app/
WORKDIR /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]
