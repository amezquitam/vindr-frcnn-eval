FROM eywalker/nvidia-cuda:8.0-cudnn5-devel-ubuntu16.04

# Instalar dependencias del sistema
RUN apt-get update -y 
RUN apt-get install -y \
    python-dev python-pip python-numpy \
    python-scipy python-opencv \
    libprotobuf-dev libleveldb-dev libsnappy-dev \
    libopencv-dev libhdf5-dev protobuf-compiler \
    libgflags-dev libgoogle-glog-dev liblmdb-dev \
    git cmake build-essential \
    && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/OpenMathLib/OpenBLAS.git
RUN cd OpenBLAS && \
    make

RUN cd OpenBLAS && make PREFIX=/usr/local install

RUN echo "/usr/local/OpenBLAS/lib" | tee /etc/ld.so.conf.d/openblas.conf
RUN ldconfig
# RUN cp -r /usr/local/OpenBLAS/include/* /usr/local/include

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
RUN echo "deb http://ppa.launchpad.net/marutter/rrutter/ubuntu xenial main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
    && apt-get update \
    && apt-get install -y libatlas-base-dev

RUN apt-get install libboost-all-dev -y && \
    rm -rf /var/lib/apt/lists/*
    
RUN git clone https://github.com/riblidezso/frcnn_cad.git
COPY py-faster-rcnn/ /root/py-faster-rcnn

# Compilación de Caffe
WORKDIR /root/py-faster-rcnn/caffe-fast-rcnn
RUN cp Makefile.config.example Makefile.config


RUN mkdir build && \
    cd build && \
    cmake ..

WORKDIR /root/py-faster-rcnn/caffe-fast-rcnn/build

RUN make -j30 all
RUN make install
RUN make -j30 pycaffe
# RUN make runtest

# Compilación de py-faster-rcnn
WORKDIR /root/py-faster-rcnn/lib
RUN make -j30

# ENV PYTHONPATH /root/py-faster-rcnn/caffe-fast-rcnn/python:$PYTHONPATH

WORKDIR /root/frcnn_cad

COPY ./fcrnn_cad/demo.py /root/frcnn_cad/demo.py

CMD ["python", "demo.py"]