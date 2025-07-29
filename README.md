# 📦C++ Development Environment with Docker & Docker Compose Guide 📦


## 🧩Project Purpose
This guide explains how to set up a portable C++ development environment using Docker, Dockerfile, and
Docker Compose. Ideal for projects using gRPC, Protobuf etc.

It is designed to be:
- Modular: Independent client/server containers.
- Scalable: Easy to extend with more services.
- Cross-platform: Using Docker to ensure consistency across environments.
- Remote-developable: With optional `code-server` access via browser.

## 🛠️Deployment Overview

The project is deployed using Docker Compose, running multiple services in isolated containers:

- grpc-server: Compiles and runs the C++ gRPC server.
- grpc-client: Compiles and runs the C++ gRPC client.
- (Optional) code-server: Runs VS Code IDE in the browser for remote development.


## 📁Project Structure :

![Uygulama Görseli](https://i.imgur.com/Irwg0Ud.png)




## 🐋Dockerfile :

```dockerfile
# Create a "Dockerfile" in the root of your project.
FROM gcc:latest

# Install packages
RUN apt-get update && apt-get install -y \
    build-essential cmake git protobuf-compiler libprotobuf-dev libgrpc++-dev

WORKDIR /app

# Copy your project files
COPY proto ./proto
COPY server/server.cpp ./server.cpp
COPY server/CMakeLists.txt ./CMakeLists.txt

RUN mkdir build && cd build && cmake .. && make

CMD ["./build/server"]
```
## ⚙️docker-compose.yml :

```docker-compose.yml

version: '3'
services:
  grpc-server:
    build:
      context: .
      dockerfile: server/Dockerfile
    container_name: grpc-server
    ports:
      - "50052:50051"
      - "8081:8081"  # Code Server için

  grpc-client:
    build:
      context: .
      dockerfile: client/Dockerfile
    depends_on:
      - grpc-server
    ports:
      - "8080:8080"  # Code Server için


  grpc-client:
    build:
      context: .
      dockerfile: client/Dockerfile
    depends_on:
      - grpc-server
    ports:
      - "8080:8080"  # Code Server için
```

## 🚀Run the Environment :

In your vscode terminal 

1)build and start all services;
docker-compose up --build

2)Access code-server in your browser;
http://localhost:8080

(**I didn't made a password for this project but you can create one if you want**)

3)View client output in logs or terminal


Build both of your server and client images, compile your .cpp files
 , run your server and client in separate containers.

## 📌Flow of Execution :

[1] docker-compose up --build

[2] Protobufs compiled via protoc
    
[3] gRPC Server boots on port [50051]
    
[4] Client.cpp connects to grpc-server:50051
    
[5] Sends **SayHello** request (with name)
    
[6] Server handles request in HelloServiceImpl
    
[7] Returns **Hello, Ata** response
    
[8] Client prints response to terminal

## 🎨Deployment Diagram (PUML) :
It gives you a simpler visualize for the project with a PUML.

![gRPC Flow](https://uml.planttext.com/plantuml/png/XPAnJiCm48RtUufJftO8TAmOK55IYMwe7HY08N5EKTJKv_gSCA2yEtOS6bg1UeE7-x-xttVsMbnkNNji85UEBMRKKSE6B83cad2MiJgGnMSMDyClG1yNGif7mq8_sgHNrgX4o7OUKgnTNckolx4GRzNk9SNzGBthUSJlb36B3ynb5CuL_LyMggb9kriMwK1vYuXF5b7urqBvy_OKhrJWDjk4zXCV-_lqLVCUUe3pdZ597WE43_Ya58bWL-TOMFxqNN1ks3fSBLVB1GGem74fdj-KjHEyzszMj9MWS6iLORW1nAakyJtfKd3OnevEBOc3KGlOM765YM4j16kV2t_a6m00)



## 📚Use This Project As a Template
You can use this project as a reference or base for:

Writing your own gRPC microservices in C++

Testing client-server communication inside Docker

Experimenting with remote code editing using code-server

Learning how to compile Protobuf & gRPC from CMake or shell

## ✅Requirements

-Docker

-Docker Compose

-VS Code (for local editing)

-PlantUML (optional for diagram rendering)

## 📷Sample Screenshots:

![1](https://snipboard.io/8AZMJ2.jpg)


![2](https://snipboard.io/kDUXto.jpg)


