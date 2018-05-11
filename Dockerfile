FROM openjdk:8-jdk

MAINTAINER Vohtr (https://vohtr.com)

USER root

ARG METEOR_USER=meteor
ARG METEOR_USER_DIR=/home/meteor

# Install Node
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh
RUN npm install -g grunt grunt-cli

# Install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libfontconfig \
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

# Install Chrome
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

USER seluser

# Install Chromedriver
ARG CHROME_DRIVER_VERSION="latest"
RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

# Configure Chrome launcher
COPY generate_config /opt/bin/generate_config
COPY chrome_launcher.sh /opt/google/chrome/google-chrome
RUN /opt/bin/generate_config > /opt/selenium/config.json

# Install Chimp
RUN npm install -g chimp

# Install Meteor
RUN curl https://install.meteor.com/ | sh

WORKDIR /app
ENTRYPOINT [ '/usr/local/bin/chimp' ]