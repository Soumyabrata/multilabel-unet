% Multi - level semantic segmentation.



addpath('./scripts/')
[BETA]=calculateBeta;



% =======================================================
% Vectorizing all the images and its corresponding labels
% For training the multi-variate normal distribution.
% =======================================================

all_index = linspace(1,32,32);
my_folder = './HYTA/images';

file_list = dir(fullfile(my_folder, '*.jpg'));
training_images = 25;
testing_images = 7;


% Log file where individual image's performance are recorded

number_of_exps = 1;

sky_array=zeros(1,testing_images*number_of_exps);
thincloud_array=zeros(1,testing_images*number_of_exps);
thickcloud_array=zeros(1,testing_images*number_of_exps);

index_number = 0;




my_index = randperm(numel(file_list), training_images);
testing_index = setdiff(all_index, my_index)
location_dir='./HYTA/images/';

st_feature_vec=[];
rows=0; cols=0;
st_labels=[];


for kot=1:training_images

        

        FileNames=file_list(my_index(kot)).name;
        I1=imread(strcat(location_dir,FileNames));
        [rows1,cols1,~]=size(I1);

        GroundTruthName=FileNames;
        ind=length(GroundTruthName)-3:1:length(GroundTruthName);
        GroundTruthName(ind)=[];
        GroundTruthName=strcat(GroundTruthName,'_3GT.png');
        GroundTruth=double(imread(['./HYTA/3GT/',GroundTruthName]));
        GT_image1=double(GroundTruth);

        [st_feature_vec1, st_labels1]=features_3labels(I1,GT_image1,BETA);

        st_feature_vec=cat(1,st_feature_vec,st_feature_vec1);
        rows=rows+rows1;
        cols=cols+cols1;
        st_labels=cat(1,st_labels,st_labels1);

end

[phi_class1,mu0_class1,mu1_class1,sigma_class1]=likelihood_estimate(st_feature_vec,st_labels,1,2,3);
[phi_class2,mu0_class2,mu1_class2,sigma_class2]=likelihood_estimate(st_feature_vec,st_labels,2,1,3);
[phi_class3,mu0_class3,mu1_class3,sigma_class3]=likelihood_estimate(st_feature_vec,st_labels,3,1,2);

disp ('Parameters for multi-variate normal distribution learnt.');



% =============================================





index_number = index_number + 1;

FileNames='B1.jpg';    
I_test=imread(strcat(location_dir,FileNames));        
[rows_test,cols_test,~]=size(I_test);
[color_ch_test]=color16_struct(I_test);

channel0_test=color_ch_test.c1;
channel1_test=color_ch_test.c5;
channel2_test=color_ch_test.c13;
channel0_test=showasImage(channel0_test); channel0_test(channel0_test==0)=1;
channel1_test=showasImage(channel1_test); channel1_test(channel1_test==0)=1;
channel2_test=showasImage(channel2_test); channel2_test(channel2_test==0)=1;
St_zero_test=reshape(channel0_test,rows_test*cols_test,1);
St_one_test=reshape(channel1_test,rows_test*cols_test,1);
St_two_test=reshape(channel2_test,rows_test*cols_test,1);
St_zero_test=St_zero_test./255;
St_one_test=St_one_test./255;
St_two_test=St_two_test./255;

color_test=cat(2,St_one_test,St_two_test,St_zero_test);
data_vector_test = [ones(rows_test*cols_test,1) color_test]*BETA;
res_test=reshape(data_vector_test,rows_test,cols_test);
prob_res_test=(showasImage(res_test))./255 ;
st_prob_test=reshape(prob_res_test,rows_test*cols_test,1);    

 % This is the feature vector.
 feature_test=st_prob_test;
 label_test=zeros(rows_test*cols_test,1);

 for p=1:rows_test*cols_test

            % This is the log-likelihood estimate for each of the elements of the testing image.   
            likelihood_class1_positivesample= (feature_test(p,:)'-mu1_class1')'*(inv(sigma_class1))*((feature_test(p,:)'-mu1_class1'));
            likelihood_class2_positivesample= (feature_test(p,:)'-mu1_class2')'*(inv(sigma_class2))*((feature_test(p,:)'-mu1_class2'));
            likelihood_class3_positivesample= (feature_test(p,:)'-mu1_class3')'*(inv(sigma_class3))*((feature_test(p,:)'-mu1_class3'));
            like=[likelihood_class1_positivesample,likelihood_class2_positivesample,likelihood_class3_positivesample];
            [~,ind]=min(like);

            label_test(p,1)=ind;

 end

 % Display output
 label_test(label_test==1)=0;
 label_test(label_test==2)=126;
 label_test(label_test==3)=255;

 % Filtering with a 7X7 filter for better results
 A=reshape(label_test,rows_test,cols_test); B = medfilt2(A, [7 7]);
       
        


 GroundTruthName=FileNames;
 ind=length(GroundTruthName)-3:1:length(GroundTruthName);
 GroundTruthName(ind)=[];
 GroundTruthName=strcat(GroundTruthName,'_3GT.png');
 GroundTruth=double(imread(['./HYTA/3GT/',GroundTruthName]));
 GroundTruth=double(GroundTruth);

        
 % converting them to [128 128] for reporting
 GroundTruth = imresize(GroundTruth,[128 128]);
 GroundTruth(GroundTruth<=63)=0;
 GroundTruth(63<GroundTruth & GroundTruth<190)=126;
 GroundTruth(GroundTruth>=190)=255;
       
 B = imresize(B,[128 128]);
 B(B<=63)=0;
 B(63<B & B<190)=126;
 B(B>=190)=255;
       

 [sky, thin, thick] = error_score(B,GroundTruth)

 sky_array(1,index_number) = sky;
 thincloud_array(1,index_number) = thin;
 thickcloud_array(1,index_number) = thick;
        
 figure;
 imshow(uint8(B));


    
    
 




sky_percent = nanmean(100*sky_array) ;
thincloud_percent = nanmean(100*thincloud_array) ;
thickcloud_percent = nanmean(100*thickcloud_array) ;





