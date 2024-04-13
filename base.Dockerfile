FROM ubuntu:22.04 as builder

COPY build-in-docker.sh .

RUN apt-get update \
  && apt-get install -y wget gcc make autoconf \
  && rm -rf /var/lib/apt/lists/*

RUN /bin/bash build-in-docker.sh

FROM scratch

COPY --from=builder /usr/local/openssh/sbin /sbin
COPY --from=builder /usr/local/openssh/bin /bin
