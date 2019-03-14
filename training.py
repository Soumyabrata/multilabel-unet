import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from keras.models import Sequential, Model
from keras.layers import Dense, Conv2D, Input, MaxPool2D, UpSampling2D, Concatenate, Conv2DTranspose
import tensorflow as tf
from keras.optimizers import Adam
from scipy.misc import imresize
from sklearn.model_selection import train_test_split
import os
from keras.preprocessing.image import array_to_img, img_to_array, load_img, ImageDataGenerator
from subprocess import check_output

from utilities import *



# set the images and masks directories
data_dir = "./HYTA/images/"
mask_dir = "./HYTA/3GT/"
all_images = os.listdir(data_dir)

mask_images = []
for each_image in all_images:
    img_name_parts = each_image.split('.')
    mask_img_name = img_name_parts[0] + '_3GT.png'
    mask_images.append(mask_img_name)



train_images, validation_images = train_test_split(all_images, train_size=0.8, test_size=0.2)

train_gen = data_gen_small(data_dir, mask_dir, train_images, 5, [128, 128])
val_gen = data_gen_small(data_dir, mask_dir, validation_images, 100, [128, 128])


# Training time!
# probably need to play around a little bit with the learning rate to get it to start learning
model.compile(optimizer=Adam(1e-4), loss='binary_crossentropy', metrics=[dice_coef])
model.fit_generator(train_gen, steps_per_epoch=1000, epochs=20)

from keras.models import model_from_json
from keras.models import load_model

# serialize model to JSON
#  the keras model which is trained is defined as 'model' in this example
model_json = model.to_json()


with open("./results/model_num.json", "w") as json_file:
    json_file.write(model_json)

# serialize weights to HDF5
model.save_weights("./results/model_num.h5")