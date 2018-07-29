# Set up StarCraft II Learning Environment
# docker run -it \
#        -e /bin/bash \
#        --name sc2ai
#         egsy/sc2ai

# Use an official Ubuntu release as a base image
FROM ubuntu:16.04
# FROM alpine:latest as game
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

# Uncompress StarCraftII
RUN unzip -P iagreetotheeula SC2.4.1.2.60604_2018_05_16.zip

# Download StarCraftII Maps
RUN wget -q http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season2_Updated.zip

# Uncompress zip files
RUN unzip -P iagreetotheeula Ladder2018Season2_Updated.zip -d ~/StarCraftII/Maps/

# Remove zip files
RUN rm *.zip

# Change default python 2.7 => 3.6
RUN /bin/bash -c "ln -sfn /usr/bin/python3.6 /usr/bin/python"

# install python-sc2
RUN python -m pip install --upgrade pip
RUN python -m pip install sc2

# Set g++4.9 as default compiler by updating symbolic link
RUN ln -f -s /usr/bin/g++-4.9 /usr/bin/g++

# # Install sc2
# RUN pip3.6 install sc2 && export SC2PATH=~/StarCraftII/

ENTRYPOINT [ "/bin/bash" ]
# docker build -t python5 .
# docker run -i -t python5


# # # Make Directory
# # RUN mkdir -p /home/ladder/

# # # Change permissions
# # RUN chmod -R 777 /home/ladder

# # # Move StarCraftII to /home/ladder
# # RUN mv ~/StarCraftII /home/ladder/

# # Install pip packages
# RUN python -m pip install sc2 networkx matplotlib
