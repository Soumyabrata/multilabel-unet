function [X_response,Y_response]=create_XY_response(image, GT_image)
% Feature vector generation for a single image

[rows,cols,~]=size(image);

% Ground truth
I_GT=GT_image;

[c1,~,~,~,c5,~,~,~,~,~,~,~,c13,~,~,~]=color16(image);

c1=showasImage(c1);     c1(c1==0)=1;
c5=showasImage(c5);     c5(c5==0)=1;
c13=showasImage(c13);   c13(c13==0)=1;

c1=c1./255;
c5=c5./255;
c13=c13./255;

c1_st=reshape(c1,rows*cols,1);
c5_st=reshape(c5,rows*cols,1);
c13_st=reshape(c13,rows*cols,1);

X_response=cat(2,c5_st,c13_st,c1_st);  

% Ground truth
I_GT(I_GT<126)=0;   I_GT(I_GT>126)=1;
I_GT_st=reshape(I_GT,rows*cols,1);

Y_response=I_GT_st;


