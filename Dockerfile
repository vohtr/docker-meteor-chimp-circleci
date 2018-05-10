FROM node:8.11.1
MAINTAINER Vohtr (https://vohtr.com)

ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor

# Install apt utils
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# Install build tools
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    bcrypt \
    bzip2 \
    curl \
    g++ \
    git-core \
    libgconf-2-4 \
    libxi6 \
    make \
    python \
    python-software-properties \
    unzip \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libfontconfig \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    xvfb \
    xz-utils \
    chromium-chromedriver \
  && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LC_NUMERIC=en_US.UTF-8
ENV SELENIUM_STANDALONE_VERSION=3.5.0
RUN SELENIUM_SUBDIR=$(echo '$SELENIUM_STANDALONE_VERSION' | cut -d'.' -f-2)

# Install Chrome.
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -y update
RUN apt-get -y install google-chrome-stable

# Install Selenium.
RUN wget -N http://selenium-release.storage.googleapis.com/$SELENIUM_SUBDIR/selenium-server-standalone-$SELENIUM_STANDALONE_VERSION.jar -P ~/
RUN sudo mv -f ~/selenium-server-standalone-$SELENIUM_STANDALONE_VERSION.jar /usr/local/bin/selenium-server-standalone.jar
RUN sudo chown root:root /usr/local/bin/selenium-server-standalone.jar
RUN sudo chmod 0755 /usr/local/bin/selenium-server-standalone.jar

# Install Chimp
RUN npm install -g chimp

# Install Meteor
RUN curl https://install.meteor.com/ | sh

WORKDIR /app
ENTRYPOINT [ '/usr/local/bin/chimp' ]