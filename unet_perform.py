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
from score import *



# set the images and masks directories
data_dir = "./HYTA/images/"
mask_dir = "./HYTA/3GT/"
all_images = os.listdir(data_dir)

mask_images = []
for each_image in all_images:
    img_name_parts = each_image.split('.')
    mask_img_name = img_name_parts[0] + '_3GT.png'
    mask_images.append(mask_img_name)



no_of_experiments = 10

sky_array = []
thin_array = []
thick_array = []

text_file = open("./results/unet-result.txt", "w")
text_file.write("sky_error, thincloud_error, thickcloud_error \n")

for exp in range(no_of_experiments):

    print (['performing exp no. ', (exp+1), '/', no_of_experiments])
    train_images, validation_images = train_test_split(all_images, train_size=0.8, test_size=0.2)

    train_gen = data_gen_small(data_dir, mask_dir, train_images, 5, [128, 128])
    val_gen = data_gen_small(data_dir, mask_dir, validation_images, 100, [128, 128])


    # Training time!
    # probably need to play around a little bit with the learning rate to get it to start learning
    model.compile(optimizer=Adam(1e-4), loss='binary_crossentropy', metrics=[dice_coef])
    model.fit_generator(train_gen, steps_per_epoch=1000, epochs=20)




    # evaluating the validation images
    for each_image in validation_images:

        print (['performing for ', each_image])
        dims = [128, 128]
        original_img = load_img(data_dir + each_image)
        resized_img = imresize(original_img, dims + [3])
        array_img = img_to_array(resized_img) / 255
        array_img = np.array(array_img)

        predicted_mask = model.predict(array_img[np.newaxis, :, :, :])
        predicted_mask = predicted_mask.reshape(128, 128)

        threelevelmask = np.copy(predicted_mask)
        threshold1 = 0.3
        threshold2 = 0.6

        [rows, cols] = threelevelmask.shape
        newmask = np.zeros([rows, cols])
        for i in range(rows):
            for j in range(cols):
                if threelevelmask[i, j] < threshold1:
                    newmask[i, j] = 0
                if (threshold1 < threelevelmask[i, j]) and (threelevelmask[i, j] < threshold2):
                    newmask[i, j] = 126
                if (threelevelmask[i, j] > threshold2):
                    newmask[i, j] = 255


        # load the ground-truth for comparison
        img_name_parts = each_image.split('.')
        original_mask = load_img(mask_dir + img_name_parts[0] + '_3GT.png')
        resized_mask = imresize(original_mask, dims)
        resized_mask = np.array(resized_mask)
        resized_mask = resized_mask[:,:,0]

        [rows, cols] = resized_mask.shape
        gtmask = np.zeros([rows, cols])

        for i in range(rows):
            for j in range(cols):
                if resized_mask[i, j] <= 63:
                    gtmask[i, j] = 0
                if (63 < resized_mask[i, j]) and (resized_mask[i, j] < 190):
                    gtmask[i, j] = 126
                if (resized_mask[i, j] >= 190):
                    gtmask[i, j] = 255


        (sky_value, thincloud_value, thickcloud_value) = score_3levels(gtmask, newmask)

        sky_array.append(sky_value)
        thin_array.append(thickcloud_value)
        thick_array.append(thickcloud_value)



# Across all experiments and across all validation images, together
# converting to array and getting means
sky_average = (np.nanmean(np.array(sky_array)))*100
thincloud_average = (np.nanmean(np.array(thin_array)))*100
thickcloud_average = (np.nanmean(np.array(thick_array)))*100

print (['the average error percentages are', sky_average, thincloud_average, thickcloud_average])

text_file.write("%s, %s, %s \n" % (sky_average, thincloud_average, thickcloud_average))
text_file.close()

