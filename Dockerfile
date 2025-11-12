FROM ubuntu:20.04
LABEL maintainer="webworker01"

ENV DEBIAN_FONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y gcc g++ make libboost-dev libboost-system-dev libsodium-dev sudo curl git iputils-ping \
    cmake pkg-config

# Установка Node.js 14 (более совместим со старыми пакетами)
RUN curl -fsSL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
    apt-get install -y nodejs

RUN useradd knomp
COPY . /home/knomp/knomp

RUN echo "knomp ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    chown -R knomp:knomp /home/knomp

USER knomp

# Попробуйте с флагом --legacy-peer-deps
RUN cd /home/knomp/knomp && npm install --legacy-peer-deps

WORKDIR /home/knomp/knomp

EXPOSE 8080

CMD npm start
