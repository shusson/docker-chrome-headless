FROM openjdk:8-jre

MAINTAINER shane.a.husson@gmail.com

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get update && \
    apt-get install -y xvfb wget nodejs && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb

RUN npm install -g protractor mocha jasmine karma-cli && \
    webdriver-manager update && \
    mkdir /tests

COPY command.sh /command.sh

# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /tests
ENTRYPOINT ["/command.sh"]
