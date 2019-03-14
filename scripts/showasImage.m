
function [OutputMatrix] = showasImage(InputMatrix)
[rows,cols]=size(InputMatrix);

minValue=min(min(InputMatrix));
maxValue=max(max(InputMatrix));
Range=maxValue-minValue;

for i=1:rows
    for j=1:cols
        OutputMatrix(i,j)=((InputMatrix(i,j)-minValue)/Range)*255;
    end
end