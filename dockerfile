FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y git curl software-properties-common unzip wget
RUN apt-get update && apt-get install -y python3-pip python3-dev
RUN apt-get update && apt-get install -y libgtk-3-dev libboost-all-dev build-essential cmake libffi-dev
RUN apt-get update && apt-get install -y firefox

WORKDIR /EagleEye
COPY . /EagleEye

RUN pip3 install -r requirements.txt
RUN pip3 install --upgrade beautifulsoup4 html5lib spry

# Update Geckodriver to a newer version
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz -O geckodriver.tar.gz
RUN tar -xvf geckodriver.tar.gz
RUN mv geckodriver /usr/bin/geckodriver
RUN chmod +x /usr/bin/geckodriver

RUN chmod +x /EagleEye/entry.sh
ENTRYPOINT ["bash", "/EagleEye/entry.sh"]
