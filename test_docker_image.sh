# This script is meant for development, which produces fresh images and then runs tests

# Set which versions to use
export PYTHON_VERSION=3.9
export SC2_VERSION=4.10
export VERSION_NUMBER=1.0.0

# Build images
docker build -t burnysc2/python-sc2-docker:latest --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER .

# Delete previous container if it exists
docker rm -f test_container

# Start container, override the default entrypoint
docker run -it -d \
  --name test_container \
  --entrypoint /bin/bash \
  test_image

# Install python-sc2
docker exec -it test_container bash -c "pip install poetry \
    && git clone https://github.com/BurnySc2/python-sc2 python-sc2 \
    && cd python-sc2 && poetry install"

# Run various test bots
docker exec -it test_container bash -c "cd python-sc2 && poetry run python test/travis_test_script.py test/autotest_bot.py"
docker exec -it test_container bash -c "cd python-sc2 && poetry run python test/run_example_bots_vs_computer.py"

# Command for entering the container to debug if something went wrong:
# docker exec -it test_container bash
