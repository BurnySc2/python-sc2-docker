# Set up StarCraft II Test Environment for Dentosal python-sc2 bots (not pysc2 bots!)

# Use an official Ubuntu release as a base image
FROM ubuntu:16.04
MAINTAINER Burny <gamingburny@gmail.com>

USER root
WORKDIR /root/

# Update apt-get for gcc4.9
RUN apt-get update --assume-yes --quiet=2
RUN apt-get install --assume-yes --quiet=2 software-properties-common \
    python-software-properties

# From https://github.com/yeungegs/egsy-dockerfiles/tree/master/botbierv2
# Update and install packages for SC2 development environment
RUN apt-get update --assume-yes --quiet=2
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    net-tools \
    build-essential \
    clang \
    cmake \
    curl  \
    git  \
    gzip \
    htop  \
    libidn11  \
    libz-dev \
    libssl-dev \
    make \
    software-properties-common \
    tar \
    tree \
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

# Upgrade pip and install pip-install requirements
RUN python -m pip install --upgrade pip
RUN python -m pip install pipenv

ENTRYPOINT [ "/bin/bash" ]

# To run the python-sc2 bot:
# Install python-sc2 and requirements via pip or python -m pip
# 
# RUN python ~/python-sc2-docker/testing/python-sc2-zergrush/zerg_rush.py
