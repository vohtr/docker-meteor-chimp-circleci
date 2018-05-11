FROM selenium/node-chrome

MAINTAINER Vohtr (https://vohtr.com)

# Confirm Node & NPM installation
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN which node
RUN which npm
RUN node -v
RUN npm -v

# Install WebdriverIO & Chimp
RUN npm install -g webdriverio chimp

# Install Meteor
ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor
RUN curl https://install.meteor.com/ | sh
