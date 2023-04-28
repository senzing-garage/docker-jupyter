## Overview

The `docker-jupyter` repository holds example Senzing
[Jupyter](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/jupyter-notebook.md)
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

In addition, the Jupyter notebooks can be viewed on
[nbviewer.jupyter.org](https://nbviewer.jupyter.org/).
For example, visit
[Senzing examples on NbViewer](https://nbviewer.jupyter.org/github/Senzing/docker-jupyter/tree/master/notebooks/senzing-examples/python).

### Related artifacts

1. [DockerHub](https://hub.docker.com/r/senzing/jupyter)

### Contents

1. [Expectations](#expectations)
    1. [Environment](#environment)
    1. [Time](#time)
1. [Demonstrate using command line](#demonstrate-using-command-line)
    1. [Configuration](#configuration)
    1. [Volumes](#volumes)

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

### Environment

These notebooks are designed for the Windows OS and are expected to run in a single instance single window Windows standard command line. Python version 3.8+ is also required to run the notebooks. If you are looking to run the Jupyter Notebooks with linux and docker then go [here](https://github.com/Senzing/docker-jupyter).

### Time

Budget 20 minutes to set the environment and begin using the notebooks

### Background knowledge

This repository assumes a working knowledge of:

1. [Jupyter](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/jupyter.md)
1. Windows command line
1. Python

## Demonstrate using command line

### Configuration

Configuration values specified by environment variable or command line parameter.

Non-Senzing configuration can be seen at
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

- **[JUPYTER_NOTEBOOKS_SHARED_DIR](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#jupyter_notebooks_shared_dir)**
- **[SENZING_DATA_VERSION_DIR](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_data_version_dir)**
- **[SENZING_ETC_DIR](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_etc_dir)**
- **[SENZING_G2_DIR](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_g2_dir)**
- **[SENZING_NETWORK](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_network)**
- **[SENZING_RUNAS_USER](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_runas_user)**
- **[SENZING_VAR_DIR](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_var_dir)**

### Volumes

1. :pencil2: Specify the directory containing the Senzing installation. Remember to specify the correct driver letter

   Example:

    ```console
    set SENZING_VOLUME=C:\my-senzing
    ```

    1. Here's a simple test to see if `SENZING_VOLUME` is correct.
       The following commands should return file contents.
       Example:

        ```console
        type %SENZING_VOLUME%\g2\g2BuildVersion.json
        type %SENZING_VOLUME%\g2\data\libpostal\data_version
        ```

1. Identify the `data_version`, `etc`, `g2`, and `var` directories.
   Example:

    ```console
   set SENZING_G2_DIR=%SENZING_VOLUME%\g2
   set SENZING_DATA_VERSION_DIR=%SENZING_G2_DIR%\data\
   set SENZING_ETC_DIR=%SENZING_G2_DIR%\etc
   set SENZING_VAR_DIR=%SENZING_G2_DIR%\var
    ```

### Begin using notebooks

1. Run python

   ```console
   python3
   ```

For the notebooks to run properly, every new instance of python3 must requrie you to run the [senzing-init-config](https://github.com/Senzing/docker-jupyter/blob/main/notebooks/senzing-examples/Windows/senzing-init-config.ipynb) notebook
