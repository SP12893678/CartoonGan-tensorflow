FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# set bash as current shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# install anaconda
RUN apt-get update
RUN apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
RUN sudo apt-get install curl
# RUN cd /tmp
RUN curl –O https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh ~/anaconda.sh && \
        /bin/bash ~/anaconda.sh -b -p /opt/conda && \
        rm ~/anaconda.sh && \
        ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
        echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
        find /opt/conda/ -follow -type f -name '*.a' -delete && \
        find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
        /opt/conda/bin/conda clean -afy

# set path to conda
ENV PATH /opt/conda/bin:$PATH

# setup conda virtual environment
COPY ./environment_linux_gpu.yml /tmp/environment_linux_gpu.yml
RUN conda update conda \
    && conda env create -n cartoongan -f /tmp/environment_linux_gpu.yml


RUN conda activate cartoongan
# RUN echo "conda activate camera-seg" >> ~/.bashrc
RUN echo "conda activate cartoongan" >> ~/.bashrc
ENV PATH /opt/conda/envs/cartoongan/bin:$PATH
ENV CONDA_DEFAULT_ENV $cartoongan

# RUN sha256sum Anaconda3-2021.11-Linux-x86_64.sh
# RUN bash Anaconda3-2021.11-Linux-x86_64.sh
