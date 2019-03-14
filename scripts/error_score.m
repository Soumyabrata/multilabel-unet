function [sky_value, thincloud_value, thickcloud_value] = error_score(ThreshImage,GroundTruth)
% This function calculates the individual scores for each images


    [r1,c1]=size(ThreshImage);
    GroundTruth1=GroundTruth;    
    [r,c]=size(GroundTruth1);
    
    if (r1==r)&& (c1==c)
        disp ('Dimension of the two images are equal.');
    else
        disp ('Dimension of the two images are not in order.');
    end

    
    sky_occurences = sum(sum(GroundTruth1==0));
    thin_occurences = sum(sum(GroundTruth1==126));
    thick_occurences = sum(sum(GroundTruth1==255));
    
    sky_error = 0;
    thin_error = 0;
    thick_error = 0;

    for i=1:r1
        for j=1:c1
            
            % For 3 cluster cases
            % sky condition
            if (GroundTruth(i,j)==0 && ThreshImage(i,j)~=0)  
                sky_error=sky_error+1;
              
                
            % thin cloud condition
            elseif (GroundTruth(i,j)==126 && ThreshImage(i,j)~=126)  
                thin_error=thin_error+1;
                
                
            % thick cloud condition
            elseif (GroundTruth(i,j)==255 && ThreshImage(i,j)~=255)  
                thick_error=thick_error+1;
                
           
                
            end
        end
    end
    

    if (sky_occurences==0)
        sky_value = nan;            
    else
        sky_value = sky_error/sky_occurences;
    end
    
    
    if (thin_occurences==0)
        thincloud_value = nan;            
    else
        thincloud_value = thin_error/thin_occurences;
    end
    
    
    if (thick_occurences==0)
        thickcloud_value = nan;            
    else
        thickcloud_value = thick_error/thick_occurences;
    end
    
    

end

    
    
    
    
    
    
    
    
    