% Voting Method 3 - Assign votes on ratio of class to non-class values 
function [results] = vm3(test, guess, numAttributes, training_set) 
results = struct;
classification = [];
names = fieldnames(guess{1});
for j = 1:size(test,1)
    one = 0;
    two = 0;
    three = 0;
    for i = 1:numAttributes
        if (guess{j}.(names{i}) ~= 0)
            totalCount = sum(training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),:)); 
            oneCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),1); 
            one = one + (oneCount/ (totalCount -oneCount)); 
            twoCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),2); 
            two = two + (twoCount/ (totalCount -twoCount)); 
            threeCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),3); 
            three = three + (threeCount/ (totalCount -threeCount)); 

        end
    end
    [~, temp] =  max([one, two, three]);
    classification = [classification, temp];
end
results.point = test;
results.classification = classification; 
temp = test(:,numAttributes+1) - results.classification';
results.accuracy = size(find(temp == 0),1);

end 