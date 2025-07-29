cmake_minimum_required(VERSION 3.14)
project(grpc_server)

find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)

add_executable(server
    server.cpp
    protos/helloworld.pb.cc
    protos/helloworld.grpc.pb.cc
)

# Protobuf include path explicitly

target_include_directories(server PRIVATE /usr/local/include ${CMAKE_CURRENT_SOURCE_DIR}/protos)


target_link_libraries(server
    gRPC::grpc++
    ${Protobuf_LIBRARIES}
)
