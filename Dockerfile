FROM eywalker/nvidia-cuda:8.0-cudnn5-devel-ubuntu16.04

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    python-dev python-pip python-numpy \
    python-scipy python-opencv \
    libprotobuf-dev libleveldb-dev libsnappy-dev \
    libopencv-dev libhdf5-dev protobuf-compiler \
    libgflags-dev libgoogle-glog-dev liblmdb-dev \
    git cmake build-essential \
    && rm -rf /var/lib/apt/lists/*

# Actualizar e instala python y pip legacy
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py "pip<21.0" && \
    rm get-pip.py

# verifica la instalación de pip
RUN pip --version

# Instalar dependencias de Python
RUN pip install --upgrade pip && pip install \
    easydict==1.6 \
    cython==0.25.2 \
    matplotlib==2.2.5 \
    numpy==1.16.6 \
    opencv-python==3.4.2.17

# Clonar los repositorios necesarios
WORKDIR /root
RUN git clone --recursive https://github.com/rbgirshick/py-faster-rcnn.git
RUN git clone https://github.com/riblidezso/frcnn_cad.git

# Compilación de Caffe
WORKDIR /root/py-faster-rcnn/caffe-fast-rcnn
RUN cp Makefile.config.example Makefile.config

RUN make -j$(nproc) && make pycaffe

# Compilación de py-faster-rcnn
WORKDIR /root/py-faster-rcnn
RUN make

ENV PYTHONPATH /root/py-faster-rcnn/caffe-fast-rcnn/python:$PYTHONPATH

WORKDIR /root/py-faster-rcnn/
CMD ["/bin/bash"]
