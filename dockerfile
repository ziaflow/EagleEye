# Use 22.04 for Python 3.10 support
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Setup Locales
RUN apt-get update && apt-get install -y locales && apt-get clean && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install System Dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y git curl software-properties-common unzip wget \
    python3-pip python3-dev libgtk-3-dev libboost-all-dev build-essential \
    cmake libffi-dev firefox dos2unix && \
    apt-get clean

WORKDIR /EagleEye

# Clone the repo inside the build process or COPY your local version
# If you want to use your local modified files, use: COPY . /EagleEye
RUN git clone https://github.com/ThoughtfulDev/EagleEye .

# --- CRITICAL FIXES ---
# 1. Fix line endings immediately
RUN find . -type f -name "*.sh" -exec dos2unix {} +

# 2. Manage Python Dependencies
RUN pip3 install --upgrade pip
# Force older urllib3 to avoid the 'RequestsDependencyWarning' crash
RUN pip3 install "urllib3<2.0.0"
RUN pip3 install -r requirements.txt

# 3. Update Geckodriver (using a more recent version for modern Firefox)
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz -O geckodriver.tar.gz && \
    tar -xvf geckodriver.tar.gz && \
    mv geckodriver /usr/bin/geckodriver && \
    chmod +x /usr/bin/geckodriver && \
    rm geckodriver.tar.gz

# Ensure the entrypoint script is executable and cleaned
RUN chmod +x entry.sh && dos2unix entry.sh

ENTRYPOINT ["/bin/bash", "./entry.sh"]