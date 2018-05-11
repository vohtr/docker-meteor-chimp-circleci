FROM selenium/node-chrome

MAINTAINER Vohtr (https://vohtr.com)

USER root

ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor

# Install Chimp
RUN npm install -g chimp

# Install Meteor
RUN curl https://install.meteor.com/ | sh

WORKDIR /app
ENTRYPOINT [ '/usr/local/bin/chimp' ]