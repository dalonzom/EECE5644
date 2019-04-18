%% Implementation of the Dominance Classifier and Predictor Algorithm
%% taken from "Toward Efficient Automation of Interpretable Machine Learning"
%% developed by Boris Kovalerchuk, Nathan Neuhaus
%% EECE 5644 Final Project, Marissa D'Alonzo, Ryan Huebelback
% Notes - needs to be modified to work for all inputs,
% Classes must start at 1


% CHANGE HERE
numClasses = 2;
allGuess = [];
accuracyResults = [];
allTest = {};
allResults = [];
count = 1;



for dtc = 0:.1:1
    % Use 80% for training
    load('iris.mat')
   % iris(:,3) = iris(:,3) +1; 
    dim = size(iris);
    train = randperm(dim(1));
    test = iris(train((dim(1)*.8)+1:dim(1)),:);
    iris = iris(train(1:dim(1)*.8),:);
    numAttributes = dim(2) - 1;
    %% Create Dominance Classifier Structure
    training_set = {};
    for i = 1:numAttributes
        training_set{i} = training(iris(:,i), iris(:,dim(2)), dtc);
    end
    
    %% Classification
    % Guess Classes
    guess = {};
    for i = 1:size(test,1)
        point = test(i,:);
        guess{i} =  guessClasses(point, numAttributes, training_set);
    end
    
    %% Combine Dominances
    
    % % Voting Method 1
    % results1 = vm1(test, guess, numAttributes);
    %
    % % Voting Method 2
    % results2 = vm2(test,guess,numAttributes, training_set);
    %
    % % Voting Method 3
    % results3 = vm3(test,guess,numAttributes, training_set);
    
    % Voting Method 4
    intervalCap = .02;
    votingCap = 1;
    results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap);
    
    %Store the results of each iteration
    accuracyResults = [accuracyResults, results4.accuracy];
    allResults = [allResults; training_set];
    allGuess = [allGuess; guess];
    allTest{count} = test;
    count = count +1; 
end
%Plot accuracy
figure;
bar(accuracyResults)
%xticklabels({'0','.1','.2', '.3', '.4','.5','.6','.7','.8', '.9', '1'})
xlabel('Runs')
ylabel('Number of Instances Classified Correctly')
[~, dtc] = max(accuracyResults);
training_set = allResults(dtc,:);
guess = allGuess(dtc,:);
test = allTest{dtc};
dtc = (dtc-1)/10;

[m, freq] = mode(training_set{1}.labels);
temp = mode(training_set{1}.labels(training_set{1}.labels ~= m));
[m2, freq2] = mode(temp);
votingCapAccuracy = [];
votingCaps = [];
for votingCap = 1 :1:freq/freq2
    results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap);
    votingCapAccuracy = [votingCapAccuracy, results4.accuracy];
    votingCaps = [votingCaps, votingCap];
end
[~, index] = max(votingCapAccuracy);
votingCap = votingCaps(index);
figure;
bar(votingCapAccuracy);

intervalCaps = [];
intervalCapAccuracy = [];
for intervalCap =  0:.5:max(max(iris) - min(iris))
    results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap);
    intervalCapAccuracy = [intervalCapAccuracy, results4.accuracy];
    intervalCaps = [intervalCaps, intervalCap];
end

[~, index] = max(intervalCapAccuracy);
intervalCap = intervalCaps(index);
figure;
bar(intervalCapAccuracy)


results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap);
results4.accuracy