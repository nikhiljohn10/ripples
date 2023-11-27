FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

LABEL maintainer="Nikhil John <nikhiljohn1010@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

ARG COND_LINK=https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh

RUN apt update --fix-missing && apt-get install -y \
    libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 \
    libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 \
    libglib2.0-0 libxext6 libsm6 libxrender1 git build-essential \
    wget bzip2 ca-certificates curl grep sed dpkg

RUN wget --quiet $COND_LINK -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN conda create -n datascience python=3.9 tensorflow-gpu anaconda -c anaconda -c conda-forge && \
    echo "conda activate datascience" >> ~/.bashrc

RUN TINI_VERSION=`curl -w "%{url_effective}\n" -LIs -o /dev/null https://github.com/krallin/tini/releases/latest | awk -F/v '{print $2}'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && rm tini.deb && apt clean

EXPOSE 8888
USER 1000

CMD [ "jupyter-notebook" ]