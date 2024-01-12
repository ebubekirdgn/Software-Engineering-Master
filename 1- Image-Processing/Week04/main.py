import cv2
import numpy as np
import matplotlib.pyplot as plt

img_path = "./img/fourier_spectrum.tif"
img = cv2.imread(img_path, 0)

def log_trans(img, c):
    img = img.astype(np.float64)
    s = c * np.log(1 + img)
    s = img_scale(s)
    return s

def img_scale(img):
    img -= np.min(img)
    img /= np.max(img)
    img *= 255
    return img.astype(np.uint8)


#uint8 den float64 dönüşümü
# deneme = np.array([1,25,126,250, 255, 254], dtype=np.uint8)
# deneme =deneme.astype(np.float64)
# deneme = 2 + deneme
# print(deneme)

# img_log = log_trans(img, c=1)

# print(np.min(img))
# print(np.max(img))
# print(np.min(img_log))
# print(np.max(img_log))

# belirli aralıktaki değerleri 0 ile 255 arasına scale ettik
# deneme = np.array([2.3, 2.5, 2.8, 3.5,3.7, 4.6, 5.9], dtype=np.float64)
# deneme = deneme - np.min(deneme)
# deneme = deneme / np.max(deneme)
# deneme = deneme * 255
# deneme = deneme.astype(np.uint8)
# print(deneme)
# print(np.min(deneme))
# print(np.max(deneme))

img_log = log_trans(img, c=1)

hstacked = np.hstack((img, img_log))

plt.imshow(hstacked, cmap="gray")
plt.show()





import random

x = np.uint8([random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255)]).reshape(3,3)


print(x)
s=log_trans(x,c=1)
print(s)