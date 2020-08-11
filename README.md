# fastai:latest 
> Base Dockerfile for fastaiv2 + ubuntu 18.04 + sudo + default user setup in a conda environment (compressed size = 2.17GB).

Dockerhub [link](https://hub.docker.com/repository/docker/kushaj/fastai/general), Dockerfile [link](https://github.com/KushajveerSingh/Dockerfile/tree/master/fastai)

## Summary of Dockerfile contents
1. Builds on **nvidia/cuda:10.2-base-ubuntu18.04**. Configuration of nvidia driver is done in the image. On the host machine follow the instructions of [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) to setup **nvidia-docker2** packages.

2. **sudo** + **default user** setup.\
    username = default\
    password = default\
    userid  = 1001
   
   `/home/default` directory is setup, in the same way as a regular ubuntu install.

3. **Miniconda** setup
   * python=3.8.5
   * jupyter notebook = 6.1.1
   * pytorch = latest release
   * torchvision = latest release
   * nbdev = master commit
   * fastcore = master commit
   * fastaiv2 = master commit

4. **jupyter notebook**. To use notebook in docker container the command is 
    ```
    jupyter notebook --ip=0.0.0.0 --port=8889
    ```
    Any port can be used. To avoid writing this long command, I have added an alias in `.bashrc` as follows:
    ```
    alias note='jupyter notebook --ip=0.0.0.0 --port=8889'
    ```
    This assumes you started your container with `-p {host_port}:8889`. I generally make these ports same (`-p 8889:8889`). Now jupyter notebook can be started by typing **note** in terminal.

5. **pytorch** install. When I build the docker image, the latest release is **1.5.1**. I will update the `fastai:latest` image on new releases of pytorch as they are released.

6. **fastai** packages. In home directory, there is **update_fastai.sh** script, which will update **nbdev**, **fastcore**, **fastaiv2** to the latest git commit.

7. **test_container.ipynb**. This notebook can be used to check
   * Pytorch is using GPU
   * fastai works
   * print versions of all main packages in the container

## Package versions
Code in **test_container.ipynb**.

```python
python:
    matplotlib: 3.3.0
    notebook: 6.1.1
    numpy: 1.19.1
    pandas: 1.1.0
    pillow: 7.2.0
    pip: 20.0.2
    python: 3.8.5
    scikit-learn: 0.23.2
    scipy: 1.5.2
    spacy: 2.3.2
pytorch:
    pytorch: 1.6.0
    torchvision: 0.7.0
fastai:
    fastai2:
	Hash = 7c56bcab0f1769349d05ea83d52f14c378b701dd
	Time = 2020-08-10 15:07:38 -0700
    fastcore:
	Hash = de3e7d0dae3fb861dc4a09abe4556f80f1ce7662
	Time = 2020-08-10 15:10:00 -0700
    nbdev:
	Hash = 5cab00462c6e9044c6665811dfac1ba027abcdcb
	Time = 2020-08-11 10:59:13 -0700
```

## PyTorch+GPU example
```python
In [1]: import torch                                                                                                                                                         

In [2]: torch.cuda.is_available()                                                                                                                                            
Out[2]: True

In [3]: !nvidia-smi                                                                                                                                                          
Fri Jun 26 11:20:22 2020       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.100      Driver Version: 440.100      CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Quadro M1200        Off  | 00000000:01:00.0  On |                  N/A |
| N/A   48C    P5    N/A /  N/A |    657MiB /  4043MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+

In [4]: a = torch.zeros(100,100, device=torch.device('cuda'))                                                                                                                

In [5]: a.shape, a.device                                                                                                                                                    
Out[5]: (torch.Size([100, 100]), device(type='cuda', index=0))

```

## fastai example
```python
In [1]: from fastai2.vision.all import *                                                                                                                                     

In [2]: path = untar_data(URLs.CAMVID_TINY) 
   ...: codes = np.loadtxt(path/'codes.txt', dtype=str) 
   ...: fnames = get_image_files(path/"images") 
   ...: def label_func(fn): return path/"labels"/f"{fn.stem}_P{fn.suffix}" 
   ...:  
   ...: dls = SegmentationDataLoaders.from_label_func( 
   ...:     path, bs=8, fnames=fnames, label_func=label_func, codes=codes 
   ...: )                                                                                                                                                                    
                                                                                                                                             
In [3]: dls.show_batch(max_n=2)                                                                                                                                              

In [4]: learn = unet_learner(dls, resnet18, pretrained=False) 
   ...: learn.fine_tune(1)                                                                                                                                                   
epoch     train_loss  valid_loss  time    
0         3.365898    3.249032    00:10                                                                                                              
epoch     train_loss  valid_loss  time    
0         2.496570    3.055262    00:04                                                                                                              

In [5]: !rm -r /home/default/.fastai/data/camvid_tiny 
```

## Docker commands
1. `docker run -it --gpus device=0 --name temp -p 8889:8889 fastai:latest`
   * `-it` - open a terminal connected to the container
   * `--gpus device=0` - which GPUs to use in container(`all` will use all GPUs)
   * `--name temp` - Name of the containre
   * `-p 8889:8889` - The format is `{host_port}:{container_post}`

2. To add another terminal to a container the commands are

    ```
    docker ps
    docker exec -it {id} bash
    ```

    Get the container id using `docker ps` and then use that id in second command as `docker exec -it 2a0dd52f02e8 bash`.

3. Login to docker `docker login --username {docker_hub_username}`.

4. To start a stopped terminal the commands are

    ```
    docker start {container_name}
    docker container attach {container_name}
    ```

## Add docker to nbdev_template
I think this process can be automated, but for now the steps are

1. Create `docker/Dockerfile` file and add these contents to it, depending on your preference.

    ```
    FROM kushaj/fastai:latest

    # (optionally) add some meta-information
    LABEL author  = "..." \
        email   = "..." \
        website = "..."

    WORKDIR /home/default

    # To install library with git
    RUN git clone {git_url}  && \
        pip install -e {lib_name}

    # To install using pip
    RUN pip install {lib_name}
    ```

2. Build docker image.

    ```
    docker build -f docker/Dockerfile -t {image_name}:{image_tag} docker/
    ```
    * `-f` - location of Dockerfile
    * `docker/` - location of context (same as Dockerfile in this case)

3. Push to Dockerhub

    ```
    docker tag {image_name}:{image_tag} {dockerhub_username}/{image_name}:{image_tag}
    docker push {dockerhub_username}/{image_name}:{image_tag}
    ```

## Help reduce image size
If the [Dockerfile](https://github.com/KushajveerSingh/Dockerfile/blob/master/fastai/Dockerfile) image size can be reduced, please tell.