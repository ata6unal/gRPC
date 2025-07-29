cmake_minimum_required(VERSION 3.10)
project(grpc_client)

set(CMAKE_CXX_STANDARD 17)

find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)

set(PROTO_FILE ../protos/helloworld.proto)

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILE})
grpc_generate_cpp(GRPC_SRCS GRPC_HDRS ${PROTO_FILE})

include_directories(
  ${Protobuf_INCLUDE_DIRS}
  ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(client
  ../client.cpp
  ${PROTO_SRCS}
  ${PROTO_HDRS}
  ${GRPC_SRCS}
  ${GRPC_HDRS}
)

target_link_libraries(client
  grpc++
  protobuf::libprotobuf
)
