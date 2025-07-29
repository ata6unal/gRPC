FROM codercom/code-server:latest

USER root

# Gerekli bağımlılıkları kur
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    git \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    curl \
    unzip \
    wget \
    ca-certificates \
    ninja-build \
    python3 \
    python3-pip \
    protobuf-compiler \
    libprotobuf-dev \
    libprotoc-dev \
    zlib1g-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# gRPC ve protobuf derleme
WORKDIR /deps
RUN git clone --branch v21.12 https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && git submodule update --init --recursive && \
    ./autogen.sh && ./configure && make -j4 && make install && ldconfig

RUN git clone --recurse-submodules -b v1.51.1 https://github.com/grpc/grpc.git && \
    mkdir -p grpc/cmake/build && cd grpc/cmake/build && \
    cmake ../.. && make -j4 && make install && ldconfig

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV CMAKE_PREFIX_PATH=/usr/local

# Uygulama dosyalarını kopyala
WORKDIR /app
COPY protos/*.proto ./protos/
COPY server/server.cpp .
COPY server/CMakeLists.txt .

# Protobuf derleme
RUN protoc -I=protos --cpp_out=protos --grpc_out=protos --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin protos/helloworld.proto

# CMake build
RUN mkdir build && cd build && \
    cmake -DCMAKE_PREFIX_PATH=/usr/local -DProtobuf_INCLUDE_DIR=/usr/local/include .. && \
    make

# Entrypoint scriptini kopyala ve çalıştırılabilir yap
COPY server/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
