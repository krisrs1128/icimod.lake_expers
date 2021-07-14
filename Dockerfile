FROM nvidia/cuda:10.2-base-ubuntu18.04

# Add some dependencies
RUN apt-get clean && apt-get update -y -qq \
  && apt-get install --yes --no-install-recommends curl git build-essential vim ffmpeg libsm6 libxext6

# create user
RUN useradd --shell /bin/bash --create-home --home-dir /home/ksankaran ksankaran
USER ksankaran
WORKDIR /home/ksankaran

# Setup for conda installation
ENV PATH=${PATH}:/home/ksankaran/miniconda3/bin/
COPY binder/environment.yml .

# Install conda and python packages
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh \
  && bash Miniconda3-py39_4.9.2-Linux-x86_64.sh -b \
  && conda env create -f environment.yml \
  && /bin/bash -c "source activate lakes"

# To run this, use
# docker run --user $(id -u):$(id -g) --rm=true -it   -v $(pwd):/scratch -w /scratch   48e14184b016 /bin/bash
