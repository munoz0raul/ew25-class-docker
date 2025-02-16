# BlinkLED

https://github.com/foundriesio/lab/tree/master/lab4/hello-c

Since this training focuses on Docker for embedded systems, we couldn’t miss a blinkLED example. The Portenta X8 has two LEDs already configured in the file system.

**LED Green** - `/sys/class/leds/ledG/`
**LED Blue** - `/sys/class/leds/ledB/`

During this example, we are going to start see the way of debugging problems that could happen when creating your Docker Apps.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir blinkled
device:~$ cd blinkled
```

### Build the blinkLed App

Start with the `blinkled.sh` file:

```sh
vim blinkled.sh
```

Script:

```sh
#!/bin/bash

blink=1

while true; do
  echo "blink = $blink"
  if [ $blink -eq 1 ]; then
    trigger="default-on"
    blink=0
  else
    trigger="none"
    blink=1
  fi
  echo "$trigger" > /sys/class/leds/ledG/trigger
  echo "$trigger" > /sys/class/leds/ledB/trigger
  sleep 1 & wait
done
```

### Create Your Dockerfile

```sh
vim Dockerfile
```

Dockerfile content:

```Dockerfile
FROM debian:stable-slim AS builder

# Install packages
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/

COPY blinkled.sh /app/
RUN chmod +x /app/blinkled.sh

WORKDIR /app/

ENTRYPOINT ["/app/blinkled.sh"]
```

## Build and Run the Container

With all the files in the same folder, build the container and add the tag `blinkled:latest` to it.

```sh
device:~$ docker build --tag blinkled:latest .
```

### Listing all Docker Images

```sh
device:~$ docker image ls
```

### Launch the Container

Launch the container with `-d` to detach it and `--name` to specify a name.

```sh
device:~$ docker run -it --rm --name blinkled -d blinkled:latest
```

Example output:

```
d948ce65d5d7ffe6a214211e946ba939db7f05994191763bde82e4f5e0ad4a8a
```

## Debugging

At this point, you may wonder why the LEDs are not blinking. Let’s debug:

### Check the Running Images

```sh
device:~$ docker ps
```

### Check the Logs of the Running Image

```sh
device:~$ docker logs blinkled
```

Example output:

```
blink = 0
/app/blinkled.sh: line 14: /sys/class/leds/ledG/trigger: Read-only file system
/app/blinkled.sh: line 15: /sys/class/leds/ledB/trigger: Read-only file system
```

As you can see, the container has no access to write in these files.

### Stop the Running Container

```sh
device:~$ docker stop blinkled
```

### Add Privilege to the Container

```sh
device:~$ docker run -it --rm -d --name blinkled --privileged blinkled:latest
```

Example output:

```
c08fe3dd70ab9c41d6f9d3c85bdc106af39c2d05d670088323f186fb485dbdb3
```

### Recheck the Logs

```sh
device:~$ docker logs blinkled
```

Example output:

```
blink = 0
blink = 1
blink = 0
blink = 1
blink = 0
```

### Return One Folder Up

```sh
device:~$ cd ..
```

For further details, you can check the README file [here](https://github.com/foundriesio/lab/blob/master/lab4/hello-c/README.md).
