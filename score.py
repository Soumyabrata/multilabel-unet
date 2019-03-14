import numpy as np


def score_3levels(gt_mask, predict_mask):

    [rows, cols] = gt_mask.shape

    sky_occurences = (gt_mask == 0).sum()
    thin_occurences = (gt_mask == 126).sum()
    thick_occurences = (gt_mask == 255).sum()

    sky_error = 0
    thin_error = 0
    thick_error = 0

    for i in range(rows):
        for j in range(cols):
            if (gt_mask[i,j]==0 and predict_mask[i,j]!=0):
                sky_error = sky_error+1

            if (gt_mask[i, j] == 126 and predict_mask[i, j] != 126):
                thin_error = thin_error + 1

            if (gt_mask[i, j] == 255 and predict_mask[i, j] != 255):
                thick_error = thick_error + 1



    if sky_occurences==0:
        sky_value = np.nan
    else:
        sky_value = float(sky_error)/float(sky_occurences)

    if thin_occurences==0:
        thincloud_value = np.nan
    else:
        thincloud_value = float(thin_error) / float(thin_occurences)

    if thick_occurences==0:
        thickcloud_value = np.nan
    else:
        thickcloud_value = float(thick_error) / float(thick_occurences)


    return (sky_value, thincloud_value, thickcloud_value)