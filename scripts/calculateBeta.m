function [BETA]=calculateBeta
% This function calculates the BETA value for computing the probabilistic
% mask.

% The value is computed from three random images of HYTA dataset.

    I1=imread('./HYTA/samples/B1.jpg');
    I1_GT=double(imread('./HYTA/samples/B1_GT.jpg'));
    [X1_response,Y1_response]=create_XY_response(I1, I1_GT);

    I2=imread('./HYTA/samples/B3.jpg');
    I2_GT=double(imread('./HYTA/samples/B3_GT.jpg'));
    [X2_response,Y2_response]=create_XY_response(I2, I2_GT);

    I3=imread('./HYTA/samples/B14.jpg');
    I3_GT=double(imread('./HYTA/samples/B14_GT.jpg'));
    [X3_response,Y3_response]=create_XY_response(I3, I3_GT);

    X_response=cat(1,X1_response,X2_response,X3_response);
    Y_response=cat(1,Y1_response,Y2_response,Y3_response);
    [~,~,~,~,BETA,~] = plsregress(X_response,Y_response,3);    

end