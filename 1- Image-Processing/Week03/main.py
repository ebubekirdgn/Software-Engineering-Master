import random
import cv2
import numpy as np
import matplotlib.pyplot as plt

img_path = "./images/mamogram.png"
img = cv2.imread(img_path, 0)

print(img.shape)

# print(img[10,20,1]) #r değeri # R=2, G=1, B=0
# print(img)

# s = L - 1 - r
# 1-256 --> 0-255
# s = negatifi alınmış piksel
# r = grayscale resimdeki her bir pikselin değeri
# L = resimdeki maksimum ışık yoğunluğu

L = np.max(img)

# print(L)

s = L - img

# cv2.imshow("negatif", s)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

hstacked = np.hstack((img, s))
vstacked = np.vstack((img, s))

plt.imshow(hstacked, cmap="gray")
plt.show()

x = np.uint8([random.randint(0, 255), random.randint(0, 255), random.randint(0, 255),
              random.randint(0, 255), random.randint(
                  0, 255), random.randint(0, 255),
              random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]).reshape(3, 3)
print(x)
s = L-x
print(s)
