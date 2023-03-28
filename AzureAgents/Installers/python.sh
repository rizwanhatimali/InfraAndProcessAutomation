#!/bin/bash -e
################################################################################
##  File:  python.sh
##  Desc:  Installs Python
################################################################################

add-apt-repository ppa:deadsnakes/ppa

apt update

apt install python3.11-full

python3.11 -V 