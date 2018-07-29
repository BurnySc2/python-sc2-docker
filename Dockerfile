# Set up StarCraft II Python-Sc2 Test Environment

# Use an official Ubuntu release as a base image
FROM ubuntu:16.04
MAINTAINER Burny <gamingburny@gmail.com>

USER root
WORKDIR /root/

# Update apt-get for gcc4.9
RUN apt-get update --assume-yes --quiet=2
RUN apt-get install --assume-yes --quiet=2 software-properties-common \
    python-software-properties

# Update and install packages for SC2 development environment
# RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update --assume-yes --quiet=2
# RUN apt-get build-dep --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 python-pygame
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    net-tools \
    build-essential \
    clang \
    cmake \
    curl  \
    git  \
    htop  \
    libidn11  \
    libz-dev \
    libssl-dev \
    make \
    software-properties-common \
    unzip \
    vim \
    wget

# Install python 3.6 with pip
RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update --assume-yes --quiet=2
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    python3.6 \
    python3-setuptools \
    python3-pip

# Install Blizzard S2Client API
RUN git clone --recursive https://github.com/Blizzard/s2client-api
WORKDIR s2client-api/
WORKDIR build/
RUN cmake ../
RUN make

# Set working directory to root
WORKDIR /root/

# Install wget and unzip
RUN apt-get update
RUN apt-get install wget unzip git tar gzip -y

# Install StarCraftII
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.1.2.60604_2018_05_16.zip'
# If file is locally available, use this instead:
# ADD SC2.4.1.2.60604_2018_05_16.zip /root/

# Uncompress StarCraftII
RUN unzip -P iagreetotheeula SC2.4.1.2.60604_2018_05_16.zip

# Download StarCraftII Maps
RUN wget -q http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season2_Updated.zip

# Uncompress zip files, using "maps" instead of "Maps" as target folder
RUN unzip -P iagreetotheeula Ladder2018Season2_Updated.zip -d ~/StarCraftII/maps/

# Remove zip files
RUN rm *.zip

# Change default python 2.7 => 3.6
RUN /bin/bash -c "ln -sfn /usr/bin/python3.6 /usr/bin/python"

# Download my bots
RUN git clone --recursive https://github.com/BurnySc2/python-sc2-docker

# Download python-sc2 from github
RUN git clone --recursive https://github.com/Dentosal/python-sc2

# Upgrade pip and install pip-install requirements
RUN python -m pip install --upgrade pip
RUN python -m pip install pipenv
# RUN python -m pip install sc2

# Install python-sc2 via setup.py file
RUN python -m pip install /root/python-sc2

# Add python-sc2 to path - not needed here since we install from setup.py
# ENV PYTHONPATH "${PYTHONPATH}:/root/python-sc2/"

# Run bot example
# RUN python ~/python-sc2-docker/testing/python-sc2-zergrush/zerg_rush.py
# TODO: need to run headless with 
# Command Line: '"/SC2/3.16.1/StarCraftII/Versions/Base55958/SC2_x64" -listen 127.0.0.1 -port 8167 -displayMode 0 -simulationSpeed 0 -windowwidth 1024 -windowheight 768 -windowx 100 -windowy 200'
# https://github.com/Blizzard/s2client-docker/issues/2

ENTRYPOINT [ "/bin/bash" ]
# to run the python-sc2 bot:
# RUN python ~/python-sc2-docker/testing/python-sc2-zergrush/zerg_rush.py

# Not relevant commands
# docker build -t python5 .
# docker run -i -t python5