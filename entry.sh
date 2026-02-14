#!/bin/bash
cd /EagleEye
python3 eagle-eye.py --docker --name "Kristina"

#now copy the result
yes | cp -rf /EagleEye/*.pdf /result/
