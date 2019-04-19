% Voting Method 4 - Assign votes on ratio of class to non-class values with
% caps on intervals and votes
function [results] = vm4(test, guess, numAttributes, training_set, intervalCap, votingCap)
results = struct;
classification = [];
names = fieldnames(guess{1});
for j = 1:size(test,1)
    one = 0;
    two = 0;
    three = 0;
    for i = 1:numAttributes
        if (guess{j}.(names{i}) ~= 0)
            % Only use if the interval is large enough
            if (training_set{i}.intervals(guess{j}.(names{i+numAttributes}),2) - training_set{i}.intervals(guess{j}.(names{i+numAttributes}),1) > intervalCap)
                totalCount = sum(training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),:));
                oneCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),1);
                twoCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),2);
                threeCount = training_set{i}.intervalCounts(guess{j}.(names{i+numAttributes}),3);
                % If above voting cap, set to voting cap
                if oneCount/ (totalCount -oneCount) > votingCap
                    one = one + votingCap;
                else
                    one = one + (oneCount/ (totalCount -oneCount));
                end
                if twoCount/ (totalCount -twoCount) > votingCap
                    two = two + votingCap;
                else
                    two = two + (twoCount/ (totalCount -twoCount));
                end
                if threeCount/ (totalCount -threeCount) > votingCap
                    three = three + votingCap;
                else
                    three = three + (threeCount/ (totalCount -threeCount));
                end
            end
        end
    end
    [~, temp] =  max([one, two, three]);
    classification = [classification, temp];
end
results.point = test;
results.classification = classification;
% Change here for different sizes
temp = test(:,numAttributes+1) - results.classification';
results.accuracy = size(find(temp == 0),1);
end
