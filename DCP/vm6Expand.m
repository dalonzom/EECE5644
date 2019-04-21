function [selectedTraining, selectedTesting] = vm6Expand(trainingSet, testingSet)

oldDim = size(trainingSet);
avgTrain = mean(trainingSet);
avgTest = mean(testingSet);
labels = trainingSet(:,oldDim(2));
counter = 0;
fullTraining = trainingSet;
fullTesting = testingSet;
for(i=1:(oldDim(2)-1))
    for(j=(i+1):(oldDim(2)-1))
        fullTraining(:,oldDim(2)+counter) = (trainingSet(:,i)-avgTrain(i)).*(trainingSet(:,j)-avgTrain(j));
        fullTesting(:,oldDim(2)+counter) = (testingSet(:,i)-avgTest(i)).*(testingSet(:,j)-avgTest(j));
        counter = counter + 1;
    end
end
fullTraining(:,oldDim(2)+counter) = labels;

fullDim = size(fullTraining);
scores = [];
for(i=1:(fullDim(2)-1))
    tempValues = fullTraining(:,i);
    lowest = min(tempValues);
    highest = max(tempValues);
    tempValues = (tempValues-lowest)/(highest-lowest);
    training_set = training(tempValues, fullTraining(:,fullDim(2)), 0);
    temp = training_set.intervalCounts;
    across = sum(temp,2);
    temp*2 - across;
    max(ans);
    scores(i,:) = ans;
end
for(i=1:size(scores,2))
    count = size(find(trainingSet(:,oldDim(2))==i));
    scores(:,i) = count(1).*scores(:,i)./sum(scores(:,i));
end

tempScores = sum(scores,2);
selections = [];
for(i=1:(oldDim(2)-1))
    [~, index] = max(tempScores);
    selectedTraining(:,i) = fullTraining(:, index);
    selectedTesting(:,i) = fullTesting(:,index);
    tempScores(index) = -1;
end
selectedTesting(:,oldDim(2)) = testingSet(:,oldDim(2));
selectedTraining(:,oldDim(2)) = trainingSet(:,oldDim(2));

end