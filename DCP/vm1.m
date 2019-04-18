% Voting Method 1 - Each attribute has same weight 
function [results] = vm1(test, guess, numAttributes)
one = 0; 
two = 0; 
three = 0;
names = fieldnames(guess{1});
results = struct; 
classification = []; 
% For each test point, add up number of times 
% it is assigned each class 
for j = 1:size(test,1) 
    for i = 1:numAttributes
        if( guess{j}.(names{i}) == 1) 
            one = one +1; 
        end 
        if(guess{j}.(names{i}) == 2) 
            two = two +1; 
        end 
        if( guess{j}.(names{i}) == 3) 
            three = three +1; 
        end   
    end 
    % Pick max score for classification 
    [~, temp] =  max([one, two, three]); 
    classification = [classification, temp]; 
end 
results.point = test; 
results.classification = classification; 
temp = test(:,numAttributes+1) - results.classification'; 
results.accuracy = size(find(temp == 0),1); 
end 