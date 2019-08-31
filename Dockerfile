# User can select the base image.
# For BASE_IMAGE choices, see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

ARG BASE_IMAGE=jupyter/minimal-notebook
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-08-31

LABEL Name="senzing/jupyter" \
      Maintainer="support@senzing.com" \
      Version="1.1.0"

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
      gnupg \
      jq \
      lsb-core \
      lsb-release \
      odbc-postgresql \
      postgresql-client \
      python-dev \
      python-pip \
      python-pyodbc \
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

RUN conda create -n ipykernel_py2 python=2 ipykernel

# Python libraries for python 2.7.

RUN conda install -n ipykernel_py2 -y \
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

RUN conda install -n ipykernel_py2 -c conda-forge -y \
      widgetsnbextension \
      ipywidgets

# Install jupyter widgets for qgrid.

RUN conda run -n ipykernel_py2 jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Enable qgrid inside jupyter notebooks.

RUN conda run -n ipykernel_py2 jupyter labextension install qgrid

# Install python 2.7 kernel for users.

RUN conda run -n ipykernel_py2 python -m ipykernel install --user

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

WORKDIR /notebooks
