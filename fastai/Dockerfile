FROM ubuntu:20.04

LABEL author  = "Kushajveer Singh" \
      email   = "kushajreal@gmail.com" \
      website = "https://kushajveersingh.github.io/blog"

LABEL miniconda    = 4.8.3  \
      notebook     = 6.0.3  \
      python       = 3.8.3  \
      pip          = 20.1.1 \
      cuda         = 10.2   \
      pytorch      = 1.5.1  \
      torchvision  = 0.6.1  \
      nbdev        = master \
      fastcore     = master \
      fastai2      = master

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8                                   \
    PATH="/home/default/miniconda3/bin:$PATH"                     \
    CUDA_VERSION=10.2.89                                          \
    CUDA_PKG_VERSION=10-2=10.2.89-1                               \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}        \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64 \
    NVIDIA_VISIBLE_DEVICES=all                                    \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility                    \
    NVIDIA_REQUIRE_CUDA="cuda>=10.2 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    bzip2           \
    curl            \
    ca-certificates \
    git             \
    gnupg2          \
    sudo            \
    wget            \
    &&              \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -                           && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list                  && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl                                                                                                           && \
    apt-get update && apt-get install -y --no-install-recommends cuda-cudart-$CUDA_PKG_VERSION cuda-compat-10-2                                  && \
    ln -s cuda-10.2 /usr/local/cuda                                                                                                              && \
    apt-get clean                                                                                                                                && \
    rm -rf /var/lib/apt/lists/*                                                                                                                  && \
    echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf                                                                                && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf                                                                              && \
    useradd -rm -d /home/default -s /bin/bash -g root -G sudo -u 1001 default                                                                    && \
    echo "default:default" | chpasswd                                                                                                            && \
    echo "Set disable_coredump false" >> /etc/sudo.conf

# Nvidia Driver https://github.com/NVIDIA/nvidia-docker for more into
# Starting from docker 19.03, there is no need to install nvidia-driver on docker image. Docker can
# use the nvidia driver on the host machine.
# Steps to setup nvidia-docker in ubuntu are (for other distro follow the above link):
#   $ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#   $ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#   $ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#   $ sudo apt update && sudo apt install -y nvidia-container-toolkit
#   $ sudo systemctl restart docker
# `docker run --gpus all` -> use this flag to enable nvidia gpu in the container

# Code to make nvidia driver available in the environment has been taken from here
# https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.2/base/Dockerfile

# User details
# username :- default
# password :- default
# userid   :- 1001
USER default
WORKDIR /home/default
EXPOSE 8888

# Configure jupyter notebook
# `jupyter notebook --ip=0.0.0.0 --port=8888` is the command to run jupyter notebook, given you
# specified port 8888 in docker run command. Add a shortcut to this command in .bashrc

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
    bash Miniconda3-py37_4.8.3-Linux-x86_64.sh -b                                          && \
    rm Miniconda3-py37_4.8.3-Linux-x86_64.sh                                               && \
    eval "$(/home/default/miniconda3/bin/conda shell.bash hook)"                           && \
    conda init                                                                             && \
    echo ". /home/default/miniconda3/etc/profile.d/conda.sh" >> .bashrc                    && \
    echo "export PATH=\"/home/default/miniconda3/bin:\$PATH\"" >> .bashrc                  && \
    conda install -y python=3.8.3                                                          && \
    pip install notebook==6.0.3                                                            && \
    echo "alias note='jupyter notebook --ip=0.0.0.0 --port=8888'" >> .bashrc               && \
    conda install pytorch torchvision cudatoolkit=10.2 -c pytorch                          && \
    git clone https://github.com/fastai/nbdev                                              && \
    pip install -e nbdev                                                                   && \
    git clone https://github.com/fastai/fastcore                                           && \
    cd fastcore                                                                            && \
    pip install -e ".[dev]"                                                                && \
    git clone https://github.com/fastai/fastai2                                            && \
    cd fastai2                                                                             && \
    pip install -e ".[dev]"                                                                && \
    cd ..                                                                                  && \ 
    conda clean -afy                         

COPY --chown=default:sudo update_fastai.sh /home/default
COPY --chown=default:sudo list_versions.py /home/default