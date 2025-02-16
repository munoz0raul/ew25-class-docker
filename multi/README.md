# Multi-stage Container

A multi-stage container is a powerful Docker feature that enables you to build smaller, more efficient, and more secure container images. Here's a simple explanation of why multi-stage containers are interesting and why they matter:

A multi-stage container utilizes multiple stages (or steps) in a single Dockerfile to:

1. Build the application (e.g., compile code, install dependencies).
2. Copy only the necessary files (e.g., the compiled binary or runtime files) to the final image.
3. Discard the rest (e.g., build tools, intermediate files).

This results in a smaller and cleaner final image.

## Note: Run the following commands on the device

### Create and enter a directory called `multi`:
```sh
device:~$ mkdir multi
device:~$ cd multi
```

### Creating necessary files

To build a multi-stage container, you need a `helloworld.c` file:
```sh
vim helloworld.c
```
[Source Code](https://github.com/munoz0raul/ew25-class-docker/blob/main/multi/helloworld.c)

```c
#include <stdio.h>
int main()
{
  printf("hello, world!\n");
}
/* helloworld.c */
```

### Creating the `start.sh` script
```sh
vim start.sh
```
[Source Code](https://github.com/munoz0raul/ew25-class-docker/blob/main/multi/start.sh)

```sh
#!/bin/sh
while :
do
  /app/helloworld
  sleep 5
done
```

## Writing the Dockerfile
```sh
vim Dockerfile
```
[Dockerfile Source](https://github.com/munoz0raul/ew25-class-docker/blob/main/multi/Dockerfile)

```dockerfile
FROM debian:stable-slim AS builder
RUN  echo "-------multi-stage--------------"

# Install packages for the builder stage
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY helloworld.c /app/
WORKDIR /app/
RUN gcc helloworld.c -o helloworld
RUN  echo "-------Final Stage--------------"

FROM debian:stable-slim AS final-stage

# Install packages for the final stage
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY --from=builder /app/helloworld /app/
WORKDIR /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]
```

## Building and Running the Container
```sh
device:~$ docker build --tag multi-stage:latest .
device:~$ docker image ls
```

### Launch the container with `-d` to detach it and `--name` to specify a name
```sh
device:~$ docker run -it --rm --name multi-stage -d multi-stage
```

### Check for the running container
```sh
device:~$ docker ps
```

### Accessing the running container
```sh
device:~$ docker exec -it multi-stage /bin/bash
```

### Inside the container, check the installed files
```sh
docker:~$ ls -l
```

### Verify if `gcc` is installed
```sh
docker:~$ type gcc
bash: type: gcc: not found
```

### Exit the container
```sh
docker:~$ exit
```

### Return one folder
```sh
device:~$ cd ..
