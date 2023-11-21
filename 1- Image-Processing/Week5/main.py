import cv2
import numpy as np
import matplotlib.pyplot as plt


# s = c * r ^ y
def kuvvet_donusumu(r,c,gamma):
    r = r.astype(np.float64)
    s = c * r ** gamma
    s =rescale(s)
    return s

def rescale(img):
    img -= np.min(img)
    img /= np.max(img)
    img *= 255
    return img
    
mr_img = cv2.imread("./images/mri-brain-tumor.jpg",0) # -> Siyah beyaz yaptık resmi

mr_gammas = [0.6,0.4,0.3]  # örnek gamma degerleri
mr_images = []

for mr_gamma in mr_gammas:
    donusen = kuvvet_donusumu(mr_img,1,mr_gamma)
    mr_images.append(donusen)
    
    
    
mr_hstacked_ust = np.hstack((mr_img,mr_images[0]))
mr_hstacked_alt = np.hstack((mr_images[1],mr_images[2]))

mr_vstacked =np.vstack((mr_hstacked_ust,mr_hstacked_alt))

plt.imshow(mr_vstacked,cmap="gray")
plt.show()

############### Sehir Resmi ####################
sehir_img = cv2.imread("./images/sehir.png",0) # -> Siyah beyaz yaptık resmi

sehir_gammas = [3.0,4.0,5.0]

sehir_images = []

for sehir_gamma in sehir_gammas:
    donusen = kuvvet_donusumu(sehir_img,1,sehir_gamma)
    sehir_images.append(donusen)
    
    
    
sehir_hstacked_ust = np.hstack((sehir_img,sehir_images[0]))
sehir_hstacked_alt = np.hstack((sehir_images[1],sehir_images[2]))

sehir_vstacked =np.vstack((sehir_hstacked_ust,sehir_hstacked_alt))

plt.imshow(sehir_vstacked,cmap="gray")
plt.show()