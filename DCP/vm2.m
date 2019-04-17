% Voting Method 2 - Size Dependent 
function [results] = vm2(test, guess, numAttributes, training_set)
results = struct;
classification = [];
names = fieldnames(guess{1});
for j = 1:size(test,1)
    one = 0;
    two = 0;
    three = 0;
    % assign votes based off how many instances of each class appear in the
    % interval 
    for i = 1:numAttributes
        if (guess{j}.(names{i}) ~= 0)
            one = one + training_set{i}.intervalCounts(guess{j}.(names{i+4}),1);
            two = two + training_set{i}.intervalCounts(guess{j}.(names{i+4}),2);
            three = three + training_set{i}.intervalCounts(guess{j}.(names{i+4}),3); 
        end
    end
    [~, temp] =  max([one, two, three]);
    classification = [classification, temp];
end
results.point = test;
results.classification = classification;
% Modify here for different sizes 
temp = test(:,5) - results.classification';
results.accuracy = size(find(temp == 0),1);
end 