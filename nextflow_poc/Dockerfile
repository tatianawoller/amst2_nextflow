FROM ubuntu:24.04

# Set environment variables
ENV PATH="/opt/conda/envs/squirrel-env/bin:/opt/conda/bin:$PATH" \
    CONDA_DEFAULT_ENV="squirrel-env" \
    CONDA_PREFIX="/opt/conda/envs/squirrel-env"

# Install everything in a single layer to minimize image size
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget git curl && \
    # Download and install Miniforge3
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-x86_64.sh && \
    # Create conda environment and install packages
    /opt/conda/bin/conda create -n squirrel-env python=3.11 -y && \
    /opt/conda/bin/conda install -n squirrel-env -c conda-forge opencv vigra pandas numpy=1.26.4 -y && \
    # Install pip packages
    /opt/conda/envs/squirrel-env/bin/pip install --upgrade pip && \
    # Clone and install squirrel
    git clone https://github.com/jhennies/squirrel /squirrel && \
    cd /squirrel && \
    /opt/conda/envs/squirrel-env/bin/pip install -e . && \
    /opt/conda/envs/squirrel-env/bin/pip install transform3d SimpleITK-SimpleElastix pyaml && \
    # Clean up
    /opt/conda/bin/conda clean --all -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /squirrel/.git

CMD ["bash"]
