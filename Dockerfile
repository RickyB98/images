# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java (glibc support)
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        openjdk:16-slim

LABEL       author="Riccardo Bello" maintainer="mail@rickyb98.me"

RUN apt-get update -y \
 && apt-get install -y curl ca-certificates openssl git tar sqlite fontconfig tzdata iproute2 unzip \
 && useradd -d /home/container -m container \
 && curl -fsSL https://deb.nodesource.com/setup_15.x | bash - \
 && apt-get update -y \
 && apt-get install -y gcc g++ make \
 && apt-get install -y nodejs \
 && npm install npm@7.10.0 -g
 
USER container
ENV  USER=container HOME=/home/container

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
