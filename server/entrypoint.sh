#!/bin/bash
# gRPC server'ı arka planda başlat
/app/build/server &

# code-server'ı başlat
dumb-init code-server --auth none --bind-addr 0.0.0.0:8081 /app
