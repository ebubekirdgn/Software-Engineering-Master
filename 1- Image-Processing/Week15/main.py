import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import correlate2d


def rescale(img):
    out = img.astype(np.float64)
    out -= out.min()
    out /= out.max()
    return (out * 255).astype(np.uint8)


img = cv2.imread("./images/mirket.png", 0)

kernel1 = np.array([[0, -1,  0],
                    [-1,  4, -1],
                    [0, -1,  0]])

kernel2 = np.array([[-1, -1, -1],
                    [-1,  8, -1],
                    [-1, -1, -1]])

kernel1_filtered_img = correlate2d(img, kernel1, mode="same")
kernel2_filtered_img = correlate2d(img, kernel2, mode="same")

# kernel1_filtered_img = rescale(kernel1_filtered_img)
# kernel2_filtered_img = rescale(kernel2_filtered_img)

out_img_1 = img + 0.3 * kernel1_filtered_img
out_img_2 = img + 0.3 * kernel2_filtered_img

# plt.subplot(1, 3, 1)
# plt.imshow(img, cmap="gray")
# plt.title("orjinal")

# plt.subplot(1, 3, 2)
# plt.imshow(out_img_1, cmap="gray")
# plt.title("orta 4")

# plt.subplot(1, 3, 3)
# plt.imshow(out_img_2, cmap="gray")
# plt.title("orta 8")

# plt.show()

# print("k1 min değer: ", kernel1_filtered_img.min(), "k1 max değer: ", kernel1_filtered_img.max())
# print("k2 min değer: ", kernel2_filtered_img.min(), "k2 max değer: ", kernel2_filtered_img.max())

######################################################
# 2. YÖNTEM
######################################################

gauss_kernel = cv2.getGaussianKernel(ksize=19, sigma=3)
print(gauss_kernel.shape)
gauss_kernel = np.dot(gauss_kernel, gauss_kernel.T)
print(gauss_kernel.shape)


bulanik_img = correlate2d(img, gauss_kernel, mode="same")

# plt.subplot(1, 2, 1)
# plt.imshow(img, cmap="gray")
# plt.title("orjinal")

# plt.subplot(1, 2, 2)
# plt.imshow(bulanik_img, cmap="gray")
# plt.title("Bulanık")

# plt.show()

maske = img - bulanik_img

# plt.subplot(1, 3, 1)
# plt.imshow(img, cmap="gray")
# plt.title("orjinal")

# plt.subplot(1, 3, 2)
# plt.imshow(bulanik_img, cmap="gray")
# plt.title("Bulanık")

# plt.subplot(1, 3, 3)
# plt.imshow(maske, cmap="gray")
# plt.title("Maske")

# plt.show()

plt.subplot(2, 2, 1)
plt.imshow(img, cmap="gray")
plt.title("Orjinal")

for k in range(1, 4):
    out_image_y2 = img + k * maske

    plt.subplot(2, 2, k + 1)
    plt.imshow(out_image_y2, cmap="gray")
    plt.title(f"k = {k}")


plt.show()

######################################################
# 3. YÖNTEM
######################################################

sobel_x = np.array([[-1,  0,  1],
                    [-2,  0,  2],
                    [-1,  0,  1]])

sobel_y = np.array([[-1, -2,  -1],
                    [0,  0,   0],
                    [1,  2,   1]])

g_x = correlate2d(img, sobel_x, mode="same")
g_y = correlate2d(img, sobel_y, mode="same")

yontem1 = np.sqrt(g_x**2 + g_y**2)
yontem2 = np.absolute(g_x) + np.absolute(g_y)

yontem1_img = img + 0.3 * yontem1
yontem2_img = img + 0.3 * yontem2

plt.subplot(2, 3, 1)
plt.imshow(img, cmap="gray")
plt.title("Orjinal")

plt.subplot(2, 3, 2)
plt.imshow(yontem1, cmap="gray")
plt.title("Yontem 1")


plt.subplot(2, 3, 3)
plt.imshow(yontem2, cmap="gray")
plt.title("Yontem 2")


plt.subplot(2, 3, 4)
plt.imshow(img, cmap="gray")
plt.title("Orjinal")

plt.subplot(2, 3, 5)
plt.imshow(yontem1_img, cmap="gray")
plt.title("Out 1 ")

plt.subplot(2, 3, 6)
plt.imshow(yontem2_img, cmap="gray")
plt.title("Out 2")

plt.show()
