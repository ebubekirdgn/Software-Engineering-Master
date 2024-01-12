import numpy as np
import cv2
import matplotlib.pyplot as plt


# a = np.uint8([10,25,50,100,160,200,255,240])
# bit_duzlemi = np.full_like(a, 2**7)
# print(bit_duzlemi)
# print(bin(2**7))
# print(bin(160))
# print("-----------")
# print(bin(2**7))
# print(bin(100))
# # 128 --> 0b10000000
# # 100 --> 0b01100100
# a_duzlemi = np.bitwise_and(a, bit_duzlemi)
# print(a_duzlemi)

def bit_duzlemi_dilimleme(img, d_index):
    duzlem = np.full_like(img, 2**d_index)
    out = np.bitwise_and(img, duzlem)
    return out

def rescale(img):
    out = img.astype(np.float64)
    out -= np.min(out)
    out /= np.max(out)
    return (out*255).astype(np.uint8)


def duzlem_birlestir(img, duzlemler): # [7,6,5]
    out = np.zeros_like(img)
    for duzlem in duzlemler:
        out += bit_duzlemi_dilimleme(img, duzlem)

    return out


img_path = "./img/lenna.png"
img = cv2.imread(img_path, 0)


img_n_duzlemleri = []

for index in range(7,-1, -1):
    bit_img = bit_duzlemi_dilimleme(img, index)
    bit_img = rescale(bit_img)
    img_n_duzlemleri.append(bit_img)

hstacked1 = np.hstack((img, img_n_duzlemleri[0], img_n_duzlemleri[1]))
hstacked2 = np.hstack((img_n_duzlemleri[2], img_n_duzlemleri[3], img_n_duzlemleri[4]))
hstacked3 = np.hstack((img_n_duzlemleri[5], img_n_duzlemleri[6], img_n_duzlemleri[7]))
vstacked = np.vstack((hstacked1, hstacked2, hstacked3))

plt.imshow(vstacked, cmap="gray")
plt.show()

img_duzlem1 = duzlem_birlestir(img, [7])
img_duzlem2 = duzlem_birlestir(img, [7, 6])
img_duzlem3 = duzlem_birlestir(img, [7, 6, 5])
img_duzlem4 = duzlem_birlestir(img, [7, 6, 5, 4])
img_duzlem5 = duzlem_birlestir(img, [7, 6, 5, 4, 3])
img_duzlem6 = duzlem_birlestir(img, [7, 6, 5, 4, 3, 2])
img_duzlem7 = duzlem_birlestir(img, [7, 6, 5, 4, 3, 2, 1])
img_duzlem8 = duzlem_birlestir(img, [7, 6, 5, 4, 3, 2, 1, 0])

cv2.imwrite("./img/out/7.png", img_duzlem1)
cv2.imwrite("./img/out/7-6.png", img_duzlem2)
cv2.imwrite("./img/out/7-6-5.png", img_duzlem3)
cv2.imwrite("./img/out/7-6-5-4.png", img_duzlem4)
cv2.imwrite("./img/out/7-6-5-4-3.png", img_duzlem5)
cv2.imwrite("./img/out/7-6-5-4-3-2.png", img_duzlem6)
cv2.imwrite("./img/out/7-6-5-4-3-2-1.png", img_duzlem7)
cv2.imwrite("./img/out/7-6-5-4-3-2-1-0.png", img_duzlem8)

hstacked4 = np.hstack((img, img_duzlem1, img_duzlem2))
hstacked5 = np.hstack((img_duzlem3, img_duzlem4, img_duzlem5))
hstacked6 = np.hstack((img_duzlem6, img_duzlem7, img_duzlem8))
vstacked2 = np.vstack((hstacked4, hstacked5, hstacked6))

plt.imshow(vstacked2, cmap="gray")
plt.show()