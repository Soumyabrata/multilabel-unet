from keras.models import model_from_json
from keras.models import load_model
from keras.preprocessing.image import array_to_img, img_to_array, load_img, ImageDataGenerator
import numpy as np
from scipy.misc import imresize
import matplotlib.pyplot as plt
import os
from scipy import misc

# load json and create model
json_file = open('./trained-model/model_num.json', 'r')

loaded_model_json = json_file.read()
json_file.close()
loaded_model = model_from_json(loaded_model_json)

# load weights into new model
loaded_model.load_weights("./trained-model/model_num.h5")
print("Loaded model from disk")

# set the images and masks directories
data_dir = "./HYTA/images/"
all_images = os.listdir(data_dir)

image_name = 'B1.jpg'
dims = [128, 128]
original_img = load_img(data_dir + image_name)
resized_img = imresize(original_img, dims+[3])
array_img = img_to_array(resized_img)/255
array_img = np.array(array_img)


predicted_mask = loaded_model.predict(array_img[np.newaxis, :, :, :])
predicted_mask = predicted_mask.reshape(128, 128)

threelevelmask = np.copy(predicted_mask)
threshold1 = 0.3
threshold2 = 0.6

[rows, cols] = threelevelmask.shape
newmask = np.zeros([rows, cols])
for i in range(rows):
    for j in range(cols):
        if threelevelmask[i,j]<threshold1:
            newmask[i,j] = 0
        if (threshold1<threelevelmask[i,j]) and (threelevelmask[i,j]<threshold2):
            newmask[i,j] = 126
        if (threelevelmask[i,j]>threshold2):
            newmask[i,j] = 255

newmask = np.dstack([newmask, newmask, newmask])
print (np.unique(newmask))

plt.figure(1)
plt.imshow(array_img)
plt.show()
loc_file = './results/visual-results/' + 'inp_' + image_name
misc.imsave(loc_file, array_img)


plt.figure(2)
plt.imshow(predicted_mask)
plt.show()

cmap = plt.cm.coolwarm
norm = plt.Normalize(vmin=predicted_mask.min(), vmax=predicted_mask.max())
new_image = cmap(norm(predicted_mask))
loc_file = './results/visual-results/' + 'prob_' + image_name[:-4] +'.png'
misc.imsave(loc_file, new_image)


plt.figure(3)
plt.imshow(np.uint8(newmask))
plt.show()
loc_file = './results/visual-results/' + 'th_' + image_name
misc.imsave(loc_file, np.uint8(newmask))