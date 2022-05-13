# Source repo:
https://github.com/BurnySc2/python-sc2-docker

This repository is related to the docker image on https://hub.docker.com/r/burnysc2/python-sc2-docker/

Some images may use https://github.com/BurnySc2/aiarena-client

# Build locally
Example build command:
```
docker build -t burnysc2/python-sc2-docker:py_3.10-sc2_4.10 --build-arg PYTHON_VERSION=3.10 --build-arg SC2_VERSION=4.10 .
```


