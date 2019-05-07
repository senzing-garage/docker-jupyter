# Simplified instructions for Windows

## Overview

The `senzing/jupyter` docker image is a Senzing-ready, python 3.7 image hosting
[jupyter](https://jupyter.org/).

These notebooks are built upon the DockerHub
[Jupyter organization](https://hub.docker.com/u/jupyter) docker images.
The default base image is [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook).
There is more information on the
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io).

## Prerequisite software

* [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md#windows)
* [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md#windows)

## Build docker image

*Note*: Budget about 30 to 45min., depending on your internet speed.
*Note*: It requires about 9GB of free disk.

```console
docker build \
  --tag senzing/jupyter \
  https://github.com/senzing/docker-jupyter.git
```

## Install Senzing

*Note*: Budget about 40min., depending on your internet speed.
*Note*: It requires about 4GB of free disk.

Follow the instructions at [HOWTO/create-senzing-dir.md](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md)

## Add Senzing directory to Docker

### Shell

Edit the file:

```console
${HOME}Library/Group\ Containers/group.com.docker/settings.json
```

It should have something like:

```console
{
  "channelID" : "stable",
  "filesharingDirectories" : [
    "/Users",
    "/Volumes",
    "/opt/senzing",
    "/private",
    "/tmp"
  ],
  "diskPath" : "Library/Containers/com.docker.docker/Data/vms/0/Docker.raw",
  "proxyHttpMode" : "system",
  "linuxDaemonConfigCreationDate" : "2019-02-05 04:21:44 +0000",
  "displayedWelcomeMessage" : true,
  "dockerAppLaunchPath" : "/Applications/Docker.app",
  "memoryMiB" : 2048,
  "buildNumber" : "30215",
  "version" : "2.0.0.2",
  "displayedWelcomeWhale" : true,
  "cpus" : 2,
  "settingsVersion" : 1,
  "diskSizeMiB" : 61035
}
```

The important part is that ```filesharingDirectories```
contains ```"/opt/senzing"```.

### Docker Application

*Preferences... > File Sharing > +* and then add ```/opt/senzing```

## Simple docker container run

This is a simplified version that is aimed at individuals testing in their own
computer.

```console
export WEBAPP_PORT=8888
export SENZING_DIR=/opt/senzing

docker run -it \
  --volume ${SENZING_DIR}:/opt/senzing \
  --publish ${WEBAPP_PORT}:8888 \
  senzing/jupyter \
    start.sh jupyter notebook --NotebookApp.token=''
```

Access your notebook at: [http://127.0.0.1:8888/](http://127.0.0.1:8888/)
