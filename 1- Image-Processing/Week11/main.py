import numpy as np
import cv2
import matplotlib.pyplot as plt

def kutu_kernel_olustur(m, n, deger):
    kutu_kernel = np.full((m, n), deger)
    return kutu_kernel / kutu_kernel.sum()

def gauss_kernel_olustur(m, n, K, sigma):
    bol_m = int(m / 2)
    # bol_m = m // 2
    bol_n = int(n / 2)

    gauss_kernel = np.empty((m, n))

    for s in range(-bol_m, bol_m + 1):
        for t in range(-bol_n, bol_n + 1):
            r_kare = s**2 + t**2
            payda = 2 * sigma**2
            e_ussu = -(r_kare / payda)
            deger = K * np.exp(e_ussu)

            python_s = s + bol_m
            python_t = t + bol_n

            gauss_kernel[python_s, python_t] = deger

    return gauss_kernel / gauss_kernel.sum()
