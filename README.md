# Mastering Docker for Embedded Linux Development: A Hands-On Introduction

Docker containers have transformed the landscape of embedded Linux® development by offering robust isolation from the base operating system, thereby enhancing security and flexibility. This session is designed to guide embedded developers through the essential steps of leveraging Docker containers for embedded Linux applications. Participants will gain hands-on experience with fundamental Docker commands, creating Dockerfiles, and developing docker-compose applications using an ARM evaluation board. The session will culminate in a practical demonstration, showcasing an example application that highlights common scenarios such as accessing hardware from within a Docker container. By the end of this session, attendees will be equipped with the skills to design multi-stage Docker images, host and deploy these images, and apply best practices for Docker container development in embedded systems.

## Table of Contents

- [Training Motivation](#training-motivation)
- [Suggested Architecture](#suggested-architecture)
- [What is a Container?](#what-is-a-container)
- [What is Docker?](#what-is-docker)
- [What is a Docker Image?](#what-is-a-docker-image)
- [Using the Portenta X8 for Hands-On Docker Development](#using-the-portenta-x8-for-hands-on-docker-development)
  - [Introduction to the Portenta X8](#introduction-to-the-portenta-x8)
  - [Setting Up the Portenta X8 for the Course](#setting-up-the-portenta-x8-for-the-course)

---

## Training Motivation
When I started working at Foundries.io, I believed that a purely Yocto-optimized distribution was the best approach for IoT and edge devices. Foundries.io believes in the combination of an optimized, well-maintained, and secure Linux distribution, combined with Docker container applications.

This combination allows developers to:

- Run a Docker application on different devices: iMX6, iMX8, AM64, Raspberry Pi.
- You can run your application on your host PC and easily move it to the final hardware.
- Make it easy to maintain the base distribution.

## Suggested Architecture

...

## What is a Container?
A container is a lightweight, standalone, and executable package that includes everything needed to run a piece of software, including the code, runtime, system tools, libraries, and settings. Containers are isolated from the host system and other containers, ensuring consistent performance across different environments.

### Key Characteristics:
- **Isolation**: Containers run in isolated user spaces, sharing the host operating system's kernel but not its processes or filesystem.
- **Portability**: Containers can run consistently across different environments (development, testing, production).
- **Efficiency**: Containers are lightweight compared to virtual machines (VMs) because they share the host OS kernel.

## What is Docker?
Docker is an open-source platform that enables developers to automate the deployment, scaling, and management of applications within containers. It provides tools and APIs to build, ship, and run containers efficiently.

### Key Components of Docker:
- **Docker Engine**: The core component responsible for running and managing containers.
  - It includes a server (daemon), a REST API, and a command-line interface (CLI).
- **Docker Images**: Read-only templates used to create containers.
- **Docker Containers**: Runnable instances of Docker images.
- **Docker Registry**: A repository for storing and distributing Docker images (e.g., Docker Hub).

### Potential Variants of Docker:
- **Docker CE (Community Edition)**: Free and open-source version of Docker for developers and small teams.
- **Docker EE (Enterprise Edition)**: A premium version with additional features like advanced security, management, and support.
- **Podman**: A daemonless container engine that is compatible with Docker but does not require a background process.
- **Containerd**: A lightweight container runtime that can be used as an alternative to Docker Engine.
- **Kubernetes**: A container orchestration platform that can work with Docker containers but provides additional features for scaling and managing containerized applications.

## What is a Docker Image?
A Docker image is a read-only template that contains the instructions for creating a Docker container. It includes the application code, libraries, dependencies, and configuration files needed to run the application.

### Key Concepts:
- **Layers**: Docker images are constructed in layers. Each instruction in a Dockerfile generates a new layer. These layers are cached, which speeds up the image-building process significantly.
- **Base Image**: The starting point for a Docker image (e.g., ubuntu, alpine).
- **Dockerfile**: A text file that contains instructions for building a Docker image.
- **Registry**: A storage and distribution system for Docker images (e.g., Docker Hub).

### Dockerfile Example
```dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3
COPY app.py /app/
CMD ["python3", "/app/app.py"]
```
This Dockerfile creates an image based on Ubuntu 20.04, installs Python 3, copies an application file, and sets the default command for running the application.

## Using the Portenta X8 for Hands-On Docker Development

### Introduction to the Portenta X8
The Portenta X8 is a high-performance, industrial-grade development board designed by Arduino. It combines the power of an NXP i.MX 8M Mini ARM Cortex-A53 processor with an STM32H747XI Cortex-M7/M4 microcontroller, making it ideal for embedded Linux development and IoT applications.

#### Key Features of the Portenta X8:
- **Dual-Core Architecture:**
  - ARM Cortex-A53 (Linux-capable) for high-level applications.
  - ARM Cortex-M7/M4 for real-time tasks.
- **Connectivity:**
  - Wi-Fi and Bluetooth for wireless communication.
  - USB-C for power and data transfer.
  - Ethernet support for wired networking.
- **Expandability:**
  - Arduino MKR headers for adding peripherals.
  - Micro HDMI for display output.
- **Industrial-Grade Design:**
  - Rugged and reliable for use in demanding environments.

For more details, refer to the official documentation:
[Portenta X8 Tech Specs](https://docs.arduino.cc/hardware/portenta-x8/#tech-specs)

### Setting Up the Portenta X8 for the Course
During this course, the Portenta X8 will serve as the target device for running Docker containers and embedded Linux applications. Here’s how the setup will work:

- **Connection to the Classroom Network:**
  - The Portenta X8 will be connected to the classroom’s Wi-Fi network automatically.
  - This allows the board to communicate with other devices on the same network.
- **Accessing the Portenta X8:**
  - Students will connect to the Portenta X8 using SSH (Secure Shell) over the network.
  - The board’s IP address will be in the range `192.168.15.XXX`, where `XXX` is a unique identifier for each board.

### SSH Connection Instructions
```sh
ssh fio@192.168.15.XXX
```
Replace `XXX` with the specific IP address assigned to your board.
- The default username is `fio`, and no password is required for this course.

### Verifying the Connection
- Once connected, you will have access to the Portenta X8’s Linux terminal.
- You can now run Docker commands, deploy containers, and interact with the board.

Once connected to the Portenta X8, you will:

- Run Docker containers on the board.
- Deploy embedded Linux applications.
- Access hardware peripherals (e.g., GPIO) from within Docker containers.
