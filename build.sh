#!/usr/bin/env bash
set -e

docker buildx build --platform linux/arm64,linux/amd64 -o "type=local,dest=dist" -t openssh-build -f base.Dockerfile .

cd dist
for arch in arm64 amd64; do
  tar -czf "openssh-9.6p1-openssl_1.1.1w-zlib_1.3-${arch}.tar.gz" -C ./linux_${arch} .
done
