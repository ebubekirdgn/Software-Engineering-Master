import numpy as np
import cv2
import matplotlib.pyplot as plt


def local_enhancement(img, C, k0, k1, k2, k3, window_size):
    img = img.astype(np.float64)

    m_G = np.mean(img)
    m_G_alt_sinir = k0 * m_G
    m_G_ust_sinir = k1 * m_G

    ss_G = np.std(img)
    # vary_G = np.var(img)
    # ss_G = np.sqrt(vary_G)
    ss_G_alt_sinir = k2 * ss_G
    ss_G_ust_sinir = k3 * ss_G

    M, N = img.shape

    carpilacak_satirlar = []
    carpilacak_sutunlar = []

    for satir in range(M):
        ust_index = max(0, satir - int(window_size / 2))
        alt_index = min(M, satir + int(window_size / 2) + 1)
        for sutun in range(N):
            sol_index = max(0, sutun - int(window_size / 2))
            sag_index = min(N, sutun + int(window_size / 2) + 1)

            window_r = img[ust_index:alt_index, sol_index:sag_index]

            m_sxy = np.mean(window_r)
            ss_sxy = np.std(window_r)

            ortalama_kosulu = m_G_alt_sinir <= m_sxy <= m_G_ust_sinir
            ss_kosulu = ss_G_alt_sinir <= ss_sxy <= ss_G_ust_sinir

            if (ortalama_kosulu and ss_kosulu):
                carpilacak_satirlar.extend(list(range(ust_index, alt_index)))
                carpilacak_sutunlar.extend(list(range(sol_index, sag_index)))

    carpilacak_satirlar = np.uint32(carpilacak_satirlar)
    carpilacak_sutunlar = np.uint32(carpilacak_sutunlar)
    img[carpilacak_satirlar, carpilacak_sutunlar] *= C
    return img.astype(np.uint8)


img = cv2.imread("./images/1.tif", 0)

C = 25
k0 = 0
k1 = 0.1
k2 = 0
k3 = 0.1
window_size = 3

out_img = local_enhancement(img, C, k0, k1, k2, k3, window_size)

hstacked = np.hstack((img, out_img))
plt.imshow(hstacked, cmap="gray")
plt.show()
