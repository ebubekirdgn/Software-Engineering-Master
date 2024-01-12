print("Merhaba Dünya!")

import random
import numpy as np

x = np.uint8([random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255), 
              random.randint(0,255), random.randint(0,255), random.randint(0,255)]).reshape(3,3)

print(x)