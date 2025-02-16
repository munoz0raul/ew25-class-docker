# Hello World C / No Display

https://github.com/foundriesio/lab/tree/master/lab4/hello-c[a]

## When working with Docker, you first build a Docker Image
A Docker image is all the files necessary to run an application. For training and testing, people usually base images around Ubuntu or Debian Linux. These distributions come with the apt package management tool that handles installation, dependencies, and removal.

Since this is an embedded training, we will demonstrate the classic 'Hello World' project. However, there is a challenge: an embedded Linux distribution is optimized for embedded systems. It is lightweight and does not come with a compiler, such as GCC.

On the other hand, if this distribution supports Docker Containers, you can use Docker to build it.

## Note: Run the following commands on the device

### Create and enter a directory called hello-c:
```sh
device:~$ mkdir hello-c
device:~$ cd hello-c
```

### Warning: Spaces are essential on some files. When copying and pasting the file content, use the GitHub page or download the reference example:

### To build a Hello World, you need a hellowold.c file:

#### Note: If you are not familiar with vim, it is a free text editor.
The way it works is: press (esc) as many times as you want, which brings you to the command prompt (bottom screen). If you press (i or a) it allows you to insert/append. When you finish, you can press (esc) again and type (:wq) to write and quit.

```sh
vim helloworld.c  (i) to insert
```
[Source Code](https://github.com/munoz0raul/ew25-class-docker/blob/main/hello-c/helloworld.c)

```c
#include <stdio.h>
int main()
{
  printf("hello, world!\n");
}
/* helloworld.c */
```
(esc) (:wq)

## The Dockerfile
The Dockerfile is where you specify all the commands to be executed before the final application is built. Here is where you specify packages to install, and the files you want to COPY from your host machine to the Docker Image.

### A quick explanation of this Dockerfile:

- **FROM:** It is starting from a Debian stable-slim distro. Everything included in this distribution version will be available.
- **RUN apt-get update and install:** Install build-essential package.
- **COPY:** helloworld.c and start.sh from the host to the Docker Image.
- **WORKDIR:** move to the specified directory.
- **RUN:** runs the gcc to build the helloworld.c file creating the helloworld executable.
- **ENTRYPOINT:** The command docker will run when starting the Docker Image.

```sh
vim Dockerfile
```
[Dockerfile Source](https://github.com/munoz0raul/ew25-class-docker/blob/main/hello-c/Dockerfile)

```dockerfile
FROM debian:stable-slim

# Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY helloworld.c /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh
WORKDIR /app/
RUN gcc helloworld.c -o helloworld

ENTRYPOINT ["/app/start.sh"]
```

## Building and Running the Container
```sh
device:~$ docker build --tag hello-c:latest .
device:~$ docker image ls
device:~$ docker run -it --rm hello-c:latest
hello, world!
```

## What is Docker Compose?
Docker Compose is a tool used to define and run multi-container Docker applications. It uses a YAML file (docker-compose.yml) to configure the application's services, networks, and volumes.

```sh
vim docker-compose.yml
```
[Docker Compose YML](https://github.com/munoz0raul/ew25-class-docker/blob/main/hello-c/docker-compose.yml)

```yaml
version: '3.6'

services:
  hello-c:
    image: hello-c:latest
```

## Running Docker Compose App
```sh
device:~$ docker compose up -d
device:~$ docker ps
device:~$ docker logs <CONTAINER_ID>
```

## Accessing a Running Container's Terminal
```sh
device:~$ docker exec -it hello-c-hello-c-1 /bin/bash
```
Inside the container:
```sh
docker:~$ ls -l
docker:~$ type gcc
device:~$ cd ..
