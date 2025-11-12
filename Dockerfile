FROM ubuntu:22.04
LABEL maintainer="webworker01"

# Установка переменной окружения для избежания интерактивных запросов
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y gcc g++ make libboost-dev libboost-system-dev libsodium-dev sudo curl git iputils-ping

# Установка современной версии Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs

RUN useradd knomp
COPY . /home/knomp/knomp

RUN echo "knomp ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    chown -R knomp:knomp /home/knomp

USER knomp

RUN cd /home/knomp/knomp && npm install

WORKDIR /home/knomp/knomp

EXPOSE 8080

CMD npm start
