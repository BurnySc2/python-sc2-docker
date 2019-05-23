# Set up StarCraft II Test Environment for Dentosal python-sc2 bots (not pysc2 bots!)

# Use an official debian stretch slim release as a base image
FROM python:3.6-slim
MAINTAINER Burny <gamingburny@gmail.com>

USER root
WORKDIR /root/

# Update apt-get
RUN apt-get update && apt-get upgrade --assume-yes --quiet=2

# From https://github.com/yeungegs/egsy-dockerfiles/tree/master/botbierv2
# Update and install packages for SC2 development environment
# g++ and make and cmake to install the S2Client API
# git, unzip and wget for download and extraction
# tree for debugging
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    net-tools \
    g++ \
    make \
    cmake \
    git  \
    make \
    tree \
    unzip \
    wget

# Upgrade pip and install pip-install requirements
RUN python -m pip install --upgrade pip pipenv

# Install Blizzard S2Client API
RUN git clone --recursive https://github.com/Blizzard/s2client-api
WORKDIR s2client-api
WORKDIR build
RUN cmake ../
RUN make

# Set working directory to root, this uncompresses StarCraftII below to folder /root/StarCraftII
WORKDIR /root/

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
# If file is locally available, use this instead:
#ADD SC2.4.7.1.zip /root/
#RUN unzip -P iagreetotheeula SC2.4.7.1.zip \
#    && rm *.zip
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.7.1.zip' \
    && unzip -P iagreetotheeula SC2.4.7.1.zip \
    && rm *.zip


# Maps are available here https://github.com/Blizzard/s2client-proto#map-packs and here http://wiki.sc2ai.net/Ladder_Maps
# Download and uncompress StarCraftII Maps, remove zip file - using "maps" instead of "Maps" as target folder
RUN mkdir /root/StarCraftII/maps/
WORKDIR /root/StarCraftII/maps/
RUN wget https://sc2ai.net/Maps/Season1Maps.zip
RUN wget https://sc2ai.net/Maps/Season2Maps.zip
RUN wget https://sc2ai.net/Maps/Season3Maps.zip
RUN wget https://sc2ai.net/Maps/Season4Maps.zip
RUN wget https://sc2ai.net/Maps/Season5Maps.zip
RUN wget https://sc2ai.net/Maps/Season6Maps.zip
RUN wget https://sc2ai.net/Maps/Season7Maps.zip
RUN wget http://wiki.sc2ai.net/images/9/95/S8Wk1Maps.zip
RUN wget http://wiki.sc2ai.net/images/a/af/Wk2maps.zip
RUN unzip -o '*.zip'
RUN rm *.zip
RUN tree


# Download laddermanager
RUN mkdir /root/lm
WORKDIR /root/lm
RUN wget http://dl.ai-arena.net/laddermanager.tar.gz
RUN tar -xvzf laddermanager.tar.gz
RUN tree
# Move files one directory up
RUN mv aiarena-client/* .
RUN rm -r aiarena-client
RUN rm *.tar.gz
RUN tree



ENTRYPOINT [ "/bin/bash" ]


# To run a python-sc2 bot:
# Install python-sc2 and requirements via pip:
# python -m pip install --upgrade git+https://github.com/Dentosal/python-sc2.git


# To run an example bot, copy one to your container and then run it with python:
# python /your-bot.py
