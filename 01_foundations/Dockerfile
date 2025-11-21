FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-devel

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment for KoNLPy
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Install Python packages for D2L.ai
RUN pip install --no-cache-dir \
    d2l==1.0.3 \
    kiwipiepy \
    konlpy \
    sagemaker \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn

# Set working directory
WORKDIR /opt/ml/code

# Copy D2L.ai training scripts (would be added later)
# COPY train.py /opt/ml/code/
# COPY inference.py /opt/ml/code/

# Set environment variables for SageMaker
ENV SAGEMAKER_PROGRAM=train.py
ENV SAGEMAKER_REGION=ap-southeast-2

ENTRYPOINT ["python", "train.py"]
