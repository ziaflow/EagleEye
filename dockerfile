FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Dependencies (Linux versions of Firefox and tools)
RUN apt-get update && apt-get install -y \
    locales \
    git \
    curl \
    software-properties-common \
    unzip \
    wget \
    python3-pip \
    python3-dev \
    libgtk-3-dev \
    libboost-all-dev \
    build-essential \
    cmake \
    libffi-dev \
    firefox \
    dos2unix && \
    apt-get clean

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# 2. Set working directory
WORKDIR /EagleEye

# 3. Copy project files from C:\Users\jerem\EagleEye into the container
COPY . /EagleEye

# 4. Fix Windows line endings and permissions
RUN dos2unix /EagleEye/entry.sh && chmod +x /EagleEye/entry.sh

# 5. Install Python Dependencies
RUN pip3 install --upgrade pip
RUN pip3 install "urllib3<2.0.0"
RUN pip3 install lxml_html_clean
RUN pip3 install -r requirements.txt

# 6. Install Geckodriver (Needed for Firefox automation)
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz && \
    tar -xvzf geckodriver-v0.33.0-linux64.tar.gz && \
    mv geckodriver /usr/local/bin/ && \
    rm geckodriver-v0.33.0-linux64.tar.gz

# 7. Create the missing result directory
RUN mkdir -p /result

# Set entry point
ENTRYPOINT ["/bin/bash", "/EagleEye/entry.sh"]