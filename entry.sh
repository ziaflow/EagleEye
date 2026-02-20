#!/bin/bash
# Downgrade fake-useragent to a version compatible with Python 3.8
pip3 install "fake-useragent<1.4.0"

cd /EagleEye
TARGET_NAME=${NAME:-"Kristina"}
python3 eagle-eye.py --docker --name "$TARGET_NAME"

#now copy the result
yes | cp -rf /EagleEye/*.pdf /result/
