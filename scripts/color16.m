function [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16]=color16(input_image)

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
   
   c1=red;
   c2=green;
   c3=blue;
   c4=H_Image;
   c5=S_Image;
   c6=V_Image;
   c7=Y;
   c8=I;
   c9=Q;
   c10=L_Image;
   c11=A_Image;
   c12=B_Image;
   c13=rb1;
   c14=rb2;
   c15=BR;
   c16=Chroma;
    

    
    