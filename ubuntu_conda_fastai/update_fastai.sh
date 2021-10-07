current_dir=pwd
cd ~

git clone --depth=1 https://github.com/fastai/fastcore
cd fastcore
pip install .
cd ..

git clone --depth=1 https://github.com/fastai/nbdev
cd nbdev
pip install .
cd ..

git clone --depth=1 https://github.com/fastai/fastai
cd fastai2
pip install .
cd ..

rm -rf fastcore nbdev fastai2
conda clean -afy
rm -rf .cache/pip
cd current_dir