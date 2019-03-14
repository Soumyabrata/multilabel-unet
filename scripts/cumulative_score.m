function [true_positive,false_positive,true_negative,false_negative]= cumulative_score(ThreshImage,GroundTruth,TP,FP,TN,FN)
% This function provides TP, FP, TN, FN values for cumulative scoring

    true_positive=TP;
    false_positive=FP;
    true_negative=TN;
    false_negative=FN;

    [r1,c1]=size(ThreshImage);
    GroundTruth1=GroundTruth;    
    [r,c]=size(GroundTruth1);
    
    if (r1==r)&& (c1==c)
        disp ('Dimension of the two images are equal.');
    else
        disp ('Dimension of the two images are not in order.');
    end

    TP_c1=0;   TP_c2=0;   TP_c3=0;  
    FP_c1=0;   FP_c2=0;   FP_c3=0;
    TN_c1=0;   TN_c2=0;   TN_c3=0;
    FN_c1=0;   FN_c2=0;   FN_c3=0;

    for i=1:r1
        for j=1:c1
            
            % For 3 cluster cases
            % TP condition
            if (GroundTruth(i,j)==0 && ThreshImage(i,j)==0)  
                TP_c1=TP_c1+1;
                true_positive(1,1)=true_positive(1,1)+1;
            
            elseif (GroundTruth(i,j)==126 && ThreshImage(i,j)==126)  
                TP_c2=TP_c2+1;
                true_positive(1,2)=true_positive(1,2)+1;
            
            elseif (GroundTruth(i,j)==255 && ThreshImage(i,j)==255)  
                TP_c3=TP_c3+1;
                true_positive(1,3)=true_positive(1,3)+1;
            end
                
                
            % FP condition
            if (GroundTruth(i,j)~=0 && ThreshImage(i,j)==0)
                FP_c1=FP_c1+1;
                false_positive(1,1)=false_positive(1,1)+1;
            
            elseif (GroundTruth(i,j)~=126 && ThreshImage(i,j)==126)
                FP_c2=FP_c2+1;
                false_positive(1,2)=false_positive(1,2)+1;
           
            elseif (GroundTruth(i,j)~=255 && ThreshImage(i,j)==255)
                FP_c3=FP_c3+1;
                false_positive(1,3)=false_positive(1,3)+1;
            end
                
                
            % TN condition
            if  (GroundTruth(i,j)~=0)&& (ThreshImage(i,j)~=0) % TN condition
                TN_c1=TN_c1+1;
                true_negative(1,1)=true_negative(1,1)+1;
            
            elseif  (GroundTruth(i,j)~=126)&& (ThreshImage(i,j)~=126) % TN condition
                TN_c2=TN_c2+1;  
                true_negative(1,2)=true_negative(1,2)+1;
            
            elseif  (GroundTruth(i,j)~=255)&& (ThreshImage(i,j)~=255) % TN condition
                TN_c3=TN_c3+1;     
                true_negative(1,3)=true_negative(1,3)+1;
            end
            
            
            % FN condition
            if ((ThreshImage(i,j)~=0)&&((GroundTruth(i,j)==0)))
                FN_c1=FN_c1+1;
                false_negative(1,1)=false_negative(1,1)+1;
           
            elseif ((ThreshImage(i,j)~=126)&&((GroundTruth(i,j)==126)))    
                FN_c2=FN_c2+1;
                false_negative(1,2)=false_negative(1,2)+1;
          
            elseif ((ThreshImage(i,j)~=255)&&((GroundTruth(i,j)==255)))    
                FN_c3=FN_c3+1;
                false_negative(1,3)=false_negative(1,3)+1;
            end
                
                
         end
     end
end