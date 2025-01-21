ARG ubuntu_ver=22.04
FROM ubuntu:$ubuntu_ver
WORKDIR /

# Update and upgrade
RUN apt update && apt -y upgrade

# Create dir
RUN mkdir /usr/local/Dev

# Install Python 3 and required dependencies
RUN apt install -y curl python3-testresources python3-dev wget gnupg2 software-properties-common
WORKDIR /usr/local/Dev/
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py

# OpenCV build dependencies
RUN apt -y install build-essential cmake unzip git pkg-config libgtk2.0-dev libavcodec-dev libavformat-dev \
                   libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libv4l-dev \
                   libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev gfortran python3-dev python3-pip \
                   python3-numpy

## OpenCV
ARG ocv_ver
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${ocv_ver}.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${ocv_ver}.zip
RUN unzip opencv.zip
RUN unzip opencv_contrib.zip

RUN apt -y install mlocate && updatedb

COPY build_env.sh /usr/local/Dev
RUN chmod +x /usr/local/Dev/build_env.sh
RUN cd /usr/local/Dev/ && ./build_env.sh

WORKDIR /usr/local/Dev/opencv-${ocv_ver}
RUN mkdir build
WORKDIR /usr/local/Dev/opencv-${ocv_ver}/build

# CMake configuration for OpenCV build
ARG build_thread_count
ARG cmake_command

# Очистка кеша перед запуском CMake
RUN rm -rf /usr/local/Dev/opencv-${ocv_ver}/build/*

# CMake конфигурация для сборки OpenCV
RUN pip3 install numpy
RUN . /usr/local/Dev/build_env.sh && cmake_command="-D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local/OpenCV-${ocv_ver} \
-D OPENCV_SKIP_PYTHON_LOADER=OFF \
-D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/OpenCV-${ocv_ver}/lib/python${py3_ver_mm}/site-packages \
-D OPENCV_PYTHON3_VERSION=${py3_ver_mmm} \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D BUILD_opencv_python_bindings_generator=ON \
-D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
-D PYTHON3_EXECUTABLE=$(which python3) \
-D PYTHON3_INCLUDE_DIR=${py3_inc_dir} \
-D PYTHON3_PACKAGES_PATH=${py3_lib_dir} \
-D PYTHON3_LIBRARY=${py3_lib_path} \
-D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
-D WITH_OPENCL=ON \
-D WITH_OPENMP=ON \
-D WITH_CUDA=OFF \
-D WITH_CUDNN=OFF \
-D WITH_NVCUVID=OFF \
-D WITH_CUBLAS=ON \
-D WITH_GSTREAMER=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D BUILD_opencv_cudacodec=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D INSTALL_C_EXAMPLES=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D OPENCV_EXTRA_MODULES_PATH=/usr/local/Dev/opencv_contrib-${ocv_ver}/modules \
-D BUILD_EXAMPLES=ON .." && echo ${cmake_command} && cmake ${cmake_command}



RUN make -j${build_thread_count}
RUN make install
RUN ldconfig

RUN . /usr/local/Dev/build_env.sh && ln -sf /usr/local/OpenCV-${ocv_ver}/lib/python${py3_ver_mm}/site-packages/cv2/python-${py3_ver_mm}/$(ls /usr/local/OpenCV-${ocv_ver}/lib/python${py3_ver_mm}/site-packages/cv2/python-${py3_ver_mm}/) /usr/local/lib/python${py3_ver_mm}/dist-packages/cv2.so

RUN echo $(python3 -c "import cv2 as cv; print(cv.__version__)")

CMD [ "bash" ]