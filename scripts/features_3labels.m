function [st_feature_vec, st_labels]=features_3labels(input_image, GT_image,BETA)
% Probabilistic map feature for semantic labeling.
% Returns the vectorised feature vector and its corresponding labels.

    [rows,cols,~]=size(input_image);
    [color_ch]=color16_struct(input_image);
    
    channel1=color_ch.c5;
    channel2=color_ch.c13;
    channel3=color_ch.c1;
    
    channel1=showasImage(channel1); channel1(channel1==0)=1;
    channel2=showasImage(channel2); channel2(channel2==0)=1;
    channel3=showasImage(channel3); channel3(channel3==0)=1;    
    
    channel1_st=reshape(channel1,rows*cols,1);
    channel2_st=reshape(channel2,rows*cols,1);
    channel3_st=reshape(channel3,rows*cols,1);    
    
    channel1_st=channel1_st./255;
    channel2_st=channel2_st./255;
    channel3_st=channel3_st./255;

    X_data=cat(2,channel1_st,channel2_st,channel3_st);
    yfit = [ones(rows*cols,1) X_data]*BETA;
    res=reshape(yfit,rows,cols);
    prob_res=(showasImage(res))./255;
  
    St_one=reshape(prob_res,rows*cols,1);
    I_GT_gray=double(GT_image);
    I_labels=zeros(rows,cols);

    % The labels are as follows:
    % 1=sky   2=light cloud  3=cloud
    for i=1:rows
        for j=1:cols
            if  I_GT_gray(i,j) < 100
                I_labels(i,j)=1;      % Sky
            elseif  (99 < I_GT_gray(i,j))  && (I_GT_gray(i,j)<200)
                I_labels(i,j)=2;      % Light cloud
            elseif  I_GT_gray(i,j)>199
                I_labels(i,j)=3;      % Cloud          
            end
        end
    end

    st_labels=reshape(I_labels,rows*cols,1);
    st_feature_vec=St_one; 

end