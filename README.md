# docker-jupyter

## Overview

The `docker-jupyter` repository holds example Senzing
[Jupyter](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/jupyter-notebook.md)
notebooks in the
[notebooks](notebooks)
subdirectory.

The `senzing/jupyter` docker image is a Senzing-ready image hosting
the example [Senzing notebooks](notebooks).

These notebooks are built upon the
[DockerHub Jupyter organization](https://hub.docker.com/u/jupyter) docker images.
The default base image is [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook).
There is more information on the
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io).

### Contents

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Quick starts](#quick-starts)
1. [Demonstrate](#demonstrate)
    1. [Initialize Senzing](#initialize-senzing)
    1. [Configuration](#configuration)
    1. [Volumes](#volumes)
    1. [Run docker container](#run-docker-container)
    1. [Database connection configuration](#database-connection-configuration)
    1. [Run Jupyter](#run-jupyter)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Examples](#examples)
1. [Errors](#errors)
1. [References](#references)

## Expectations

### Space

This repository and demonstration require 9 GB free disk space.

### Time

Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [Jupyter](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/jupyter.md)
1. [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate

### Initialize Senzing

1. If Senzing has not been initialized, visit
   [HOWTO - Initialize Senzing](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/initialize-senzing.md).

### Configuration

Configuration values specified by environment variable or command line parameter.

Non-Senzing configuration can be seen at
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

- **[JUPYTER_NOTEBOOKS_SHARED_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#jupyter_notebooks_shared_dir)**
- **[SENZING_DATABASE_URL](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_database_url)**

### Volumes

The output of `yum install senzingapi` placed files in different directories.
Create a folder for each output directory.

1. :pencil2: Option #1.
   To mimic an actual RPM installation,
   identify directories for RPM output in this manner:

    ```console
    export SENZING_DATA_VERSION_DIR=/opt/senzing/data/1.0.0
    export SENZING_ETC_DIR=/etc/opt/senzing
    export SENZING_G2_DIR=/opt/senzing/g2
    export SENZING_VAR_DIR=/var/opt/senzing
    ```

1. :pencil2: Option #2.
   If Senzing directories were put in alternative directories,
   set environment variables to reflect where the directories were placed.
   Example:

    ```console
    export SENZING_VOLUME=/opt/my-senzing

    export SENZING_DATA_VERSION_DIR=${SENZING_VOLUME}/data/1.0.0
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    export SENZING_G2_DIR=${SENZING_VOLUME}/g2
    export SENZING_VAR_DIR=${SENZING_VOLUME}/var
    ```

### Run docker container

1. :pencil2: Set environment variables.
   Example:

    ```console
    export JUPYTER_NOTEBOOKS_SHARED_DIR=$(pwd)
    export WEBAPP_PORT=8888
    ```

1. :pencil2: If using a docker network, specify docker network.
   Example:

    ```console
    sudo docker network ls
    ```

    Choose value from NAME column of `docker network ls`.

    ```console
    export SENZING_NETWORK=*nameofthe_network*
    export SENZING_NETWORK_PARAMETER="--net ${SENZING_NETWORK}"
    ```

1. :pencil2: If using an external database, specify database.
   Example:

    ```console
    export DATABASE_PROTOCOL=postgresql
    export DATABASE_USERNAME=postgres
    export DATABASE_PASSWORD=postgres
    export DATABASE_HOST=senzing-postgresql
    export DATABASE_PORT=5432
    export DATABASE_DATABASE=G2
    ```

    Construct parameter for `docker run`.

    ```console
    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"

    export SENZING_DATABASE_URL_PARAMETER="--env SENZING_DATABASE_URL=${SENZING_DATABASE_URL}
    ```

1. Optional:  Run Jupter without token authentication.
   Example:

    ```console
    export JUPYTER_PARAMETERS="start.sh jupyter notebook --NotebookApp.token=''"
    ```

1. Run docker container.
   Example:

    ```console
    sudo docker run \
      ${SENZING_DATABASE_URL_PARAMETER} \
      ${SENZING_NETWORK_PARAMETER} \
      --interactive \
      --name senzing-jupyter \
      --publish ${WEBAPP_PORT}:8888 \
      --rm \
      --tty \
      --volume ${JUPYTER_NOTEBOOKS_SHARED_DIR}:/notebooks/shared \
      --volume ${SENZING_DATA_VERSION_DIR}:/opt/senzing/data \
      --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
      --volume ${SENZING_G2_DIR}:/opt/senzing/g2 \
      --volume ${SENZING_VAR_DIR}:/var/opt/senzing \
      senzing/jupyter ${JUPYTER_PARAMETERS}
    ```

### Run Jupyter

1. If no token authentication, access your jupyter notebooks at: [http://127.0.0.1:8888/](http://127.0.0.1:8888/)

1. If token authentication, locate the URL in the Docker log.  Example:

    ```console
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://(a152e5586fdc or 127.0.0.1):8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

    Adjust the URL.  Example:

    ```console
    http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

    Paste the URL into a web browser.

## Develop

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-jupyter
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Build docker image for development

1. Option #1 - Using `docker` command and GitHub.

    ```console
    sudo docker build --tag senzing/docker-jupyter https://github.com/senzing/docker-jupyter.git
    ```

1. Option #2 - Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/jupyter .
    ```

1. Option #3 - Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

    Note: `sudo make docker-build-development-cache` can be used to create cached docker layers.

## Examples

## Errors

1. See [docs/errors.md](docs/errors.md).

## References

1. [A gallery of interesting Jupyter Notebooks](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
1. [Senzing notebooks](notebooks)
