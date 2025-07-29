FROM codercom/code-server:latest

USER root

WORKDIR /app

RUN apt-get update && \
    apt-get install -y cmake git g++ protobuf-compiler libprotobuf-dev libgrpc++-dev protobuf-compiler-grpc libabsl-dev

# protos klasörünü oluştur ve izin ver
RUN mkdir -p ./protos && chmod 777 ./protos

# Proto dosyasını kopyala
COPY ./protos/helloworld.proto ./protos/

# protos içeriğine izin ver (gerekirse)
RUN chmod -R 777 ./protos

# Client kaynaklarını kopyala
COPY ./client/ .

# Proto dosyalarını derle
RUN protoc -I ./protos \
    --cpp_out=./protos \
    --grpc_out=./protos \
    --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin \
    ./protos/helloworld.proto

# Client uygulamasını derle
RUN g++ -I ./protos client.cpp protos/helloworld.pb.cc protos/helloworld.grpc.pb.cc -o client \
    -lgrpc++ -lgrpc -lgpr -lprotobuf \
    -labsl_synchronization -labsl_strings -labsl_base -labsl_str_format_internal \
    -pthread

# code-server'ı /app klasöründe, şifresiz ve 0.0.0.0:8080'de başlat
CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "/app"]
