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

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Quick starts](#quick-starts)
1. [Demonstrate](#demonstrate)
    1. [Create SENZING_DIR](#create-senzing_dir)
    1. [Configuration](#configuration)
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

## Quick starts

1. [Simplified instructions for macOS](docs/simplified-instructions-for-macos.md)

## Demonstrate

### Create SENZING_DIR

1. If you do not already have an `/opt/senzing` directory on your local system, visit
   [HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).

### Configuration

Non-Senzing configuration can be seen at
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

* **SENZING_DATABASE_URL** -
  Database URI in the form: `${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}`.
  The default is to use the SQLite database.
* **SENZING_DIR** -
  Path on the local system where
  [Senzing_API.tgz](https://s3.amazonaws.com/public-read-access/SenzingComDownloads/Senzing_API.tgz)
  has been extracted.
  See [Create SENZING_DIR](#create-senzing_dir).
  No default.
  Usually set to "/opt/senzing".

### Run docker container

#### Variation 1

Run the docker container with internal SQLite database, external volume, and token authentication.

1. :pencil2: Set environment variables.  Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_DIR=/opt/senzing
    export SHARED_DIR=$(pwd)
    ```

1. Run docker container.  Example:

    ```console
    sudo docker run \
      --interactive \
      --name senzing-jupyter \
      --publish ${WEBAPP_PORT}:8888 \
      --rm \
      --tty \
      --volume ${SHARED_DIR}:/notebooks/shared \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/jupyter
    ```

#### Variation 2

Like Variation #1 but without token authentication.

1. :pencil2: Set environment variables.  Example:

    ```console
    export WEBAPP_PORT=8888
    export SENZING_DIR=/opt/senzing
    export SHARED_DIR=$(pwd)
    ```

1. Run docker container.  Example:

    ```console
    sudo docker run \
      --interactive \
      --name senzing-jupyter \
      --publish ${WEBAPP_PORT}:8888 \
      --rm \
      --volume ${SHARED_DIR}:/notebooks/shared \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/jupyter \
        start.sh jupyter notebook --NotebookApp.token=''
    ```

#### Variation 3

Run the docker container with MySQL database and volumes.

1. :pencil2: Set environment variables.  Example:

    ```console
    export DATABASE_PROTOCOL=mysql
    export DATABASE_USERNAME=root
    export DATABASE_PASSWORD=root
    export DATABASE_HOST=senzing-mysql
    export DATABASE_PORT=3306
    export DATABASE_DATABASE=G2
    export SENZING_DIR=/opt/senzing
    export SHARED_DIR=$(pwd)
    export WEBAPP_PORT=8888
    ```

1. Run docker container.  Example:

    ```console
    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"

    sudo docker run \
      --env SENZING_DATABASE_URL="${SENZING_DATABASE_URL}" \
      --interactive \
      --name senzing-jupyter \
      --publish ${WEBAPP_PORT}:8888 \
      --rm \
      --tty \
      --volume ${SHARED_DIR}:/notebooks/shared \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/jupyter
    ```

#### Variation 4

Run the docker container accessing an external MySQL database in a docker network.

1. :pencil2: Determine docker network.  Example:

    ```console
    sudo docker network ls

    # Choose value from NAME column of docker network ls
    export SENZING_NETWORK=nameofthe_network
    ```

1. :pencil2: Set environment variables.  Example:

    ```console
    export DATABASE_PROTOCOL=mysql
    export DATABASE_USERNAME=root
    export DATABASE_PASSWORD=root
    export DATABASE_HOST=senzing-mysql
    export DATABASE_PORT=3306
    export DATABASE_DATABASE=G2
    export WEBAPP_PORT=8888
    export SENZING_DIR=/opt/senzing
    export SHARED_DIR=$(pwd)
    ```

1. Run docker container.  Example:

    ```console
    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"

    sudo docker run \
      --env SENZING_DATABASE_URL="${SENZING_DATABASE_URL}" \
      --interactive \
      --name senzing-jupyter \
      --net ${SENZING_NETWORK} \
      --publish ${WEBAPP_PORT}:8888 \
      --rm \
      --tty \
      --volume ${SHARED_DIR}:/notebooks/shared \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/jupyter
    ```

### Database connection configuration

When using PostgreSQL, MySQL, and DB2 database,
database connection configuration in the container needs to be updated.

1. From a new terminal, log into the `senzing-jupyter` container.  Example:

    ```console
    sudo docker exec \
      --interactive \
      --tty \
      --user root \
      senzing-jupyter \
        /bin/bash
    ```

1. Inside the `senzing-jupyter` container:

    ```console
    /app/docker-entrypoint.sh
    exit
    ```

### Run Jupyter

1. If no token authentication (Variation #2), access your jupyter notebooks at: [http://127.0.0.1:8888/](http://127.0.0.1:8888/)

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

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-jupyter
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

1. After the repository has been cloned, be sure the following are set:

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

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

    Note: `sudo make docker-build-base` can be used to create cached docker layers.

## Examples

## Errors

1. See [docs/errors.md](docs/errors.md).

## References

1. [A gallery of interesting Jupyter Notebooks](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
1. Senzing notebooks
    1. [senzing-addDataSource](notebooks/senzing-examples/python/senzing-addDataSource.ipynb)
    1. [senzing-addRecord](notebooks/senzing-examples/python/senzing-addRecord.ipynb)
    1. [senzing-getSummaryData](notebooks/senzing-examples/python/senzing-getSummaryData.ipynb)
