# Лабораторная работа №2. Docker Compose

Лекции:
- [SSH](../../lectures/lecture_0/lecture_0.md)
- [Контейнеризация. Docker](../../lectures/lecture_1/lecture_1.md)
- [Мультиконтейнерные приложения. Docker Compose](../../lectures/lecture_2/lecture_2.md)

## Задание

Запустить предобученную нейронку с использованием `pytorch` внутри контейнера. Для создания контейнера использовать `Docker Compose`.

1. Собрать контейнер с установленным PyTorch (CPU или GPU версия).
   > Проще всего собрать контейнер на базе подготовленного образа с Docker Hub, например, 
    [pytorch:2.1.0-cuda11.8-cudnn8-devel](https://hub.docker.com/layers/pytorch/pytorch/2.1.0-cuda11.8-cudnn8-devel/images/sha256-558b78b9a624969d54af2f13bf03fbad27907dbb6f09973ef4415d6ea24c80d9?context=explore).
    Можно и из обычного образа, например, Убунты. Тогда нужно будет установить CUDA определенной версии 
  при сборке контейнера, а на самом хосте поставить [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).  
   > 
   > На сервере **NVIDIA Container Toolkit** *уже установлен*.  
   > Для запуска на сервере, естественно, лучше собрать образ с GPU версией.  
   > 
   > P.S.: PyTorch или TensorFlow, в целом, неважно.
2. Написать [скрипт обработки изображений с использованием нейросети](sub_task_pytorch.md). 
   Можно выбрать любую понравившуюся модель/задачу обработки изображения нейросетью.  
   > У [niconielsen32](https://github.com/niconielsen32) в репах есть целая подборка различных заготовок по 
     [Computer Vision](https://github.com/niconielsen32/ComputerVision), например, 
     [вычисление карты глубин по изображению](https://github.com/niconielsen32/ComputerVision/blob/master/MonocularDepth/midasDepthMap.py).
   > 
3. Запустить контейнер командой:
   ```bash
   docker compose -f <имя_конфига.yaml> up
   ```
4. Запустить скрипт с реализованным алгоритмом в контейнере в примонитрованной внутри контейнера папке. 
   Результат обработки сохранить в локальной директории контейнера.
5. Убедиться в появлении результата в директории хоста.

## Решение

1. Создание Dockerfile
  ![image](https://github.com/user-attachments/assets/0698f6fa-963b-40e7-a32f-4e077baa9213)
2. Создание docker-compose.yaml
   ![image](https://github.com/user-attachments/assets/1df1c17b-342f-478f-862e-2524353b6cf8)
3. Написание скрипта обработки изображения.
   Используется предобученная модель для вычисления карты глубины (на основе torchvision)
   ![image](https://github.com/user-attachments/assets/1f3bd6c5-ba6e-4e56-9b8b-70fd7bc5cffe)
4. Сборка контейнера:
   ```bash
   docker compose -f docker-compose.yaml build
   ```
5. Запуск контейнера:
   ```bash
   docker compose -f docker-compose.yaml up
   ```
   ![image](https://github.com/user-attachments/assets/4cc94c19-ba81-4d92-a1eb-2bc492a2e239)
6. Проверка появления результата
   ![image](https://github.com/user-attachments/assets/fc6ee397-a012-480d-843c-e00dfbc58087)

## Исходное изображение 
![input](https://github.com/user-attachments/assets/f65db23e-6c3a-4991-8dae-0b7dbb8d3676)

## Карта глубины изображения
![depth_map](https://github.com/user-attachments/assets/425dadd6-f227-4e26-aa0c-f3e70bdc674d)

