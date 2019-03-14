function [Precision_c1,Precision_c2,Precision_c3,Recall_c1,Recall_c2,Recall_c3,Accuracy_c1,Accuracy_c2,Accuracy_c3,FScore_c1,FScore_c2,FScore_c3] = individual_score(ThreshImage,GroundTruth)
% This function calculates the individual scores for each images


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
            elseif (GroundTruth(i,j)==126 && ThreshImage(i,j)==126)  
                TP_c2=TP_c2+1;
            elseif (GroundTruth(i,j)==255 && ThreshImage(i,j)==255)  
                TP_c3=TP_c3+1;                
                
            % FP condition
            elseif (GroundTruth(i,j)~=0 && ThreshImage(i,j)==0)
                FP_c1=FP_c1+1;
            elseif (GroundTruth(i,j)~=126 && ThreshImage(i,j)==126)
                FP_c2=FP_c2+1;
            elseif (GroundTruth(i,j)~=255 && ThreshImage(i,j)==255)
                FP_c3=FP_c3+1;                
                
            % TN condition
            elseif  (GroundTruth(i,j)~=0)&& (ThreshImage(i,j)~=0) % TN condition
                TN_c1=TN_c1+1;
            elseif  (GroundTruth(i,j)~=126)&& (ThreshImage(i,j)~=126) % TN condition
                TN_c2=TN_c2+1;  
            elseif  (GroundTruth(i,j)~=255)&& (ThreshImage(i,j)~=255) % TN condition
                TN_c3=TN_c3+1;            
            
            % FN condition
            elseif ((ThreshImage(i,j)~=0)&&((GroundTruth(i,j)==0)))
                FN_c1=FN_c1+1;
            elseif ((ThreshImage(i,j)~=126)&&((GroundTruth(i,j)==126)))    
                FN_c2=FN_c2+1;
            elseif ((ThreshImage(i,j)~=255)&&((GroundTruth(i,j)==255)))    
                FN_c3=FN_c3+1;               
                
            end
        end
    end
    

    if (TP_c1==0 && FP_c1==0)
        Precision_c1=1;
        Precision_c2=TP_c2/(TP_c2+FP_c2);
        Precision_c3=TP_c3/(TP_c3+FP_c3);        
    elseif (TP_c2==0 && FP_c2==0)
        Precision_c2=1;
        Precision_c1=TP_c1/(TP_c1+FP_c1);
        Precision_c3=TP_c3/(TP_c3+FP_c3);
    elseif (TP_c3==0 && FP_c3==0)
        Precision_c3=1;
        Precision_c1=TP_c1/(TP_c1+FP_c1);
        Precision_c2=TP_c2/(TP_c2+FP_c2);        
    else
        Precision_c1=TP_c1/(TP_c1+FP_c1);
        Precision_c2=TP_c2/(TP_c2+FP_c2);
        Precision_c3=TP_c3/(TP_c3+FP_c3);
    end
    
    if (TP_c1==0 && FN_c1==0)
        Recall_c1=1;
        Recall_c2=TP_c2/(TP_c2+FN_c2);
        Recall_c3=TP_c3/(TP_c3+FN_c3);        
    elseif (TP_c2==0 && FN_c2==0)
        Recall_c2=1;        
        Recall_c1=TP_c1/(TP_c1+FN_c1);
        Recall_c3=TP_c3/(TP_c3+FN_c3);
    elseif (TP_c3==0 && FN_c3==0)
        Recall_c3=1;          
        Recall_c1=TP_c1/(TP_c1+FN_c1);
        Recall_c2=TP_c2/(TP_c2+FN_c2);        
    else
        Recall_c1=TP_c1/(TP_c1+FN_c1);
        Recall_c2=TP_c2/(TP_c2+FN_c2);
        Recall_c3=TP_c3/(TP_c3+FN_c3);
    end
    
    Accuracy_c1=(TP_c1+TN_c1)/(TP_c1+FN_c1+FP_c1+TN_c1);
    Accuracy_c2=(TP_c2+TN_c2)/(TP_c2+FN_c2+FP_c2+TN_c2);
    Accuracy_c3=(TP_c3+TN_c3)/(TP_c3+FN_c3+FP_c3+TN_c3);
    
    FScore_c1=(2*Precision_c1*Recall_c1)/(Precision_c1+Recall_c1);
    FScore_c2=(2*Precision_c2*Recall_c2)/(Precision_c2+Recall_c2);
    FScore_c3=(2*Precision_c3*Recall_c3)/(Precision_c3+Recall_c3);
    
    
    
    
    
    