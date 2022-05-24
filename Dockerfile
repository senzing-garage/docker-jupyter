# User can select the base image.
# For BASE_IMAGE choices, see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

ARG BASE_IMAGE=jupyter/minimal-notebook:ubuntu-20.04@sha256:2d53044baa4ea352a1a22ab5866c093c0b2df73c8d5bcda3ee205d5abbbe592b
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-05-24

LABEL Name="senzing/jupyter" \
      Maintainer="support@senzing.com" \
      Version="2.0.1"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

#############################################
## OS infrastructure
#############################################

USER root

# Update OS packages.

RUN apt-get update
RUN apt-get -y upgrade
RUN apt -y autoremove

# Install packages via apt.

RUN apt-get -y install \
      curl \
      default-jdk \
      gnupg \
      jq \
      lsb-core \
      lsb-release \
      odbc-postgresql \
      postgresql-client \
      python-dev \
      sqlite \
      unixodbc \
      unixodbc-dev \
      wget \
 && rm -rf /var/lib/apt/lists/*

#############################################
## Python infrastructure
#############################################

# Update Anaconda.

RUN conda update -y -n base conda

# Python 2.

RUN conda create -n ipykernel_py3 python=3 ipykernel

# Python libraries for python 2.7.

RUN conda install -n ipykernel_py3 -y \
      bokeh \
      ipykernel \
      ipython \
      networkx \
      numpy \
      pandas \
      plotly \
      psutil \
      pyodbc \
      qgrid \
      seaborn \
      sympy \
      version_information

# Install notebook widgets.

RUN conda install -n ipykernel_py3 -c conda-forge -y \
      widgetsnbextension \
      ipywidgets

# Install jupyter widgets for qgrid.

RUN conda run -n ipykernel_py3 jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Enable qgrid inside jupyter notebooks.

RUN conda install qgrid

# Install python 2.7 kernel for users.

RUN conda run -n ipykernel_py3 python -m ipykernel install --user

# Install Java kernel

RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip \
 && unzip ijava-kernel.zip -d ijava-kernel \
 && cd ijava-kernel \
 && python3 install.py --sys-prefix

# Update notebook

RUN pip3 install --upgrade ipykernel --user
# Update nodeJS.

RUN npm i -g npm

#############################################
## Prepare user home dir
#############################################

# Copy files from repository.

COPY ./rootfs /
COPY ./notebooks /notebooks
VOLUME /notebooks/shared

# Adjust permissions

RUN chown -R $NB_UID:$NB_GID /notebooks
RUN chmod -R ug+rw /notebooks
RUN chown -R $NB_UID:$NB_GID /home/$NB_USER
RUN chmod -R ug+rw /home/$NB_USER

# Install nbextensions
RUN conda install -c conda-forge jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --system
RUN jupyter nbextension enable toc2/main --system \
 && jupyter nbextension enable collapsible_headings/main --system


#############################################
## User environment setting
#############################################

# Return to original user.
# Defined in https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

USER $NB_UID

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian
ENV DB2_CLI_DRIVER_INSTALL_PATH=${SENZING_ROOT}/db2/clidriver
ENV PATH=$PATH:${SENZING_ROOT}/db2/clidriver/adm:${SENZING_ROOT}/db2/clidriver/bin
ENV IJAVA_CLASSPATH=/opt/senzing/g2/lib/g2.jar
ENV DYLD_LIBRARY_PATH=/opt/senzing/g2/lib/

WORKDIR /notebooks
