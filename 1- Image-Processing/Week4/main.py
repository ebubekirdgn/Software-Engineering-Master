import cv2 
import numpy as np 
import matplotlib.pyplot as plt

img_path="./images/x.png"

img = cv2.imread(img_path,0)

def log_trans(r,c):
    #resimi floata çeviriyoruz... 255'e  ekleyince devam eder. 0 olmaz
    r = r.astype(np.float64)
    s = c * np.log(1+r)
    s=image_scale(s)
    return s


def image_scale(image):
    image -=  np.min(image)
    image /=  np.max(image)
    image *=  255
    
    return image.astype(np.uint8)

# deneme = np.array([1,25,64,125,196,254,255], dtype = np.uint8)
# deneme = deneme.astype(np.float64)
# # deneme +=1
# # print(deneme)

# d = log_trans(deneme,c =1)
# print(d)

# d = d - np.min(d)
# print(d)

# d = d / np.max(d)
# print(d)

# d = d * 255 

# print(d)

# d  = d.astype(np.uint8)

# print(d)

log_image = log_trans(img,c=1)  
print(np.min(log_image))
print(np.max(log_image))  


yanyana  = np.hstack((img,log_image))
plt.imshow(yanyana,cmap="gray")
plt.show()
