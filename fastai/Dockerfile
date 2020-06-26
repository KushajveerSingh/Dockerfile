FROM nvidia/cuda:10.2-base-ubuntu18.04

LABEL author  = "Kushajveer Singh" \
      email   = "kushajreal@gmail.com" \
      website = "https://kushajveersingh.github.io/blog"

# Install necessary packages and setup ubuntu user
# username = default
# passwork = default
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends ca-certificates git sudo wget && \
    apt-get clean                                                                                            && \
    rm -rf /var/lib/apt/lists/*                                                                              && \
    useradd -rm -d /home/default -s /bin/bash -g root -G sudo -u 1001 default                                && \
    echo "default:default" | chpasswd                                                                        && \
    echo "Set disable_coredump false" >> /etc/sudo.conf

USER default
WORKDIR /home/default
EXPOSE 8889

COPY --chown=default:sudo update_fastai.sh test_container.ipynb /home/default/

# Miniconda (update python to 3.8.3)
# Use port=8889 by default for jupyter
# To run the container use this command
# docker run -it --gpus device=0 -p 8889:8889 --name container_name fastai:latest
ENV PATH="/home/default/miniconda3/bin:$PATH"
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
    bash Miniconda3-py37_4.8.3-Linux-x86_64.sh -b                            && \
    rm Miniconda3-py37_4.8.3-Linux-x86_64.sh                                 && \
    conda init                                                               && \
    conda install -y python=3.8.3                                            && \
    pip install notebook==6.0.3                                              && \
    echo "alias note='jupyter notebook --ip=0.0.0.0 --port=8889'" >> .bashrc && \
    conda install -y pytorch torchvision cudatoolkit=10.2 -c pytorch         && \
    git clone https://github.com/fastai/nbdev                                && \
    pip install -e nbdev                                                     && \
    git clone https://github.com/fastai/fastcore                             && \
    cd fastcore                                                              && \
    pip install -e ".[dev]"                                                  && \
    cd ..                                                                    && \
    git clone https://github.com/fastai/fastai2                              && \
    cd fastai2                                                               && \
    pip install -e ".[dev]"                                                  && \
    conda clean -afy
