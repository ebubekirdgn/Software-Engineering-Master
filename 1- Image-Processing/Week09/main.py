import numpy as np
import cv2
import matplotlib.pyplot as plt


# x=[12, 25, 34, 50, 65]
# y=[10, 20, 20, 20, 40]

# plt.bar(x,y)
# plt.show()

# x_bins = [12 ,25 ,34, 50, 65]
# y_hist = [12, 13, 26, 27, 25, 26, 35, 52, 53, 54, 55, 56]

# plt.hist(y_hist, x_bins)
# plt.show()

img1 = cv2.imread("./images/01.tif", 0)
img2 = cv2.imread("./images/02.tif", 0)
img3 = cv2.imread("./images/03.tif", 0)

hist_eq_1 = cv2.equalizeHist(img1)
hist_eq_2 = cv2.equalizeHist(img2)
hist_eq_3 = cv2.equalizeHist(img3)

hstacked1 = np.hstack((img1, hist_eq_1))
hstacked2 = np.hstack((img2, hist_eq_2))
hstacked3 = np.hstack((img3, hist_eq_3))

vstacked = np.vstack((hstacked1,hstacked2, hstacked3))

plt.imshow(vstacked, cmap="gray")
plt.show()