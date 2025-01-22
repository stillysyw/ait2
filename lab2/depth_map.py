import torch
import torchvision.transforms as T
from PIL import Image
import matplotlib.pyplot as plt
import os

# Загрузка предобученной модели
model = torch.hub.load('intel-isl/MiDaS', 'MiDaS', force_reload=True)
model.eval() # Переводит модель в режим оценки (evaluation mode), отключая ненужные вычисления, такие как вычисление градиентов.

# Загрузка преобразований для обработки изображений
# transform = torch.hub.load('intel-isl/MiDaS', 'transforms').default_transform

transform = T.Compose([
    T.Resize((384, 384)),  # Принудительное изменение размера до фиксированного значения
    T.ToTensor(),   # Преобразование в тензор
    T.Normalize(mean=(0.485, 0.456, 0.406), std=(0.229, 0.224, 0.225))  # Нормализация
])

# Путь к входному изображению
input_image_path = 'input.jpg'
output_image_path = '/output/depth_map.jpg'

# Загрузка изображения
image = Image.open(input_image_path).convert('RGB')
input_tensor = transform(image).unsqueeze(0) #Добавляет измерение для батча, так как модель ожидает вход в формате [batch_size, channels, height, width].

# Инференс
# torch.no_grad(): Отключает вычисление градиентов, так как они не нужны для инференса, экономя память и ускоряя выполнение.
# model(input_tensor): Генерирует предсказание карты глубины для входного изображения.
with torch.no_grad():
    depth_map = model(input_tensor)

# Преобразование карты глубины для визуализации
depth_map = depth_map.squeeze().cpu().numpy()
plt.imshow(depth_map, cmap='inferno')
plt.axis('off')
plt.savefig(output_image_path, bbox_inches='tight')
print(f"Результат сохранен в {output_image_path}")
