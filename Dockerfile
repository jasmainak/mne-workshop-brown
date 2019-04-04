# Binder Docker config file.

# This is required
FROM andrewosh/binder-base
MAINTAINER Mainak Jas <mainakjas@gmail.com>

USER root

# get xvfb for mayavi headless mode
# https://stackoverflow.com/questions/55387506/how-to-fix-failed-to-fetch-debian-jessie-updates-issue-on-docker
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get install --fix-missing -y xvfb

# needed for mayavi to work
# https://github.com/conda-forge/pygridgen-feedstock/issues/10
RUN apt install libgl1-mesa-glx

ENV DISPLAY=:99

# Install dependencies and MNE master
RUN conda update conda;

RUN conda install --yes numpy scipy matplotlib mayavi

RUN conda install -c conda-forge rise;

RUN pip install mne pysurfer nibabel

RUN pip install https://api.github.com/repos/autoreject/autoreject/zipball/master

ENTRYPOINT ["tini", "-g", "--", "xvfb-run"]
