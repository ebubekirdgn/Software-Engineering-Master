import cv2
import numpy as np
import matplotlib.pyplot as plt

def binary_slicing(img, A, B, alt, ust):
    img_out = np.full_like(img, alt)
    pk = np.logical_and(img >= A, img <= B)
    img_out[pk] = ust
    return img_out


def linear_slicing(img, A, B, ust):
    img_out = img.copy()
    pk = np.logical_and(img >= A, img <= B)
    img_out[pk] = ust
    return img_out

def linear_slicing_reverse(img, A, B, ust):
    img_out = img.copy()
    pk_kucuk = np.logical_and(img >= 0, img <= A)
    pk_buyuk = np.logical_and(img >= B, img <= 255)
    pk = np.logical_or(pk_kucuk, pk_buyuk)
    img_out[pk] = ust
    return img_out 


img_path = "./img/aortic_angiogram.tif"
img=cv2.imread(img_path, 0)

A = 150
B = 250
ust = 255
alt = 10

bs_img = binary_slicing(img, A, B, alt, ust)
ls_img = linear_slicing(img, A, B, ust)
lsr_img = linear_slicing_reverse(img, A, B, alt)

hstacked1 = np.hstack((img, bs_img))
hstacked2 = np.hstack((ls_img, lsr_img))

vstacked = np.vstack((hstacked1, hstacked2))



plt.imshow(vstacked, cmap="gray")
plt.show()



# a = np.array([1, 2, 3, 4, 5, 6, 7, 8])
# b = np.full_like(a, 10) 
# print(b)

# pk = (a > 5)
# print(pk)

# c = a[pk]
# print(c)

# a[pk] = 255
# print(a)

# pk =  (a > 5 and a < 3)
# pk = np.logical_and(a > 3, a < 6)
# print(pk)
# a[pk]=255
# print(a)

import random

x = np.uint8([random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255)]).reshape(3,3)


print(x)
s=binary_slicing(x,150,250,0,255)
print(s)