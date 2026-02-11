FROM ubuntu:24.04

ENV PATH="/opt/conda/envs/squirrel-env/bin:/opt/conda/bin:$PATH" \
    CONDA_DEFAULT_ENV="squirrel-env" \
    CONDA_PREFIX="/opt/conda/envs/squirrel-env"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget git curl && \
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-x86_64.sh && \
    /opt/conda/bin/conda create --name squirrel-env -c bioconda -c conda-forge --override-channels python=3.11 nibabel opencv zarr=2 vigra pandas -y && \
    /opt/conda/envs/squirrel-env/bin/pip install --upgrade pip && \
    /opt/conda/envs/squirrel-env/bin/pip install SimpleITK-SimpleElastix transforms3d ruamel.yaml && \
    /opt/conda/envs/squirrel-env/bin/pip install https://github.com/jhennies/squirrel/archive/refs/tags/0.3.15.tar.gz 

CMD ["bash"]
