function [phi,mu0,mu1,sigma]=likelihood_estimate(data_vector,labels_map,label_index,index_rem1,index_rem2)
% This function estimates the parameters of the gaussian distribution.
% phi = bernoulli parameter
% mu0 = mean of data points for negative samples.
% mu1 = mean of data points for positive samples.
% sigma = co-variance matrix of the data vector.

% Input parameters:
% data_vector = input feature vector (can be of any dimension)
% rows/cols = rows/cols for the training label map
% labels_map = map showing the different class labels (ground truth)
% label_index = index for which the likelihood estimates are calculated.
% index_rem1/index_rem2 = remaining indexes of the class labels 
% (In this case, 3 class labels are considered)

I_labels=labels_map;
labels_st=I_labels';
no_of_labels=sum(I_labels(:) == label_index);
no_of_labels2=sum(I_labels(:) == index_rem1);
no_of_labels3=sum(I_labels(:) == index_rem2);
[tot_pixels,~]=size(I_labels);
phi=no_of_labels/(tot_pixels);

% How many dimension vector have you chosen for feature vector?
[~,dim]=size(data_vector);

% negative samples for class 1 (or label_index)
sum_mu0=zeros(1,dim);
for t=1:tot_pixels
   if  labels_st(1,t)~=label_index
      sum_mu0=sum_mu0 + data_vector(t,:);
   end
end
mu0=sum_mu0./(no_of_labels2+no_of_labels3);

% positive samples for class 1
sum_mu1=zeros(1,dim);
for t=1:tot_pixels
   if  labels_st(1,t)==label_index
      sum_mu1=sum_mu1 + data_vector(t,:);
   end
end
mu1=sum_mu1./no_of_labels;

sigma=cov(data_vector);