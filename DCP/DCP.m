%% Implementation of the Dominance Classifier and Predictor Algorithm
%% taken from "Toward Efficient Automation of Interpretable Machine Learning"
%% developed by Boris Kovalerchuk, Nathan Neuhaus
%% EECE 5644 Final Project, Marissa D'Alonzo, Ryan Huebelback
% Notes - needs to be modified to work for all inputs,
% Classes must start at 1

clear;
% CHANGE HERE
numClasses = 2;
allGuess = [];
accuracyResults = [];
allTest = {};
allResults = [];
count = 1;
tempCell = struct2cell(load('iris.mat'));
fullData = tempCell{1};
fullDim = size(fullData);
if(min(fullData(:,fullDim(2)))==0)
    fullData(:,fullDim(2)) = fullData(:,fullDim(2)) + 1;
end
indices = randperm(fullDim(1));
test = fullData(indices((fullDim(1)*.8)+1:fullDim(1)),:);
fullTrain = fullData(indices(1:fullDim(1)*.8),:);
numAttributes = fullDim(2) - 1;

folds = 10;

intervalCap = .02;
votingCap = 1;

for dtc = 0:.1:1
    setAccuracy = zeros(folds,1);
    
    dim = size(fullTrain);
    
    indices = randperm(dim(1));
    fullTrain = fullTrain(indices, :);
    
    for set = 1:folds
        
        starting = round(((set-1)/folds*dim(1))+1);
        ending = round((set)/folds*dim(1));
        validate = fullTrain(starting:ending, :);
        if(set==1)
            train = fullTrain((ending+1):end, :);
        elseif (set==folds)
            train = fullTrain(1:(starting-1), :);
        else
            train = [fullTrain(1:(starting-1), :); fullTrain((ending+1):end, :)];
        end
        
        numAttributes = dim(2) - 1;
        
        %% Create Dominance Classifier Structure
        training_set = {};
        for i = 1:numAttributes
            training_set{i} = training(train(:,i), train(:,dim(2)), dtc);
        end
        
        %% Classification
        % Guess Classes
        guess = {};
        for i = 1:size(validate,1)
            point = validate(i,:);
            guess{i} =  guessClasses(point, numAttributes, training_set);
        end
        
        %% Combine Dominances
        % Voting Method 4
        results4 = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
        
        setAccuracy(set) = results4.accuracy;
    end
    
    %Store the results of each iteration
    accuracyResults = [accuracyResults, mean(setAccuracy)];
    allResults = [allResults; training_set];
    allGuess = [allGuess; guess];
    allTest{count} = validate;
    count = count +1;
end
%Plot accuracy
figure;
bar(accuracyResults)
%xticklabels({'0','.1','.2', '.3', '.4','.5','.6','.7','.8', '.9', '1'})
xlabel('Runs')
ylabel('Number of Instances Classified Correctly')
[~, dtcIdx] = max(accuracyResults);
training_set = allResults(dtcIdx,:);
guess = allGuess(dtcIdx,:);
validate = allTest{dtcIdx};
dtc = (dtcIdx-1)/10;

[m, freq] = mode(training_set{1}.labels);
temp = mode(training_set{1}.labels(training_set{1}.labels ~= m));
[m2, freq2] = mode(temp);
votingCapAccuracy = [];
votingCaps = [];
for votingCap = 1 :1:freq/freq2
    setAccuracy = zeros(folds,1);
    
    dim = size(fullTrain);
    
    indices = randperm(dim(1));
    fullTrain = fullTrain(indices, :);
    
    for set = 1:folds
        
        starting = round(((set-1)/folds*dim(1))+1);
        ending = round((set)/folds*dim(1));
        validate = fullTrain(starting:ending, :);
        if(set==1)
            train = fullTrain((ending+1):end, :);
        elseif (set==folds)
            train = fullTrain(1:(starting-1), :);
        else
            train = [fullTrain(1:(starting-1), :); fullTrain((ending+1):end, :)];
        end
        
        numAttributes = dim(2) - 1;
        
        %% Create Dominance Classifier Structure
        training_set = {};
        for i = 1:numAttributes
            training_set{i} = training(train(:,i), train(:,dim(2)), dtc);
        end
        
        %% Classification
        % Guess Classes
        guess = {};
        for i = 1:size(validate,1)
            point = validate(i,:);
            guess{i} =  guessClasses(point, numAttributes, training_set);
        end
        
        %% Combine Dominances
        % Voting Method 4
        results4 = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
        
        setAccuracy(set) = results4.accuracy;
    end
    
    votingCapAccuracy = [votingCapAccuracy, mean(setAccuracy)];
    votingCaps = [votingCaps, votingCap];
    
end
[~, index] = max(votingCapAccuracy);
votingCap = votingCaps(index);
figure;
bar(votingCapAccuracy);

intervalCaps = [];
intervalCapAccuracy = [];
for intervalCap =  0:.5:max(max(train) - min(train))
    setAccuracy = zeros(folds,1);
    
    dim = size(fullTrain);
    
    indices = randperm(dim(1));
    fullTrain = fullTrain(indices, :);
    
    for set = 1:folds
        
        starting = round(((set-1)/folds*dim(1))+1);
        ending = round((set)/folds*dim(1));
        validate = fullTrain(starting:ending, :);
        if(set==1)
            train = fullTrain((ending+1):end, :);
        elseif (set==folds)
            train = fullTrain(1:(starting-1), :);
        else
            train = [fullTrain(1:(starting-1), :); fullTrain((ending+1):end, :)];
        end
        
        numAttributes = dim(2) - 1;
        
        %% Create Dominance Classifier Structure
        training_set = {};
        for i = 1:numAttributes
            training_set{i} = training(train(:,i), train(:,dim(2)), dtc);
        end
        
        %% Classification
        % Guess Classes
        guess = {};
        for i = 1:size(validate,1)
            point = validate(i,:);
            guess{i} =  guessClasses(point, numAttributes, training_set);
        end
        
        %% Combine Dominances
        % Voting Method 4
        results4 = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
        
        setAccuracy(set) = results4.accuracy;
    end
    
    intervalCapAccuracy = [intervalCapAccuracy, mean(setAccuracy)];
    intervalCaps = [intervalCaps, intervalCap];
    
end

[~, index] = max(intervalCapAccuracy);
intervalCap = intervalCaps(index);
figure;
bar(intervalCapAccuracy)

train = fullTrain;
dim = size(train);

numAttributes = dim(2) - 1;

%% Create Dominance Classifier Structure
training_set = {};
for i = 1:numAttributes
    training_set{i} = training(train(:,i), train(:,dim(2)), dtc);
end

%% Classification
% Guess Classes
guess = {};
for i = 1:size(test,1)
    point = test(i,:);
    guess{i} =  guessClasses(point, numAttributes, training_set);
end

% % Voting Method 1
% results1 = vm1(test, guess, numAttributes);
%
% % Voting Method 2
% results2 = vm2(test,guess,numAttributes, training_set);
%
% % Voting Method 3
% results3 = vm3(test,guess,numAttributes, training_set);

% Voting Method 4
results4 = vm4(test, guess, numAttributes, training_set, intervalCap, votingCap);