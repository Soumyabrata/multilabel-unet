# Multi-label Cloud Segmentation Using a Deep Network

With the spirit of reproducible research, this repository contains all the codes required to produce the results in the manuscript: 
> S. Dev, S. Manandhar, Y. H. Lee and S. Winkler, Multi-label Cloud Segmentation Using a Deep Network, IEEE AP-S Symposium on Antennas and Propagation and USNC-URSI Radio Science Meeting, 2019.

Please cite the above paper if you intend to use whole/part of the code. This code is only for academic and research purposes.

## Code organization

The codes are written in `MATLAB` and `python`. 

## Usage 
1. Make sure that the input images and ternary ground-truth maps are stored inside the `HYTA` folder. More details about the dataset can be found [here](https://github.com/Soumyabrata/HYTA). The folder structure is as follows:
    * HYTA
        * 2GT: contains the binary ground-truth images
        * 3GT: contains the ternary ground-truth images
        * images: contains all input images
        * samples: contains sample images
2. `python2 training.py` Run this program to train the model on the dataset of sky/cloud images with ternary ground-truth maps. It saves the trained model in `./results/model_num.json` and `./results/model_num.h5`. For the purpose of reproducibility, our trained model is available from [this](https://drive.google.com/drive/folders/1-ajM2OUscNSzY28kBF1-jpIncXvrcsYV?usp=sharing) link. Please download and save the files `model_num.h5` and `model_num.json` inside `trained-model` folder for subsequent evaluations.
3. `python2 testing.py` Run this program to generate the testing results, after model is trained. For example, this script now generates the results for `B1.jpg` file.
4. `python2 unet_perform.py` Run this program to evaluate the performance of U-Net model over 10 experiments. It saves the results in a text file `./results/unet-result.txt`.
5. Open MATLAB environment, and run the script `devEtal.m`. It computes the performance of Dev et al. 2015 approach and saves the results in a text file `./results/devetalresult.txt`.
6. Open MATLAB environment, and run the script `visualize_icip.m`. It visualizes the result of sample image using Dev et al. 2015 approach. For example, here we check the result for `B1.jpg`.
