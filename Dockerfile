# User can select the base image.
# For BASE_CONTAINER choices, see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM ${BASE_CONTAINER}

ENV REFRESHED_AT=2018-12-16

# "root" user is needed for apt-get installs.

USER root

# Install prerequisites.

RUN apt-get update
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

RUN pip2 install \
    bokeh \
    matplotlib \
    networkx \
    numpy \
    pandas \
    plotly \
    psutil \
    pyodbc \
    seaborn \
    sympy \
    version_information

RUN pip install \
    bokeh \
    matplotlib \
    networkx \
    numpy \
    pandas \
    plotly \
    psutil \
    pyodbc \
    seaborn \
    sympy \
    version_information

# Install libmysqlclient.

ENV DEBIAN_FRONTEND=noninteractive
RUN wget https://repo.mysql.com/mysql-apt-config_0.8.11-1_all.deb \
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

# Return to original user.
# Defined in https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

USER $NB_UID

# Install Python 2 kernel.

RUN python2 -m pip install ipykernel \
 && python2 -m ipykernel install --user

# Environment variables for user.

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian

# Copy files from repository.

RUN mkdir /home/$NB_USER/senzing-example-notebooks

COPY ./senzing-example-notebooks /home/$NB_USER/senzing-example-notebooks
