FROM selenium/standalone-chrome

MAINTAINER Vohtr (https://vohtr.com)

USER root

# Install build tools
RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && apt-get -y autoclean \
  && rm -rf /var/lib/apt/lists/*

# Install NVM && NodeJS
# https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a

# NVM environment variables
ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION 0.33.11
ENV NODE_VERSION 8.11.1

# Install NVM
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash

# install NodeJS and NPM
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Confirm Node & NPM installation
RUN which node \
  && node -v \
  && which npm \
  && npm -v

# Install WebdriverIO & Chimp
RUN npm install -g webdriverio chimp

# Install Meteor
ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor
RUN curl https://install.meteor.com/ | sh
