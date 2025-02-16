# BlinkLED + WebApp (Shared volumes)

In this example, the webapp container will write a file containing a variable (e.g., 1 or 0). The blinkled container, running a shell script, will continuously read this file and update the LED status based on the variable's value. By using a shared volume, both containers can access the same file, enabling real-time communication and synchronization between the web application and the LED control logic.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir webapp-led
device:~$ cd webapp-led
```

### Build the Flask App

Start with the `webapp-led.py` file:

```sh
vim webapp-led.py
```

Script:

```python
from flask import Flask, render_template, request

app = Flask(__name__)

# File paths for LED states
LED_GREEN_FILE = "/home/ledG"
LED_BLUE_FILE = "/home/ledB"

def read_file(file_path):
    """Read the current value from a file."""
    try:
        with open(file_path, "r") as file:
            return file.read().strip()
    except FileNotFoundError:
        return "0"  # Default value if the file doesn't exist

def write_file(file_path, value):
    """Write a value to a file."""
    with open(file_path, "w") as file:
        file.write(value)

@app.route('/', methods=['GET', 'POST'])
def index():
    message = ""
    if request.method == 'POST':
        if 'led_green' in request.form:
            current_value = read_file(LED_GREEN_FILE)
            new_value = "1" if current_value == "0" else "0"
            write_file(LED_GREEN_FILE, new_value)
            message = f"LED Green updated to {new_value}"
        elif 'led_blue' in request.form:
            current_value = read_file(LED_BLUE_FILE)
            new_value = "1" if current_value == "0" else "0"
            write_file(LED_BLUE_FILE, new_value)
            message = f"LED Blue updated to {new_value}"
    return render_template('index.html', message=message)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9900)
```

### Create the HTML File

```sh
vim index.html
```

### Create the Dockerfile

```sh
vim Dockerfile
```

Dockerfile content:

```Dockerfile
FROM debian:stable-slim AS builder

# Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages flask flask_restful
RUN mkdir -p /app/
RUN mkdir -p /app/templates/
COPY webapp-led.py /app/
COPY index.html /app/templates/

WORKDIR /app/
CMD ["python3", "webapp-led.py"]
```

## Build and Run the Container

With all the files in the same folder, build the container and add the tag `webapp-led:latest` to it.

```sh
device:~$ docker build --tag webapp-led:latest .
```

### Launch the Container with Shared Volume

```sh
device:~$ docker run -it -p 9900:9900 -v /var/rootdirs/home/fio/home/:/home/:rw -d --rm --name webapp-led webapp-led
```

## Debugging

### Check the Running Images

```sh
device:~$ docker ps
```

### Check the Logs of the Running Image

```sh
device:~$ docker logs webapp-led
```

### Monitor the LED State Files

```sh
device:~$ watch -n 1 cat /var/rootdirs/home/fio/home/ledB
device:~$ watch -n 1 cat /var/rootdirs/home/fio/home/ledG
```

## Docker Compose

To simplify container management, let’s create the `docker-compose.yml` file:

```sh
vim docker-compose.yml
```

Docker Compose file content:

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
```

### Stop the Running Container

```sh
device:~$ docker stop webapp-led
```

### Run the Application with Docker Compose

```sh
device:~$ docker compose up -d
```

### Monitor the LED State Files Again

```sh
device:~$ watch -n 1 cat /var/rootdirs/home/fio/home/ledB
device:~$ watch -n 1 cat /var/rootdirs/home/fio/home/ledG
```

Keep this container running while creating the next container.

### Return One Folder Up

```sh
device:~$ cd ..
