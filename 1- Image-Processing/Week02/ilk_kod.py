import numpy as np
import random

x = np.uint8([random.randint(0, 255), random.randint(0, 255), random.randint(0, 255),
              random.randint(0, 255), random.randint(
                  0, 255), random.randint(0, 255),
              random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]).reshape(3, 3)

print(x)
