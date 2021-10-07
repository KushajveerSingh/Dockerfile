# Dockerfile
Collection of all my Dockerfile's. The base Dockerfile builds Ubuntu, Miniconda, PyTorch with a default user and a root user. You can access the images on Dockerhub using this [link](https://hub.docker.com/u/kushaj).

Check out my blog post [Complete tutorial on building images using Docker](https://kushajveersingh.github.io/blog/docker) that covers everything you need to know to write Dockerfile and run containers using Docker. The base image [ubuntu_conda_pytorch](ubuntu_conda_pytorch/Dockerfile) is used as an example in the above post and it contains the details of every command used in the above Dockerfile.

## ubuntu_conda_pytorch
Features
- Builds on top of Ubuntu
- `sudo` and a `default` user
- `Miniconda` setup
- `PyTorch` and `torchvision` installed using conda

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

## License
[Apache License v2](LICENSE)