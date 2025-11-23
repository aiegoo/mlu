FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-devel

# Install system dependencies with Korean language support
USER root
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    vim \
    tree \
    htop \
    locales \
    language-pack-ko \
    fonts-nanum \
    fonts-nanum-coding \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# Configure Korean locale and UTF-8
RUN locale-gen ko_KR.UTF-8 en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_CTYPE=en_US.UTF-8

# Set up working directory
WORKDIR /workspace

# Copy environment file if it exists
COPY .env* /workspace/

# Set up CUDA environment variables
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV CUDA_VISIBLE_DEVICES=all
ENV TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6 8.9 9.0+PTX"

# Copy requirements and install Python packages
COPY requirements-docker.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements-docker.txt

# Install d2l library and dependencies with Korean support
RUN pip install --no-cache-dir \
    d2l==1.0.3 \
    jupyter-book \
    matplotlib \
    pandas \
    seaborn \
    scikit-learn \
    pillow \
    requests \
    tqdm \
    numpy \
    scipy \
    openai \
    huggingface-hub \
    transformers \
    datasets \
    accelerate \
    bitsandbytes \
    konlpy \
    soynlp \
    kiwipiepy

# Install JupyterLab extensions
RUN pip install --no-cache-dir \
    jupyterlab \
    jupyterlab-git \
    jupyterlab_widgets \
    ipywidgets

# Configure Jupyter
RUN jupyter lab --generate-config

# Create ai-track directory structure
RUN mkdir -p /workspace/ai-track/d2l-official \
    && mkdir -p /workspace/ai-track/projects \
    && mkdir -p /workspace/ai-track/datasets \
    && mkdir -p /workspace/ai-track/experiments \
    && mkdir -p /workspace/ai-track/models

# Clone the official d2l notebooks
RUN git clone https://github.com/d2l-ai/d2l-en.git /workspace/ai-track/d2l-official/d2l-en

# Set up user permissions
RUN useradd -m -s /bin/bash jupyter && \
    chown -R jupyter:jupyter /workspace
USER jupyter

# Configure Jupyter for password-free access
RUN mkdir -p ~/.jupyter && \
    echo "c.ServerApp.token = ''" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.password = ''" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.open_browser = False" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.port = 8888" >> ~/.jupyter/jupyter_lab_config.py

# Expose JupyterLab port
EXPOSE 8888

# Default command
CMD ["jupyter", "lab", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--NotebookApp.token=''", "--NotebookApp.password=''"]