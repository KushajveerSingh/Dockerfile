import notebook
import jupyter_contrib_nbextensions
from platform import python_version
import torch
import torchvision
import nbdev
import fastcore
import fastai2

package_versions = {
    'fastai2': fastai2.__version__,
    'fastcore': fastcore.__version__,
    'nbdev': nbdev.__version__,
    'nbextensions': jupyter_contrib_nbextensions.__version__,
    'notebook': notebook.__version__,
    'python': python_version(),
    'pytorch': torch.__version__,
    'torchvision': torchvision.__version__,
    }

for k,v in package_versions.items():
    print(f'{k} = {v}')