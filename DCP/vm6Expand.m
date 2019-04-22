function [selectedTraining, selectedTesting] = vm6Expand(trainingSet, testingSet)

oldDim = size(trainingSet);
%avgTrain = mean(trainingSet);
%avgTest = mean(testingSet);
avg = mean([trainingSet; testingSet]);
labels = trainingSet(:,oldDim(2));
counter = 0;
fullTraining = trainingSet;
fullTesting = testingSet;
mappings = {};
for(i=1:(oldDim(2)-1))
    mappings{i} = [];
end
for(i=1:(oldDim(2)-1))
    for(j=(i+1):(oldDim(2)-1))
        mappings{i} = [mappings{i} oldDim(2)+counter];
        mappings{j} = [mappings{j} oldDim(2)+counter];
        fullTraining(:,oldDim(2)+counter) = (trainingSet(:,i)-avg(i)).*(trainingSet(:,j)-avg(j));
        fullTesting(:,oldDim(2)+counter) = (testingSet(:,i)-avg(i)).*(testingSet(:,j)-avg(j));
        counter = counter + 1;
    end
end

relations = cov(fullTraining);
relations = abs(relations);

fullTraining(:,oldDim(2)+counter) = labels;

fullDim = size(fullTraining);
scores = [];
for(i=1:(fullDim(2)-1))
    tempValues = fullTraining(:,i);
    otherValues = fullTesting(:,i);
    lowest = min(tempValues);
    otherLowest = min(otherValues);
    lowest = min(lowest, otherLowest);
    highest = max(tempValues);
    otherHighest = max(otherValues);
    highest = max(highest, otherHighest);
    tempValues = (tempValues-lowest)/(highest-lowest);
    training_set = training(tempValues, fullTraining(:,fullDim(2)), 0);
    temp = training_set.intervalCounts;
    across = sum(temp,2);
    temp*2 - across;
    max(ans);
    scores(i,:) = ans;
end

scores = scores(:,[1:max(trainingSet(:,oldDim(2)))]);

for(i=1:size(scores,2))
    %count = size(find(trainingSet(:,oldDim(2))==i));
    %scores(:,i) = count(1).*scores(:,i)./sum(scores(:,i));
    scores(:,i) = scores(:,i)./sum(scores(:,i));
end

tempScores = min(scores,[],2)
% for(i=(oldDim(2)-1):(fullDim(2)-1))
%     tempScore(i) = sqrt(tempScore(i));
% end
selections = [];
counter = 1;
for(i=1:(oldDim(2)-1))
    selectedTraining(:,i) = fullTraining(:, i);
    selectedTesting(:,i) = fullTesting(:, i);
    tempScores(i) = -Inf;
    counter = counter + 1;
end
for(i=counter:10)
    if(i>(fullDim(2)-1))
        break;
    end
    tempScores
    [~, index] = max(tempScores);
    selectedTraining(:,i) = fullTraining(:, index);
    selectedTesting(:,i) = fullTesting(:,index);
    factor = relations(index,index);
%     if(index < oldDim(2))
%         for(j = mappings{index})
%             tempScores(j) = tempScores(j)/2;
%         end
%     end
    tempScores(index) = -Inf;
    counter = counter + 1;
end
tempScores
selectedTesting(:,counter) = testingSet(:,oldDim(2));
selectedTraining(:,counter) = trainingSet(:,oldDim(2));

end