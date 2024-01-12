import cv2
import numpy as np

img_path = "./images/manzara.jpg"

img = cv2.imread(img_path)

print(img.shape)
# print(img)

print("Minimum:", np.min(img))
print("Maximum:" , np.max(img))

print("Blue Kanalı:", img[0, 0, 0]) # Blue Kalanı için 0, 
print("Green Kanalı:", img[0, 0, 1]) # Green kanalı için 1
print("Red Kanalı:", img[0, 0, 2]) # Red kanalı için 2

bas_satir = 215
bit_satir = 300
bas_sutun = 230
bit_sutun = 350


img_kes = img[bas_satir:bit_satir,bas_sutun:bit_sutun]

# cv2.imshow("kesilen resim", img_kes)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

img_kes_R = img_kes[:,:,2]
img_kes_G = img_kes[:,:,1]
img_kes_B = img_kes[:,:,0]


cv2.imshow("kesilen resim R kanalı", img_kes_B)
cv2.waitKey(0)
cv2.destroyAllWindows()


img_grayscale = cv2.imread(img_path, 0)
print(img_grayscale.shape)
print(img_grayscale[0,0])



