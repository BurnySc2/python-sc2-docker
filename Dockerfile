# Set up StarCraft II Test Environment for Dentosal python-sc2 bots (not pysc2 bots!)

# Use an official debian stretch slim release as a base image
FROM python:3.7-slim
MAINTAINER Burny <gamingburny@gmail.com>

USER root

# From https://github.com/yeungegs/egsy-dockerfiles/tree/master/botbierv2
# Update and install packages for SC2 development environment
# git, unzip and wget for download and extraction
# tree for debugging
RUN apt-get update && apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git \
    make \
    gcc \
    tree \
    unzip \
    wget \
    gpg \
    python-dev \
    procps \
    lsof \
    apt-transport-https \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Add the microsoft repo for dotnetcore
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Needed to use the 32bit version of wine
RUN dpkg --add-architecture i386

# Install software via APT
RUN apt-get update && apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    openjdk-11-jdk \
    wine32 \
    dotnet-sdk-2.2 \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/
ENV PATH $PATH

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
# If file is locally available, use this instead:
#ADD SC2.4.10.zip /root/
#RUN unzip -P iagreetotheeula SC2.4.10.zip \
#    && rm *.zip
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip' \
    && unzip -P iagreetotheeula SC2.4.10.zip \
    && rm *.zip

# Create a symlink for the maps directory
RUN ln -s /root/StarCraftII/Maps /root/StarCraftII/maps

# Remove the Maps that come with the SC2 client
RUN rm -Rf /root/StarCraftII/maps/*

# Change to maps folder
WORKDIR /root/StarCraftII/maps/

# Maps are available here https://github.com/Blizzard/s2client-proto#map-packs and here http://wiki.sc2ai.net/Ladder_Maps
# Download and uncompress StarCraftII Maps, remove zip file - using "maps" instead of "Maps" as target folder
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

RUN wget http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2019Season3.zip
RUN unzip -P iagreetotheeula -o 'Ladder2019Season3.zip'
RUN mv Ladder2019Season3/* .
RUN rmdir Ladder2019Season3

RUN wget http://blzdistsc2-a.akamaihd.net/MapPacks/Melee.zip
RUN unzip -P iagreetotheeula -o 'Melee.zip'
RUN mv Melee/* .
RUN rmdir Melee

RUN rm *.zip
RUN tree

WORKDIR /root/

# Add Pythonpath to env to user aiarena
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/:/root/.local/bin
ENV HOST 0.0.0.0

# Download python requirements files
RUN wget https://gitlab.com/aiarena/aiarena-client/raw/master/requirements.linux.txt -O client-requirements.txt
RUN wget https://gitlab.com/aiarena/aiarena-client-provisioning/raw/master/aiarena-vm/templates/python-requirements.txt.j2 -O bot-requirements.txt

# Install python modules
RUN pip install -r client-requirements.txt
RUN pip install -r bot-requirements.txt

# Download the aiarena client
RUN wget https://gitlab.com/aiarena/aiarena-client/-/archive/master/aiarena-client-master.tar.gz \
    && tar xvzf aiarena-client-master.tar.gz \
    && mv aiarena-client-master aiarena-client

# Create Bot and Replay directories
RUN mkdir -p /root/StarCraftII/Bots
RUN mkdir -p /root/StarCraftII/Replays

# Change to working directory
WORKDIR /root/aiarena-client

# List contents of directory
RUN tree

# Install the arena client as a module
#RUN python /root/aiarena-client/setup.py install

# Setup the config file
RUN echo '{"bot_directory_location": "/root/StarCraftII/Bots", "sc2_directory_location": "/root/StarCraftII/", "replay_directory_location": "/root/StarCraftII/Replays", "API_token": "", "max_game_time": "60486", "allow_debug": "Off", "visualize": "Off"}' > /root/aiarena-client/arenaclient/proxy/settings.json

WORKDIR /root/aiarena-client/arenaclient

# Start the proxy server
ENTRYPOINT [ "python", "proxy/server.py", "-f" ]
