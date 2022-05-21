# Set up StarCraft II Test Environment for Dentosal python-sc2 bots (not pysc2 bots!)
ARG PYTHON_VERSION=3.8

# Use an official debian stretch slim release as a base image
FROM python:$PYTHON_VERSION-slim
MAINTAINER Burny <gamingburny@gmail.com>

ARG SC2_VERSION=4.10

USER root

# Update apt-get
RUN apt-get update \
    && apt-get upgrade --assume-yes --quiet=2

# From https://github.com/yeungegs/egsy-dockerfiles/tree/master/botbierv2
# Update and install packages for SC2 development environment
# git, unzip and wget for download and extraction
# rename to rename maps
# tree for debugging
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    git  \
    unzip \
    wget \
    rename \
    tree

# Set working directory to root, this uncompresses StarCraftII below to folder /root/StarCraftII
WORKDIR /root/

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
# If file is locally available, use this instead:
# ADD SC2.4.10.zip /root/
# RUN unzip -P iagreetotheeula SC2.4.10.zip \
#    && rm *.zip
RUN wget --quiet --show-progress --progress=bar:force http://blzdistsc2-a.akamaihd.net/Linux/SC2.$SC2_VERSION.zip \
    && unzip -q -P iagreetotheeula SC2.$SC2_VERSION.zip \
    && rm *.zip

# Remove the Maps that come with the SC2 client
RUN mkdir -p /root/StarCraftII/maps/ \
    && rm -Rf /root/StarCraftII/maps/*

# Create a symlink for the maps directory
RUN ln -s /root/StarCraftII/Maps /root/StarCraftII/maps

# Change to maps folder
WORKDIR /root/StarCraftII/maps/

# Maps are available here https://github.com/Blizzard/s2client-proto#map-packs and here http://wiki.sc2ai.net/Ladder_Maps
# Download and uncompress StarCraftII Maps, remove zip file - using "maps" instead of "Maps" as target folder
RUN wget -q \
    http://archive.sc2ai.net/Maps/Season1Maps.zip \
    http://archive.sc2ai.net/Maps/Season2Maps.zip \
    http://archive.sc2ai.net/Maps/Season3Maps.zip \
    http://archive.sc2ai.net/Maps/Season4Maps.zip \
    http://archive.sc2ai.net/Maps/Season5Maps.zip \
    http://archive.sc2ai.net/Maps/Season6Maps.zip \
    http://archive.sc2ai.net/Maps/Season7Maps.zip \
    http://archive.sc2ai.net/Maps/Season8Maps.zip \
    http://archive.sc2ai.net/Maps/Season9Maps.zip \
    http://archive.sc2ai.net/Maps/Season10Maps.zip \
    && unzip -q -o '*.zip' \
    && rm *.zip

RUN wget -q http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2019Season3.zip \
    && unzip -q -P iagreetotheeula -o 'Ladder2019Season3.zip' \
    && mv Ladder2019Season3/* . \
    && rm -r Ladder2019Season3

# Remove LE suffix from file names
RUN rename -v 's/LE.SC2Map/.SC2Map/' *.SC2Map

RUN wget -q https://github.com/shostyn/sc2patch/raw/master/Maps/506.zip \
    && unzip -q -o '506.zip' \
    && rm *.zip

RUN wget -q http://blzdistsc2-a.akamaihd.net/MapPacks/Melee.zip \
    && unzip -q -P iagreetotheeula -o 'Melee.zip' \
    && mv Melee/* . \
    && rm -r Melee

# List all map files
RUN tree

WORKDIR /root/

ENTRYPOINT [ "/bin/bash" ]

# To run a python-sc2 bot:
# Install python-sc2 and requirements via pip:
# python -m pip install --upgrade https://github.com/BurnySc2/python-sc2/archive/develop.zip


# To run an example bot, copy one to your container and then run it with python:
# python /your-bot.py