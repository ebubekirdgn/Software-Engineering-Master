import cv2
import numpy as np

img_path = "./images/manzara.jpg"

img = cv2.imread(img_path)
print(img.shape)

print("Minimum : " ,np.min(img))
print("maximum : " ,np.max(img))
print("R değeri " ,img[0,0,2])  # 2 olan R değeri   satır x sutun x RGB degeri
print("G değeri " ,img[0,0,1])  # 1 olan G değeri
print("B değeri " ,img[0,0,0])  # 0 olan B degeri

baslangic_satiri = 400
bitis_satiri = 430

baslangic_sutunu =200
bitis_sutunu = 320

img_kesilen = img[baslangic_satiri:bitis_satiri,baslangic_sutunu:bitis_sutunu]

#cv2.imshow("kesilen resim",img_kesilen)
#cv2.waitKey(0)
#cv2.destroyAllWindows()

img_kesilen_R = img_kesilen[:,:,2]
img_kesilen_G = img_kesilen[:,:,1]
img_kesilen_B = img_kesilen[:,:,0]

#cv2.imshow("kesilen resim",img_kesilen_R)
#cv2.waitKey(0)
#cv2.destroyAllWindows()

img_grayscale = cv2.imread(img_path,0)

#cv2.imshow("Siyah Beyaz",img_grayscale)
#cv2.waitKey(0)
#cv2.destroyAllWindows()
print(img_grayscale.shape)
print(img_grayscale[0,0])