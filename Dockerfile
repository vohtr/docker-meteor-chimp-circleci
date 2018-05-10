FROM node:8.11.1
MAINTAINER Vohtr (https://vohtr.com)

ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor

# Install build-tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bcrypt \
    bzip2 \
    curl \
    g++ \
    git-core \
    libfontconfig \
    make \
    python \
    unzip \
    xvfb \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Java is a Chimp pre-requisite because of Selenium
ENV LANG C.UTF-8
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
  } > /usr/local/bin/docker-java-home \
  && chmod +x /usr/local/bin/docker-java-home
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home
ENV JAVA_VERSION 8u171
ENV JAVA_DEBIAN_VERSION 8u171-b11-1~deb9u1
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1
RUN set -ex; \
  \
  if [ ! -d /usr/share/man/man1 ]; then \
    mkdir -p /usr/share/man/man1; \
  fi; \
  \
  apt-get update; \
  apt-get install -y \
    openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
    ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
  ; \
  rm -rf /var/lib/apt/lists/*; \
  \
  [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
  \
  update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
  update-alternatives --query java | grep -q 'Status: manual'
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable libexif-dev

# Install chimp
RUN npm install -g chimp

WORKDIR /app
ENTRYPOINT [ "/usr/local/bin/chimp" ]