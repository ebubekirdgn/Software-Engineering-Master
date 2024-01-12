import numpy as np
import cv2
import matplotlib.pyplot as plt


def create_box_kernel(m, n, deger):
    box_filter = np.full((m, n), deger)
    return box_filter / box_filter.sum()


def create_gaussian_kernel(m, n, K, sigma):
    divide_m = int(m / 2)
    divide_n = int(n / 2)
    # divide_m = m // 2

    gauss_filter = np.empty((m, n))

    for s in range(-divide_m, divide_m + 1):
        for t in range(-divide_n, divide_n + 1):
            r_kare = s**2 + t**2
            payda = 2*sigma**2
            kuvvet = -(r_kare/payda)
            deger = K * np.exp(kuvvet)

            python_s = divide_m + s
            python_t = divide_n + t
            # print(f"python_s: {python_s}, python_t: {python_t} , ##, s:{s}, t:{t}")
            gauss_filter[python_s, python_t] = deger
    return gauss_filter/gauss_filter.sum()


def apply_filter(img, kernel, islem):
    m, n = kernel.shape
    divide_m = int(m / 2)
    divide_n = int(n / 2)

    # np.pad(resim, ((ust, alt), (sol, sag)), constant_values=((ust_deger,alt_deger),(sol_deger,ssag_deger)))
    padded_img = np.pad(img, ((divide_m, divide_m),
                        (divide_n, divide_n)), constant_values=((0, 0), (0, 0)))
    # print(padded_img)

    padded_img = padded_img.astype(float)
    M, N = padded_img.shape[:2]

    out_img = np.zeros_like(padded_img)

    for satir in range(divide_m, M-divide_m):
        for sutun in range(divide_n, N-divide_n):
            giris_pencere = padded_img[satir - divide_m: satir +
                                       divide_m + 1, sutun - divide_n:sutun + divide_n + 1]
            out_img[satir, sutun] = islem(giris_pencere, kernel)
    return out_img.astype(np.uint8)

def korelasyon(giris, kernel):
    def yapilacak_islem(giris_pencere, kernel): return (
        giris_pencere * kernel).sum()
    return apply_filter(giris, kernel, yapilacak_islem)


def konvolusyon(giris, kernel):
    kernel = np.fliplr(kernel)
    kernel = np.flipud(kernel)
    return korelasyon(giris, kernel)


def medyan_filtre(giris, m, n):
    bos_filtre = np.empty((m, n))
    def yapilacak_islem(giris_pencere, kernel): return np.median(giris_pencere)
    return apply_filter(giris, bos_filtre, yapilacak_islem)


img = cv2.imread("./images/space.tif", 0)
print(img.shape)

esik_deger = 100
esik_maske = img > esik_deger
# print(esik_maske)
# print(np.unique(esik_maske))

# plt.imshow(esik_maske, cmap="gray")
# plt.show()

sigma = 5
m = n = 6 * sigma + 1
K = 1
gauss_kernel = create_gaussian_kernel(m, n, K, sigma)
out_img = konvolusyon(img, gauss_kernel)
print(out_img.shape)

boyut = (500, 500)
img = cv2.resize(img, boyut)
out_img = cv2.resize(out_img, boyut)
# hstacked = np.hstack((img, out_img))
# plt.imshow(hstacked, cmap="gray")
# plt.show()

gauss_esik = out_img > esik_deger
plt.imshow(gauss_esik, cmap="gray")
plt.show()
