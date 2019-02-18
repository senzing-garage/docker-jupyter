# User can select the base image.
# For BASE_CONTAINER choices, see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM ${BASE_CONTAINER}

ENV REFRESHED_AT=2019-02-18

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
      libmysqlclient-dev \
      lsb-core \
      lsb-release \
      python-dev \
      python-pip \
      python-pyodbc \
      sqlite \
      unixodbc \
      unixodbc-dev \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Install libmysqlclient.

ENV DEBIAN_FRONTEND=noninteractive
RUN wget -qO - https://repo.mysql.com/RPM-GPG-KEY-mysql | apt-key add - \
 && wget https://repo.mysql.com/mysql-apt-config_0.8.11-1_all.deb \
 && dpkg --install mysql-apt-config_0.8.11-1_all.deb \
 && apt-get update \
 && apt-get -y install libmysqlclient21 \
 && rm mysql-apt-config_0.8.11-1_all.deb \
 && rm -rf /var/lib/apt/lists/*

# Create MySQL connector.
# References:
#  - https://dev.mysql.com/downloads/connector/odbc/
#  - https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-installation-binary-unix-tarball.html

RUN wget https://cdn.mysql.com//Downloads/Connector-ODBC/8.0/mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
 && tar -xvf mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
 && cp mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit/lib/* /usr/lib/x86_64-linux-gnu/odbc/ \
 && mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit/bin/myodbc-installer -d -a -n "MySQL" -t "DRIVER=/usr/lib/x86_64-linux-gnu/odbc/libmyodbc8w.so;" \
 && rm mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
 && rm -rf mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit

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

COPY ./notebooks /home/$NB_USER/

# Adjust permissions

RUN chown -R $NB_UID:$NB_GID /home/$NB_USER
RUN chmod -R ug+rw /home/$NB_USER

# Return to original user.
# Defined in https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

#############################################
## User environment setting
#############################################

USER $NB_UID

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian
