import cv2
import numpy as np

# Путь к исходному изображению
input_path = "/workspace/car.jpg"
# Путь для сохранения результатов
output_path = "/workspace/"

def process_image(gamma=1.0, brightness_factor=1.0, contrast_factor=1.0):
    # Загрузка изображения
    image = cv2.imread(input_path)
    
    # Применение гамма-коррекции
    image_gamma_corrected = np.power(image / 255.0, 1 / gamma) * 255.0
    
    # Преобразование в целочисленный формат и ограничение значений
    image_gamma_corrected = np.clip(image_gamma_corrected, 0, 255).astype(np.uint8)
    
    # Сохранение изображения после гамма-коррекции
    gamma_output_name = f"{output_path}car_gamma{gamma}.jpg"
    cv2.imwrite(gamma_output_name, image_gamma_corrected)
    print(f"Image after gamma saved as: {gamma_output_name}")
    
    # Преобразование в оттенки серого
    gray = cv2.cvtColor(image_gamma_corrected, cv2.COLOR_BGR2GRAY)
    
    # Сохранение изображения после гамма-коррекции в оттенках серого
    gray_output_name = f"{output_path}car_gamma{gamma}_gray.jpg"
    cv2.imwrite(gray_output_name, gray)
    print(f"Image after gamma and grayscale saved as: {gray_output_name}")
    
    # Применение контрастности
    img_array2 = contrast_factor * (image_gamma_corrected - 128) + 128
    
    # Ограничиваем значения в диапазоне [0, 255]
    img_after_contrast = np.clip(img_array2, 0, 255).astype(np.uint8)
    
    # Сохранение изображения после гамма-коррекции и контрастности
    contrast_output_name = f"{output_path}car_gamma{gamma}_contrast{contrast_factor}.jpg"
    cv2.imwrite(contrast_output_name, img_after_contrast)
    print(f"Image after gamma and contrast saved as: {contrast_output_name}")
    
    # Применение яркости
    img_array3 = img_array2 * brightness_factor
    
    # Ограничиваем значения в диапазоне [0, 255]
    img_after_brightness = np.clip(img_array3, 0, 255).astype(np.uint8)
    
    # Сохранение изображения после гамма-коррекции, контрастности и яркости
    brightness_output_name = f"{output_path}car_gamma{gamma}_contrast{contrast_factor}_brightness{brightness_factor}.jpg"
    cv2.imwrite(brightness_output_name, img_after_brightness)
    print(f"Image after gamma, contrast, and brightness saved as: {brightness_output_name}")

if __name__ == "__main__": 
    gamma = 2.2  # Значение гамма-коррекции
    brightness_factor = 1.5  # Коэффициент яркости
    contrast_factor = 1.2  # Коэффициент контрастности
    
    process_image(gamma, brightness_factor, contrast_factor)
