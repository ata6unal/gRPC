cmake_minimum_required(VERSION 3.10)
project(GrpcExample)

set(CMAKE_CXX_STANDARD 17)

find_package(Protobuf REQUIRED)



include_directories(${Protobuf_INCLUDE_DIRS})

add_executable(server server.cpp)

target_link_libraries(server
    protobuf::libprotobuf
    grpc++
    grpc
    pthread
)
