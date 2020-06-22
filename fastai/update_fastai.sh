current_dir=pwd
cd ~

cd nbdev
git pull origin master
pip install -e .
cd ..

cd fastcore
git pull origin master
pip install -e ".[dev]"
cd ..

cd fastai2
git pull origin master
pip install -e ".[dev]"
cd current_dir