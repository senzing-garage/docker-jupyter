# docker-jupyter

## Overview

The `senzing/jupyter` docker image is a Senzing-ready, python 2.7 image hosting
[jupyter](https://jupyter.org/).

These notebooks are built upon the DockerHub
[Jupyter organization](https://hub.docker.com/u/jupyter) docker images.
The default base image is [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook).
There is more information on the
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io).

### Contents

1. [Demonstrate](#demonstrate)
    1. [Build docker image](#build-docker-image)
    1. [Create SENZING_DIR](#create-senzing_dir)
    1. [Configuration](#configuration)
    1. [Run docker container](#run-docker-container)
    1. [Run Jupyter](#run-jupyter)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Set environment variables for development](#set-environment-variables-for-development)
    1. [Clone repository](#clone-repository)
    1. [Git submodules](#git-submodules)
    1. [Build docker image for development](#build-docker-image-for-development)

### Expectations

- **Space:** It requires about 9GB of free disk.

## Quick starts

1. [Simplified instructions for macOS](docs/simplified-instructions-for-macos.md)

## Demonstrate

### Prerequisite software for demonstration

The following software programs need to be installed.

#### git

1. [Install Git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. Test

    ```console
    git --version
    ```

#### docker

1. [Install docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
1. Test

    ```console
    sudo docker --version
    sudo docker run hello-world
    ```

### Build docker image

```console
sudo docker build --tag senzing/jupyter https://github.com/senzing/docker-jupyter.git
```

### Create SENZING_DIR

1. If you do not already have an `/opt/senzing` directory on your local system, visit
   [HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).

### Configuration

Non-Senzing configuration can be seen at
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

- **SENZING_DATABASE_URL** -
  Database URI in the form: `${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}`
- **SENZING_DIR** -
  Location of Senzing libraries. Default: "/opt/senzing".

### Run docker container

1. Option #1 - Run the docker container with volumes and internal database and token authentication. Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_DIR=/opt/senzing

    sudo docker run -it \
      --volume ${SENZING_DIR}:/opt/senzing \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter
    ```

1. Option #1 without token authentication. Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_DIR=/opt/senzing

    sudo docker run -it \
      --volume ${SENZING_DIR}:/opt/senzing \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter \
        start.sh jupyter notebook --NotebookApp.token=''
    ```

1. Option #2 - Run the docker container with database and volumes.  Example:

    ```console
    export DATABASE_PROTOCOL=mysql
    export DATABASE_USERNAME=root
    export DATABASE_PASSWORD=root
    export DATABASE_HOST=senzing-mysql
    export DATABASE_PORT=3306
    export DATABASE_DATABASE=G2
    export WEBAPP_PORT=8888

    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"
    export SENZING_DIR=/opt/senzing

    sudo docker run -it  \
      --volume ${SENZING_DIR}:/opt/senzing \
      --env SENZING_DATABASE_URL="${SENZING_DATABASE_URL}" \
      --publish ${WEBAPP_PORT}:8888 \
      senzing/jupyter
    ```

1. Option #3 - Run the docker container accessing a database in a docker network. Example:

   Determine docker network. Example:

    ```console
    sudo docker network ls

    # Choose value from NAME column of docker network ls
    export SENZING_NETWORK=nameofthe_network
    ```

    Run docker container. Example:

    ```console
    export DATABASE_PROTOCOL=mysql
    export DATABASE_USERNAME=root
    export DATABASE_PASSWORD=root
    export DATABASE_HOST=senzing-mysql
    export DATABASE_PORT=3306
    export DATABASE_DATABASE=G2
    export WEBAPP_PORT=8888

    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"
    export SENZING_DIR=/opt/senzing

    sudo docker run -it  \
      --volume ${SENZING_DIR}:/opt/senzing \
      --net ${SENZING_NETWORK} \
      --publish ${WEBAPP_PORT}:8888 \
      --env SENZING_DATABASE_URL="${SENZING_DATABASE_URL}" \
      senzing/jupyter
    ```

### Run Jupyter

1. Locate the URL in the Docker log.  Example:

    ```console
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://(a152e5586fdc or 127.0.0.1):8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

1. Adjust the URL.  Example:

    ```console
    http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

1. Paste the URL into a web browser.

## Develop

### Prerequisite software

The following software programs need to be installed.

#### git for development

1. [Install Git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. Test

    ```console
    git --version
    ```

#### docker for development

1. [Install docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
1. Test

    ```console
    sudo docker --version
    sudo docker run hello-world
    ```

#### make

1. [Install make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. Test

    ```console
    make --version
    ```

### Set environment variables for development

1. These variables may be modified, but do not need to be modified.
   The variables are used throughout the installation procedure.

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-jupyter
    export DOCKER_IMAGE_TAG=senzing/jupyter
    ```

1. Synthesize environment variables.

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    export GIT_REPOSITORY_URL="git@github.com:${GIT_ACCOUNT}/${GIT_REPOSITORY}.git"
    ```

### Clone repository

1. Get repository.

    ```console
    mkdir --parents ${GIT_ACCOUNT_DIR}
    cd  ${GIT_ACCOUNT_DIR}
    git clone ${GIT_REPOSITORY_URL}
    ```

### Build docker image for development

1. Option #1 - Using make command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build
    ```

1. Option #2 - Using docker command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    docker build --tag ${DOCKER_IMAGE_TAG} .
    ```

## Reference

1. [A gallery of interesting Jupyter Notebooks](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)