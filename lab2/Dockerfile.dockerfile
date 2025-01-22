FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-devel

# Установка дополнительных зависимостей
# RUN echo "deb http://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
# # RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
# #     echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list \
#     apt-get update && apt-get install -y \
#     python3-pip \
#     libgl1 \
#     libglib2.0-0 \
#     DEBIAN_FRONTEND=noninteractive apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y \
#     git \
#     && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    git && \
    rm -rf /var/lib/apt/lists/*

# Установка дополнительных Python-библиотек
RUN pip install --no-cache-dir numpy matplotlib opencv-python timm


# Создание рабочего каталога
WORKDIR /app

# Копирование скриптов в контейнер
# COPY ./app /app
COPY app/ /app/app/


# CMD ["bash"]
# CMD ["python3", "/app/depth_map.py"]
CMD ["python3", "/app/depth_map.py"]
