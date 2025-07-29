# 📦 C++ Development Environment with Docker & Docker Compose Guide 📦


#🧩 Project Purpose
This guide explains how to set up a portable C++ development environment using Docker, Dockerfile, and
Docker Compose. Ideal for projects using gRPC, Protobuf etc.

It is designed to be:
- Modular: Independent client/server containers.
- Scalable: Easy to extend with more services.
- Cross-platform: Using Docker to ensure consistency across environments.
- Remote-developable: With optional `code-server` access via browser.

#🛠️ Deployment Overview

The project is deployed using Docker Compose, running multiple services in isolated containers:

- grpc-server: Compiles and runs the C++ gRPC server.
- grpc-client: Compiles and runs the C++ gRPC client.
- (Optional) code-server: Runs VS Code IDE in the browser for remote development.


#📁 Project Structure :

├── CMakeLists.txt
├── build
│   ├── CMakeCache.txt
│   └── CMakeFiles
├── build_log.txt
├── client
│   ├── CMakeLists.txt
│   ├── Dockerfile
│   └── client.cpp
├── cpptools-linux-arm64.vsix
├── docker-compose.yml
├── extensions.txt
├── protos
│   ├── helloworld.grpc.pb.cc
│   ├── helloworld.grpc.pb.h
│   ├── helloworld.pb.cc
│   ├── helloworld.pb.h
│   └── helloworld.proto
├── server
│   ├── CMakeLists.txt
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── server.cpp
└── third_party
    └── grpc

#🐋 Dockerfile :

// Create a "Dockerfile" in the root of your project.
FROM gcc::latest

//Install packages
RUN apt-get update && apt-get install -y \
    build-essential cmake git protobuf-compiler libprotobuf-dev libgrpc++-dev

WORKDIR /app

//Copy your project files

COPY proto ./proto
COPY server/server.cpp ./server.cpp
COPY server/CMakeLists.txt ./CMakeLists.txt

RUN mkdir build && cd build && cmake .. && make

CMD ["./build/server"]

#⚙️ docker-compose.yml:

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


#🚀 Run the Environment :

In your vscode terminal 
1)build and start all services;
docker-compose up --build
2)Access code-server in your browser;
http://localhost:8080
(**I didn't made a password for this project but you can create one if you want**)
3)View client output in logs or terminal


//Build both of your server and client images, compile your .cpp files
 , run your server and client in separate containers.

#📌 Flow of Execution :
[1] docker-compose up --build
    ↓
[2] Protobufs compiled via protoc
    ↓
[3] gRPC Server boots on port [50051]
    ↓
[4] Client.cpp connects to grpc-server:50051
    ↓
[5] Sends **SayHello** request (with name)
    ↓
[6] Server handles request in HelloServiceImpl
    ↓
[7] Returns **Hello, Ata** response
    ↓
[8] Client prints response to terminal

#🎨 Deployment Diagram (PUML) :
//It gives you a simpler visualize for the project with a PUML.

@startuml
actor Developer

node "Docker Host" {
    node "Docker Compose" {
        node "grpc-server container" {
            [gRPC Server\n(server.cpp)] as Server
        }
        node "grpc-client container" {
            [gRPC Client\n(client.cpp)] as Client
        }
        node "code-server container" {
            [Web IDE\n(code-server)] as IDE
        }
    }
}

Developer --> IDE : Access via browser (port 8080)
IDE --> Server : Edits / Debugs source code
Client --> Server : Sends gRPC Request
Server --> Client : Sends gRPC Response
@enduml

#📚 Use This Project As a Template
You can use this project as a reference or base for:

Writing your own gRPC microservices in C++

Testing client-server communication inside Docker

Experimenting with remote code editing using code-server

Learning how to compile Protobuf & gRPC from CMake or shell



#✅Requirements
-Docker
-Docker Compose
-VS Code (for local editing)
-PlantUML (optional for diagram rendering)

📷 Sample Screenshots:
https://snipboard.io/8AZMJ2.jpg
https://snipboard.io/kDUXto.jpg


