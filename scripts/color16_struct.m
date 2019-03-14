function [color_ch]=color16_struct(input_image)
% This function generates the 16 color channels in the form of a struct.
% Input: Input-image
% Output: 16 color channels


[rows,cols,~]=size(input_image);
input_image=double(input_image);

[red,green,blue] = RGBPlane(input_image);
St_Red=reshape(red,1,rows*cols);
St_Green=reshape(green,1,rows*cols);
St_Blue=reshape(blue,1,rows*cols);

HSV = rgb2hsv(input_image);
H_Image = HSV(:, :, 1);  % Extract the H image.
S_Image = HSV(:, :, 2);  % Extract the S image.
V_Image = HSV(:, :, 3);  % Extract the V image.
 
   
YIQ = rgb2ntsc(input_image);
Y=YIQ(:,:,1);
I=YIQ(:,:,2);
Q=YIQ(:,:,3);
   
    
%LAB Color model
colorTransform = makecform('srgb2lab');
lab = applycform(uint8(input_image), colorTransform);
labd = lab2double(lab);
L_Image = labd(:, :, 1);  % Extract the L image.
A_Image = labd(:, :, 2);  % Extract the A image.
B_Image = labd(:, :, 3);  % Extract the B image.
    
rb1=red./blue;
rb2=(red-blue);
BR=(blue-red)./(blue+red);

%Chroma array
Chroma2=zeros(1,rows*cols);
ch_draft1=cat(1,St_Red,St_Green,St_Blue);
for k=1:rows*cols
        Chroma2(1,k)=max(ch_draft1(:,k))-min(ch_draft1(:,k));
end
    
Chroma=reshape(Chroma2,rows,cols);


 field1 = 'c1';  value1 = red;
 field2 = 'c2';  value2 = green;
 field3 = 'c3';  value3 = blue;
 field4 = 'c4';  value4 = H_Image;
 field5 = 'c5';  value5 = S_Image;
 field6 = 'c6';  value6 = V_Image;
 field7 = 'c7';  value7 = Y;
 field8 = 'c8';  value8 = I;
 field9 = 'c9';  value9 = Q;
 field10 = 'c10';  value10 = L_Image;
 field11 = 'c11';  value11 = A_Image;
 field12 = 'c12';  value12 = B_Image;
 field13 = 'c13';  value13 = rb1;
 field14 = 'c14';  value14 = rb2;
 field15 = 'c15';  value15 = BR;
 field16 = 'c16';  value16 = Chroma;
   
 
 color_ch = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10,field11,value11,field12,value12,field13,value13,field14,value14,field15,value15,field16,value16);
 

    
    