# Web Application (port)

Flask is a lightweight and flexible micro web framework for Python, designed to make it easy to build web applications quickly.
A "Hello World" example in Flask is the simplest way to demonstrate how Flask works. It involves creating a basic web application that displays the text "Hello, World!" when accessed in a web browser.
When running a Flask application inside a Docker container, we need to map the container's port to the host machine's port so that the application can be accessed from outside the container. This is done using the `-p` flag in the `docker run` command.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir webapp
device:~$ cd webapp
```

### Build the Flask App

Start with the `webapp.py` file:

```sh
vim webapp.py
```

Script:

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9900)
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
        apt-get install -y --no-install-recommends python3-pip && \
        rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages flask flask_restful
RUN mkdir -p /app/
COPY webapp.py /app/
WORKDIR /app/

CMD ["python3", "webapp.py"]
```

## Build and Run the Container

With all the files in the same folder, build the container and add the tag `webapp:latest` to it.

```sh
device:~$ docker build --tag webapp:latest .
```

### Listing all Docker Images

```sh
device:~$ docker image ls
```

### Launch the Container

Launch the container with `-d` to detach it and `--name` to specify a name.
Note that we are using `-p` to share the port 9900 from the Docker container with the host.

```sh
device:~$ docker run -it -p 9900:9900 -d --rm --name webapp webapp
```

Example output:

```
d948ce65d5d7ffe6a214211e946ba939db7f05994191763bde82e4f5e0ad4a8a
```

## Debugging

### Check the Running Images

```sh
device:~$ docker ps
```

### Check the Logs of the Running Image

```sh
device:~$ docker logs webapp
```

Example output:

```
 * Serving Flask app 'webapp'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:9900
 * Running on http://172.17.0.3:9900
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 557-327-635
```

### Test the Application

Use your browser with the board IP to check the page result:

```sh
host:~$ curl http://192.168.15.97:9900
```

Expected output:

```
Hello, World!
```

## Docker Compose

To simplify container management, let’s create the `docker-compose.yml` file for this app:

```sh
vim docker-compose.yml
```

Docker Compose file content:

```yaml
version: '3.8'

services:
  webapp:
    image: webapp:latest
    ports:
      - "9900:9900"
    restart: unless-stopped
```

### Stop the Running Container

```sh
device:~$ docker stop webapp
```

### Run the Application with Docker Compose

```sh
device:~$ docker compose up
```

Example output:

```
[+] Building 0.0s (0/0)                                                                        
[+] Running 2/2
 ✔ Network flask_default     Created                                                      0.2s 
 ✔ Container flask-webapp-1  Created                                                      0.1s 
Attaching to flask-webapp-1
flask-webapp-1  |  * Serving Flask app 'webapp'
flask-webapp-1  |  * Debug mode: on
flask-webapp-1  | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
flask-webapp-1  |  * Running on all addresses (0.0.0.0)
flask-webapp-1  |  * Running on http://127.0.0.1:9900
flask-webapp-1  |  * Running on http://172.19.0.2:9900
flask-webapp-1  | Press CTRL+C to quit
flask-webapp-1  |  * Restarting with stat
flask-webapp-1  |  * Debugger is active!
flask-webapp-1  |  * Debugger PIN: 125-324-034
flask-webapp-1  | 192.168.15.14 - - [16/Feb/2025 00:21:38] "GET / HTTP/1.1" 200 -
```

### Test Again Using Curl or Browser

Return one folder up:

```sh
device:~$ cd ..
