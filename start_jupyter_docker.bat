@echo off
REM Start Jupyter Lab Docker container with project folder mounted
REM Change the image name below if you use a different Jupyter image
set IMAGE=jupyter/base-notebook
set HOST_DIR=D:\repos\tonylee\goorm\mlu
set CONTAINER_DIR=/workspace

docker run -it --rm -p 8888:8888 -v %HOST_DIR%:%CONTAINER_DIR% -w %CONTAINER_DIR% %IMAGE%
