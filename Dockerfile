# Set up StarCraft II Test Environment for Dentosal python-sc2 bots (not pysc2 bots!)

# Use an official Ubuntu release as a base image
FROM ubuntu:16.04
MAINTAINER Burny <gamingburny@gmail.com>

USER root
WORKDIR /root/

# Update apt-get for gcc4.9
RUN apt-get update --assume-yes --quiet=2 \
    && apt-get install --assume-yes --quiet=2 software-properties-common \
     python-software-properties

# From https://github.com/yeungegs/egsy-dockerfiles/tree/master/botbierv2
# Update and install packages for SC2 development environment
# build-essential and cmake to install the S2Client API
# git, unzip and wget for download and extraction
# tree for debugging
RUN apt-get update --assume-yes --quiet=2 \
    && apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    net-tools \
    build-essential \
    cmake \
    git  \
    make \
    # Tree for debugging
    tree \
    unzip \
    wget

# Install python 3.6 with pip
RUN add-apt-repository ppa:jonathonf/python-3.6 \
    && apt-get update --assume-yes --quiet=2 \
    && apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    python3.6 \
    python3-setuptools \
    python3-pip

# Install Blizzard S2Client API
RUN git clone --recursive https://github.com/Blizzard/s2client-api
WORKDIR s2client-api
WORKDIR build
RUN cmake ../
RUN make

# Set working directory to root
WORKDIR /root/

# Change default python 2.7 => 3.6
RUN /bin/bash -c "ln -sfn /usr/bin/python3.6 /usr/bin/python"

# Upgrade pip and install pip-install requirements
RUN python -m pip install --upgrade pip
RUN python -m pip install pipenv

# Download and uncompress StarCraftII, remove zip file
# If file is locally available, use this instead:
# ADD SC2.4.1.2.60604_2018_05_16.zip /root/
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.1.2.60604_2018_05_16.zip' \
    && unzip -P iagreetotheeula SC2.4.1.2.60604_2018_05_16.zip \
    && rm *.zip

# Download and uncompress StarCraftII Maps, remove zip file - using "map" instead of "Maps" as target folder
RUN wget -q http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season2_Updated.zip \
    && unzip -P iagreetotheeula Ladder2018Season2_Updated.zip -d ~/StarCraftII/maps/ \
    && rm *.zip


ENTRYPOINT [ "/bin/bash" ]

# To run the python-sc2 bot:
# Install python-sc2 and requirements via pip or python -m pip
# 
# RUN python ~/python-sc2-docker/testing/python-sc2-zergrush/zerg_rush.py
