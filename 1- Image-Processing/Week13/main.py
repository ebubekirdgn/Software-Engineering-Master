import numpy as np
import cv2
import matplotlib.pyplot as plt

def kutu_kernel_olustur(m, n, deger):
    kutu_kernel = np.full((m, n), deger)
    return kutu_kernel / kutu_kernel.sum()


def gauss_kernel_olustur(m, n, K, sigma):
    bol_m = int(m / 2)
    bol_n = int(n / 2)
    # bol_m = m // 2

    gauss_kernel = np.empty((m, n))

    for s in range(-bol_m, bol_m + 1):
        for t in range(-bol_n, bol_n + 1):
            r_kare = s**2 + t**2
            payda = 2*sigma**2
            e_kuvvet = -(r_kare/payda)
            deger = K * np.exp(e_kuvvet)

            python_s = bol_m + s
            python_t = bol_n + t
            # print(f"python_s: {python_s}, python_t: {python_t}, s: {s}, t: {t}")

            gauss_kernel[python_s, python_t] = deger
    return gauss_kernel / gauss_kernel.sum()


def filtreyi_uygula(img, kernel, islem):
    kernel_m, kernel_n = kernel.shape
    bol_m = kernel_m // 2
    bol_n = kernel_n // 2

    # np.pad(resim, ((ust, alt), (sol, sag)), constant_values((ust_deger, alt_deger),(sol_deger, sag_deger)))
    padded_img = np.pad(img, ((bol_m, bol_m), (bol_n, bol_n)), constant_values=((0,0),(0,0)))
    # print(padded_img)
    padded_img = padded_img.astype(float)
    M, N = padded_img.shape
    out_img = np.zeros_like(padded_img)

    for satir in range(bol_m, M - bol_m):
        for sutun in range(bol_n, N - bol_n):
            giris_pencere = padded_img[satir-bol_m : satir + bol_m +1, sutun - bol_n : sutun + bol_n +1]
            out_img[satir, sutun] = islem(giris_pencere, kernel)
    return out_img.astype(np.uint8)

def korelasyon(giris, kernel):
    yapilacak_islem = lambda giris_pencere, kernel: (giris_pencere * kernel).sum()
    return filtreyi_uygula(giris, kernel, yapilacak_islem)

def konvolusyon(giris, kernel):
    kernel = np.fliplr(kernel)
    kernel = np.flipud(kernel)
    return korelasyon(giris, kernel)

def medyan_filtre (giris, m, n):
    bos_filtre = np.empty((m,n))
    yapilacak_islem = lambda giris_pencere, kernel: np.median(giris_pencere)
    return filtreyi_uygula(giris, bos_filtre, yapilacak_islem)


# print(kutu_kernel_olustur(3, 3, 1))

# print(gauss_kernel_olustur(3,3,3,3))

# img = np.arange(9).reshape(3, 3)
# print(img)
# apply_filter(img, img, 3)

img = cv2.imread("./images/lenna.png", 0)

kutu_kernel_boyutlari = [15, 25, 35]
kutu_kernel_korelasyon_resimleri = []
kutu_kernel_konvolusyon_resimleri = []
for boyut in kutu_kernel_boyutlari:
    kutu_kernel = kutu_kernel_olustur(boyut, boyut, 1)
    kutu_kernel_korelasyon_resimleri.append(korelasyon(img, kutu_kernel))
    kutu_kernel_konvolusyon_resimleri.append(konvolusyon(img,kutu_kernel))


gauss_kernel_sigmalari = [3,6,9]
gauss_kernel_korelasyon_resimleri = []
gauss_kernel_konvolusyon_resimleri = []

for sigma in gauss_kernel_sigmalari:
    m = 6 * sigma + 1
    gauss_kernel = gauss_kernel_olustur(m,m,K=1, sigma=sigma)
    gauss_kernel_korelasyon_resimleri.append(korelasyon(img, gauss_kernel))
    gauss_kernel_konvolusyon_resimleri.append(konvolusyon(img, gauss_kernel))

boyut = (450, 450)

hstacked1 = np.hstack((cv2.resize(img, boyut), 
cv2.resize(kutu_kernel_korelasyon_resimleri[0], boyut), 
cv2.resize(kutu_kernel_korelasyon_resimleri[1], boyut), 
cv2.resize(kutu_kernel_korelasyon_resimleri[2], boyut)))

hstacked2 = np.hstack((cv2.resize(img, boyut), 
cv2.resize(kutu_kernel_konvolusyon_resimleri[0], boyut), 
cv2.resize(kutu_kernel_konvolusyon_resimleri[1], boyut), 
cv2.resize(kutu_kernel_konvolusyon_resimleri[2], boyut)))

hstacked3 = np.hstack((cv2.resize(img, boyut), 
cv2.resize(gauss_kernel_korelasyon_resimleri[0], boyut), 
cv2.resize(gauss_kernel_korelasyon_resimleri[1], boyut), 
cv2.resize(gauss_kernel_korelasyon_resimleri[2], boyut)))

hstacked4 = np.hstack((cv2.resize(img, boyut), 
cv2.resize(gauss_kernel_konvolusyon_resimleri[0], boyut), 
cv2.resize(gauss_kernel_konvolusyon_resimleri[1], boyut), 
cv2.resize(gauss_kernel_konvolusyon_resimleri[2], boyut)))

vstacked = np.vstack((hstacked1,hstacked2,hstacked3,hstacked4))

plt.imshow(vstacked, cmap="gray")
plt.show()
 


