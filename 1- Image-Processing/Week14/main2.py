import numpy as np
import cv2
import matplotlib.pyplot as plt


def create_box_kernel(m, n, deger):
    box_filter = np.full((m, n),deger)
    return box_filter / box_filter.sum()

def create_gaussian_kernel(m, n, K, sigma):
    divide_m = int(m / 2)
    divide_n = int(n / 2)
    #divide_m = m // 2
    
    gauss_filter = np.empty((m, n))

    for s in range(-divide_m, divide_m + 1):
        for t in range(-divide_n, divide_n + 1):
            r_kare= s**2 + t**2
            payda = 2*sigma**2
            kuvvet = -(r_kare/payda)
            deger=K* np.exp(kuvvet)

            python_s = divide_m + s
            python_t = divide_n + t
            #print(f"python_s: {python_s}, python_t: {python_t} , ##, s:{s}, t:{t}")
            gauss_filter[python_s, python_t] = deger
    return gauss_filter/gauss_filter.sum()

def apply_filter(img, kernel, islem):
    m, n = kernel.shape
    divide_m = int(m / 2)
    divide_n = int(n / 2)

    # np.pad(resim, ((ust, alt), (sol, sag)), constant_values=((ust_deger,alt_deger),(sol_deger,ssag_deger)))
    padded_img = np.pad(img, ((divide_m,divide_m),(divide_n,divide_n)), constant_values=((0,0),(0,0)))
    # print(padded_img)

    padded_img = padded_img.astype(float)
    M,N = padded_img.shape[:2]

    out_img = np.zeros_like(padded_img)

    for satir in range(divide_m, M-divide_m):
        for sutun in range(divide_n, N-divide_n):
            giris_pencere = padded_img[satir - divide_m : satir + divide_m + 1, sutun - divide_n:sutun + divide_n + 1]
            out_img[satir, sutun] = islem(giris_pencere, kernel)
    return out_img.astype(np.uint8)

def korelasyon(giris, kernel):
    yapilacak_islem = lambda giris_pencere, kernel: (giris_pencere * kernel).sum()
    return apply_filter(giris, kernel, yapilacak_islem)


def konvolusyon(giris, kernel):
    kernel = np.fliplr(kernel)
    kernel = np.flipud(kernel)
    return korelasyon(giris, kernel)


def medyan_filtre(giris, m, n):
    bos_filtre = np.empty((m, n))
    yapilacak_islem = lambda giris_pencere, kernel: np.median(giris_pencere)
    return apply_filter(giris, bos_filtre, yapilacak_islem)


img = cv2.imread("./images/salt_and_pepper.tif",0)
print(img.shape)
boyut = (500, 500)


sigmas=[1,3,5]
out_gauss_images = []

for sigma in sigmas:
    m = n = 6 * sigma + 1
    gauss_kernel = create_gaussian_kernel(m,n,1,sigma)
    out_img = konvolusyon(img, gauss_kernel)
    out_img = cv2.resize(out_img, boyut)
    out_gauss_images.append(out_img)


filter_sizes = [3,5,7]
out_median_images = []

for filter_size in filter_sizes:
    m = n = filter_size
    out_img = medyan_filtre(img, m, n)
    out_img = cv2.resize(out_img, boyut)
    out_median_images.append(out_img)

img = cv2.resize(img, boyut)
hstacked1 = np.hstack((img, out_gauss_images[0], out_gauss_images[1], out_gauss_images[2] ))
hstacked2 = np.hstack((img, out_median_images[0], out_median_images[1], out_median_images[2]))

vstcaked = np.vstack((hstacked1, hstacked2))
plt.imshow(vstcaked, cmap="gray")
plt.show()