ARG UBUNTU_VERSION=18.04
FROM ubuntu:$UBUNTU_VERSION

LABEL author  = "Kushajveer Singh" \
      email   = "kushajreal@gmail.com" \
      website = "https://kushajveersingh.github.io/blog" \
      source  = "https://github.com/KushajveerSingh/Dockerfile"

# 1. Update ubuntu and install utility packages (curl, sudo)
# 2. Setup sudo and create a new user with below credentials
# 3. "disable_coredump false" (visit this issue https://github.com/sudo-project/sudo/issues/42)
ARG USERNAME=default
ARG PASSWORD=default
RUN apt update --fix-missing && apt install -y --no-install-recommends ca-certificates git sudo curl && \
    apt clean                                                                                        && \
    rm -rf /var/lib/apt/lists/*                                                                      && \
    useradd -rm -d /home/default -s /bin/bash -g root -G sudo -u 1000 $USERNAME                      && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd                                                        && \
    echo "Set disable_coredump false" >> /etc/sudo.conf                                              && \
    touch /home/$USERNAME/.sudo_as_admin_successful

USER $USERNAME

# Head over to https://docs.conda.io/en/latest/miniconda.html#linux-installers to grab the link for Miniconda
ARG MINICONDA_DOWNLOAD_LINK=https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
ARG MINICONDA_INSTALL_PATH=/home/$USERNAME

WORKDIR $MINICONDA_INSTALL_PATH
ENV PATH  ${MINICONDA_INSTALL_PATH}/miniconda3/bin:$PATH

# 1. Install Miniconda and update packges to latest
# ("conda init" is optional as above ENV adds the required PATH)
# 2. Install PyTorch and any other required packages
# 3. Clear conda/pip cache
RUN curl $MINICONDA_DOWNLOAD_LINK --create-dirs -o Miniconda.sh                && \
    bash Miniconda.sh -b -p ./miniconda3                                       && \
    rm Miniconda.sh                                                            && \
    conda init                                                                 && \
    conda update -y --all                                                      && \
    pip install numpy                                                          && \
    conda install -y pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia && \
    conda clean -afy                                                           && \
    rm -rf .cache

WORKDIR /home/$USERNAME
