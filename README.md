# Dockerfile
Collection of all my Dockerfile's. The base Dockerfile builds Ubuntu, Miniconda, PyTorch with a default user and a root user. You can access the images on Dockerhub using this [link](https://hub.docker.com/u/kushaj).

Check out my blog post [Complete tutorial on building images using Docker](https://kushajveersingh.github.io/blog/docker) that covers everything you need to know to write Dockerfile and run containers using Docker. The base image [ubuntu_conda_pytorch](ubuntu_conda_pytorch/Dockerfile) is used as an example in the above post and it contains the details of every command used in the above Dockerfile.

## Table of Contents
- [ubuntu_conda_pytorch](#ubuntucondapytorch)
    - [Build from source Dockerfile](#build-from-source-dockerfile)
    - [Pull from Dockerhub](#pull-from-dockerhub)
    - [Running a container](#running-a-container)
    - [(Usage) Become root](#usage-become-root)
    - [(Usage) Nvidia GPU](#usage-nvidia-gpu)
    - [(Usage) PyTorch example](#usage-pytorch-example)
- [Customizing base image](#customizing-base-image)
    - [PyTorch CPU only install](#pytorch-cpu-only-install)
    - [fastai install](#fastai-install)
- [License]

## ubuntu_conda_pytorch
Features
- Builds on top of Ubuntu
- `sudo` and a `default` user
- `Miniconda` setup
- `PyTorch` and `torchvision` installed using conda
- Extra utilities include `git`, `curl`, `sudo`

### Build from source Dockerfile
To build the image you can use the following command
```
> cd ubuntu_conda_pytorch
> docker build -t pytorch:1.9.0 --build-args \
    UBUNTU_VERSION=18.04 \
    USERNAME=default \
    PASSWORD=default \
    MINICONDA_DOWNLOAD_LINK=... \
    MINICONDA_INSTALL_PATH=/home/$USERNAME \
    .
```
Grab the link of the [Linux installer](https://docs.conda.io/en/latest/miniconda.html#linux-installers) of your choice from the Miniconda document page and use that link as value of `MINICONDA_DOWNLOAD_LINK`. You can also specify where you want to download Miniconda using `MINICONDA_INSTALL_PATH`. By default, it is installed in the home directory of the user.

### Pull from Dockerhub
The image is hosted at [kushaj/pytorch](https://hub.docker.com/repository/docker/kushaj/pytorch). To pull the image use the following command
```
> docker pull kushaj/pytorch:1.9.0
```

### Running a container
Use the following command to create a container
```
> docker run -it --gpus all --name temp kushaj/pytorch:1.9.0
```
- `-it` will open a terminal connected to the container
- `--gpus all` is used to specify which GPUs to give access to the container
- `--name temp` name of the container

### (Usage) Become root
`sudo su` can be used to become root. The default credentials are
- username = `default`
- password = `default`

```
(base) default@a96e1cef1e4a:~$ sudo su
[sudo] password for default: 
root@a96e1cef1e4a:/home/default# 
```

### (Usage) Nvidia GPU
`nvidia-smi` can be used to check the status of GPUs. This requires the host machine has Nvidia drivers set up.
```
(base) default@a96e1cef1e4a:~$ nvidia-smi
Thu Oct  7 02:28:18 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.91.03    Driver Version: 460.91.03    CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro M1200        Off  | 00000000:01:00.0 Off |                  N/A |
| N/A   40C    P0    N/A /  N/A |    356MiB /  4043MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
(base) default@a96e1cef1e4a:~$ 
```

### (Usage) PyTorch example
```
(base) default@7d9b75595a27:~$ python
Python 3.9.7 (default, Sep 16 2021, 13:09:58) 
[GCC 7.5.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> torch.cuda.is_available()
True
>>> torch.backends.cudnn.version()
8005
>>> x = torch.tensor([1,2], device='cuda:0')
>>> x
tensor([1, 2], device='cuda:0')
```

## Customizing base image
You can customize [ubuntu_conda_pytorch/Dockerfile](ubuntu_conda_pytorch/Dockerfile) as per your needs

### PyTorch CPU only install
You can modify [line 41](https://github.com/KushajveerSingh/Dockerfile/blob/dd09c14fa8476b0dea834a97c978ef7a1361c84f/ubuntu_conda_pytorch/Dockerfile#L41) of the Dockerfile to install PyTorch. You can head to the PyTorch [install page](https://pytorch.org/get-started/locally/) to grab the command to install PyTorch. To install PyTorch for CPU you can change the original command to 
```
> conda install pytorch torchvision cpuonly -c pytorch
```

### fastai install
[ubuntu_conda_fastai/Dockerfile](ubuntu_conda_fastai/Dockerfile) contains the code to install fastai in the base repo. You can pull the image from [kushaj/fastai](https://hub.docker.com/repository/docker/kushaj/fastai).

To run a container use the following command connecting to port `8888` of the container
```
> docker run -it --gpus all -p 8888:8888 --name temp kushaj/fastai:latest
```

## License
[Apache License v2](LICENSE)