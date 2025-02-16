# Running Multiple Containers with Docker Compose

[GitHub Reference](https://github.com/foundriesio/lab/tree/master/lab4/hello-c)

In this chapter, we explore how to define and manage multiple containers within a single `docker-compose.yml` file. Docker Compose simplifies the orchestration of interconnected services by allowing you to specify each container as a service in a declarative YAML configuration.

This example combines the `webapp-led` with a separate container to blink the LEDs.

## Start by creating a new directory:

**Note:** Run the following commands on the device

```sh
device:~$ mkdir blinkled-web
device:~$ cd blinkled-web
```

**Warning:** Spaces are essential on some files. When copying and pasting the file content, use the GitHub page or download the reference example.

## To build the blinkled-web app, start with the `blinkled-web.sh` file:

```sh
vim blinkled-web.sh
```
[blinkled-web.sh](https://github.com/munoz0raul/ew25-class-docker/blob/main/blinkled-web/blinkled-web.sh)

```bash
#!/bin/bash

# File paths for LED states
LED_GREEN_FILE="/home/ledG"
LED_BLUE_FILE="/home/ledB"

# LED control paths
LED_GREEN_TRIGGER="/sys/class/leds/ledG/trigger"
LED_BLUE_TRIGGER="/sys/class/leds/ledB/trigger"

# Infinite loop with 1-second delay
while true; do
    # Read the value for LED Green
    LED_GREEN=$(cat "$LED_GREEN_FILE" 2>/dev/null)
    if [[ "$LED_GREEN" == "1" ]]; then
        echo "Turning on LED Green"
        echo "default-on" > "$LED_GREEN_TRIGGER"
    elif [[ "$LED_GREEN" == "0" ]]; then
        echo "Turning off LED Green"
        echo "none" > "$LED_GREEN_TRIGGER"
    else
        echo "LED Green file contains an invalid value"
    fi

    # Read the value for LED Blue
    LED_BLUE=$(cat "$LED_BLUE_FILE" 2>/dev/null)
    if [[ "$LED_BLUE" == "1" ]]; then
        echo "Turning on LED Blue"
        echo "default-on" > "$LED_BLUE_TRIGGER"
    elif [[ "$LED_BLUE" == "0" ]]; then
        echo "Turning off LED Blue"
        echo "none" > "$LED_BLUE_TRIGGER"
    else
        echo "LED Blue file contains an invalid value"
    fi

    # Wait for 1 second before the next iteration
    sleep 1
done
```

## Create the Dockerfile:

```sh
vim Dockerfile
```

[Dockerfile](https://github.com/munoz0raul/ew25-class-docker/blob/main/blinkled-web/blinkled-web.sh)

```dockerfile
FROM debian:stable-slim AS builder

# Install packages
RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/
COPY blinkled-web.sh /app/
RUN chmod +x /app/blinkled-web.sh
WORKDIR /app/

ENTRYPOINT ["/app/blinkled-web.sh"]
```

With all the files in the same folder, build the container and add the tag `blinkled:latest` to it. Make sure to copy the dot after the latest.

You can also find the commands in the `README.md` file:
[GitHub Reference](https://github.com/foundriesio/lab/blob/master/lab4/hello-c/README.md)

**Note:** The Docker commands must be done in your `blinkled` folder. In my case, `~/blinkled`

```sh
device:~$ docker build --tag blinkled-web:latest .
```

### Listing all Docker Images installed on your machine:
```sh
device:~$ docker image ls
```

### Launch the container with `-v` but now with read-only.
```sh
device:~$ docker run -it --rm -v /var/rootdirs/home/fio/home/:/home/:rw --privileged --name blinkled-web -d blinkled-web:latest
d948ce65d5d7ffe6a214211e946ba939db7f05994191763bde82e4f5e0ad4a8a
```

At this point, you probably are thinking why the LEDs are not blinking, let’s debug:

### Check the running images:
```sh
device:~$ docker ps
```

### Check the logs of the running image:
```sh
device:~$ docker logs blinkled-web
Turning off LED Green
Turning off LED Blue
Turning off LED Green
Turning off LED Blue
Turning off LED Green
Turning off LED Blue
```

As you can see, clicking the buttons on the web page updates the files, and the `blinkled-web` app adjusts the LED states based on the values in these files.

## When you have multiple containers running on the same device, it is common to combine them both in the same `docker-compose.yml`.

```sh
vim docker-compose.yml
```

[docker-compose.yml](https://github.com/munoz0raul/ew25-class-docker/blob/main/blinkled-web/docker-compose.yml)

```yaml
version: '3.8'

services:
  webapp-led:
    image: webapp-led:latest
    ports:
      - "9900:9900"
    volumes:
      - /var/rootdirs/home/fio/home/:/home/:rw
    restart: unless-stopped
  blinkled-web:
    image: blinkled-web:latest
    privileged: true
    restart: unless-stopped
    volumes:
      - /var/rootdirs/home/fio/home/:/home/:ro
    depends_on:
      - webapp-led
```

### Check for running containers:
```sh
device:~$ docker ps
```

### Stop the running container:
```sh
device:~$ docker stop webapp-led-webapp-1 blinkled-web
```

### Running Docker Compose App:
```sh
device:~$ docker compose up
```

```sh
[+] Building 0.0s (0/0)                                                                 
[+] Running 2/0
 ✔ Container blinkled-web-webapp-led-1    Create...                                       0.0s 
 ✔ Container blinkled-web-blinkled-web-1  Crea...                                         0.0s 
Attaching to blinkled-web-blinkled-web-1, blinkled-web-webapp-led-1
blinkled-web-blinkled-web-1  | Turning on LED Green
blinkled-web-blinkled-web-1  | Turning off LED Blue
blinkled-web-webapp-led-1    |  * Serving Flask app 'webapp-led'
blinkled-web-webapp-led-1    |  * Debug mode: on
blinkled-web-webapp-led-1    | WARNING: This is a development server. Do not use it in a production deployment.
```

Now you have successfully set up multiple containers using Docker Compose!
