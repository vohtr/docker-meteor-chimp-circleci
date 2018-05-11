FROM selenium/standalone-chrome

MAINTAINER Vohtr (https://vohtr.com)

USER root

# Install build tools
RUN apt-get update -yq && \
  apt-get install -yq \
    apt-utils \
    build-essential \
    curl \
    git \
    python \
    python-software-properties \
    software-properties

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -yq \
  nodejs \
  npm
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Confirm Node & NPM installation
RUN which node; node -v; which npm; npm -v; \
  npm ls -g --depth=0

# Update NPM
RUN npm install -g npm

# Install WebdriverIO & Chimp
RUN npm install -g webdriverio chimp

# Install Meteor
ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor
RUN curl https://install.meteor.com/ | sh
