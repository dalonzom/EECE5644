%% Implementation of the Dominance Classifier and Predictor Algorithm
%% taken from "Toward Efficient Automation of Interpretable Machine Learning"
%% developed by Boris Kovalerchuk, Nathan Neuhaus
%% EECE 5644 Final Project, Marissa D'Alonzo, Ryan Huebelback
% Notes - needs to be modified to work for all inputs,
% Classes must start at 1


% CHANGE HERE
numClasses = 3;
allGuess = [];
accuracyResults = [];
allTest = {};
allResults = [];
count = 1;
load('scale.mat')
dim = size(scale);
numAttributes = dim(2) - 1;
[m, freq] = mode(scale(:,numAttributes+1));
temp = mode(scale(:,numAttributes+1 ~= m));
[m2, freq2] = mode(temp);
allDtc = []; 
allVotingCap = []; 
allIntervalCap = []; 
for dtc = 0:.1:1 
    for votingCap = 1 :.1:freq/freq2
        for intervalCap =  0:.2:max(max(scale) - min(scale))
            % Use 80% for training
            load('scale.mat')
            dim = size(scale);
            train = randperm(dim(1));
            test = scale(train((dim(1)*.8)+1:dim(1)),:);
            scale = scale(train(1:dim(1)*.8),:);
            numAttributes = dim(2) - 1;
            %% Create Dominance Classifier Structure
            training_set = {};
            for i = 1:numAttributes
                training_set{i} = training(scale(:,i), scale(:,dim(2)), dtc);
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
            results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap);
            
            %Store the results of each iteration 
            accuracyResults = [accuracyResults, results4.accuracy];
            allResults = [allResults; training_set];
            allGuess = [allGuess; guess];
            allTest{count} = test;
            count = count +1;
            allDtc = [allDtc, dtc]; 
            allIntervalCap = [allIntervalCap, intervalCap]; 
            allVotingCap = [allVotingCap, votingCap]; 
            
        end
    end
end
%Plot accuracy
figure;
bar(accuracyResults)
%xticklabels({'0','.1','.2', '.3', '.4','.5','.6','.7','.8', '.9', '1'})
 xlabel('Runs')
ylabel('Number of Instances Classified Correctly')
[~, accurate] = max(accuracyResults);
training_set = allResults(accurate,:);
guess = allGuess(accurate,:);
test = allTest{accurate};
dtc = allDtc(accurate); 
votingCap = allVotingCap(accurate); 
intervalCap = allIntervalCap(accurate); 

