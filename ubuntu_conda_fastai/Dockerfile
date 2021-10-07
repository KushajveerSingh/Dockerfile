FROM kushaj/pytorch:1.9.0

EXPOSE 8888
COPY --chown=default:sudo update_fastai.sh test_container.ipynb ./

RUN pip install notebook                                                     && \
    echo "alias note='jupyter notebook --ip=0.0.0.0 --port=8888'" >> .bashrc && \
    git clone --depth=1 https://github.com/fastai/fastcore                   && \
    cd fastcore                                                              && \
    pip install .                                                            && \
    cd ..                                                                    && \
    git clone --depth=1 https://github.com/fastai/nbdev                      && \
    cd nbdev                                                                 && \
    pip install .                                                            && \
    cd ..                                                                    && \
    git clone --depth=1 https://github.com/fastai/fastai                     && \
    cd fastai                                                                && \
    pip install .                                                            && \
    cd ..                                                                    && \
    rm -rf fastcore nbdev fastai                                             && \
    conda clean -afy                                                         && \
    rm -rf .cache
