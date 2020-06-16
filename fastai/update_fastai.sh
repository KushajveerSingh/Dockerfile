current_dir=pwd
cd ~

cd nbdev
git pull origin master
/home/default/miniconda3/envs/fastai/bin/pip install -e .

cd fastcore
git pull origin master
/home/default/miniconda3/envs/fastai/bin/pip install -e ".[dev]"
cd ..

cd fastai2
git pull origin master
/home/default/miniconda3/envs/fastai/bin/pip install -e ".[dev]"
cd current_dir