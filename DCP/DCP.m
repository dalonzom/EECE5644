%% Implementation of the Dominance Classifier and Predictor Algorithm
%% taken from "Toward Efficient Automation of Interpretable Machine Learning"
%% developed by Boris Kovalerchuk, Nathan Neuhaus
%% EECE 5644 Final Project, Marissa D'Alonzo, Ryan Hubelbank
% Notes - needs to be modified to work for all inputs,
% Classes must start at 1

clear;
% CHANGE HERE
allGuess = [];

allTest = {};
allResults = [];
count = 1;
tempCell = struct2cell(load('gauss4.mat'));
fullData = tempCell{1};

fullDim = size(fullData);
initialDim = fullDim;
if(min(fullData(:,fullDim(2)))==0)
    fullData(:,fullDim(2)) = fullData(:,fullDim(2)) + 1;
end

indices = randperm(fullDim(1));
test = fullData(indices(round((fullDim(1)*.8))+1:fullDim(1)),:);
fullTrain = fullData(indices(1:round(fullDim(1)*.8)),:);

[fullTrain, test] = vm7Expand(fullTrain, test);

fullDim = size(fullData);

for(col=1:(fullDim(2)-1))
    lowest = min(fullTrain(:,col));
    lowest2 = min(test(:,col));
    lowest = min(lowest, lowest2);
    highest = max(fullTrain(:,col));
    highest2 = max(test(:,col));
    highest = max(highest, highest2);
    fullTrain(:,col)= (fullTrain(:,col)-lowest)/(highest-lowest);
    test(:,col)= (test(:,col)-lowest)/(highest-lowest);
end

train = fullTrain;
dim = size(train);

originalTrain = fullTrain(:,[1:(initialDim(2) - 1) dim(2)]);

dtc1 = trainVm1(originalTrain);
dtc2 = trainVm2(originalTrain);
dtc3 = trainVm3(originalTrain);
[dtc4, intervalCap4, votingCap4] = trainVm4(originalTrain);
[dtc5, intervalCap5, votingCap5] = trainVm4(fullTrain);
[dtc6, intervalCap6, votingCap6] = trainVm4(fullTrain);

%%

originalTest = test(:,[1:(initialDim(2)-1) dim(2)]);

numAttributes = dim(2) - 1;
originalNumAttributes = initialDim(2) - 1;

%% Create Dominance Classifier Structure
training_set1 = {};
for i = 1:originalNumAttributes
    training_set1{i} = training(originalTrain(:,i), originalTrain(:,initialDim(2)), dtc1);
end

training_set2 = {};
for i = 1:originalNumAttributes
    training_set2{i} = training(originalTrain(:,i), originalTrain(:,initialDim(2)), dtc2);
end

training_set3 = {};
for i = 1:originalNumAttributes
    training_set3{i} = training(originalTrain(:,i), originalTrain(:,initialDim(2)), dtc3);
end

training_set4 = {};
for i = 1:originalNumAttributes
    training_set4{i} = training(originalTrain(:,i), originalTrain(:,initialDim(2)), dtc4);
end

training_set5 = {};
for i = 1:originalNumAttributes
    training_set5{i} = training(originalTrain(:,i), originalTrain(:,initialDim(2)), dtc5);
end

training_set6 = {};
for i = 1:numAttributes
    training_set6{i} = training(fullTrain(:,i), fullTrain(:,dim(2)), dtc6);
end

%% Classification
% Guess Classes
guess1 = {};
for i = 1:size(originalTest,1)
    point = originalTest(i,:);
    guess1{i} =  guessClasses(point, originalNumAttributes, training_set1);
end

guess2 = {};
for i = 1:size(originalTest,1)
    point = originalTest(i,:);
    guess2{i} =  guessClasses(point, originalNumAttributes, training_set2);
end

guess3 = {};
for i = 1:size(originalTest,1)
    point = originalTest(i,:);
    guess3{i} =  guessClasses(point, originalNumAttributes, training_set3);
end

guess4 = {};
for i = 1:size(originalTest,1)
    point = originalTest(i,:);
    guess4{i} =  guessClasses(point, originalNumAttributes, training_set4);
end

guess5 = {};
for i = 1:size(originalTest,1)
    point = originalTest(i,:);
    guess5{i} =  guessClasses(point, originalNumAttributes, training_set5);
end

guess6 = {};
for i = 1:size(test,1)
    point = test(i,:);
    guess6{i} =  guessClasses(point, numAttributes, training_set6);
end

%%
acc = [];
% % Voting Method 1
results1 = vm1(originalTest, guess1, originalNumAttributes);
acc = [acc results1.accuracy/size(test,1)];
%
% % Voting Method 2
results2 = vm2(originalTest,guess2,originalNumAttributes, training_set2);
acc = [acc results2.accuracy/size(test,1)];
%
% % Voting Method 3
results3 = vm3(originalTest,guess3,originalNumAttributes, training_set3);
acc = [acc results3.accuracy/size(test,1)];

% Voting Method 4
results4 = vm4(originalTest, guess4, originalNumAttributes, training_set4, intervalCap4, votingCap4);
acc = [acc results4.accuracy/size(test,1)];

results5 = vm5(originalTest, guess5, originalNumAttributes, training_set5, intervalCap5, votingCap5);
acc = [acc results5.accuracy/size(test,1)];

results6 = vm5(test, guess6, numAttributes, training_set6, intervalCap6, votingCap6);
acc = [acc results6.accuracy/size(test,1)];