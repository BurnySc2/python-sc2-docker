FROM python:3.6
MAINTAINER Burny <gamingburny@gmail.com>

USER root
WORKDIR /root

# Install wget and unzip
RUN apt-get update
RUN apt-get install wget unzip git tar gzip -y

# Install StarCraftII
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.1.2.60604_2018_05_16.zip'

# Uncompress StarCraftII
RUN unzip -P iagreetotheeula SC2.4.1.2.60604_2018_05_16.zip

# Download Sc2Ai Ladderserver
RUN wget -q https://jenkins.m1nd.io/job/Sc2LadderServer/lastSuccessfulBuild/artifact/build/bin/Sc2LadderServer
# RUN mkdir ~/StarCraftII
RUN mv Sc2LadderServer ~/StarCraftII
RUN chmod +x ~/StarCraftII/Sc2LadderServer

# Delete zip files
RUN rm SC2.4.1.2.60604_2018_05_16.zip

# Make Directory
RUN mkdir -p /home/ladder/

# Change permissions
RUN chmod -R 777 /home/ladder

# Move StarCraftII to /home/ladder
RUN mv ~/StarCraftII /home/ladder/

# Install pip packages
RUN python3 -m pip install sc2 networkx matplotlib

# Change default python 2.7 => 3
RUN /bin/bash -c "ln -sfn /usr/bin/python3 /usr/bin/python"