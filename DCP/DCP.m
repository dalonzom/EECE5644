%% Implementation of the Dominance Classifier and Predictor Algorithm 
%% taken from "Toward Efficient Automation of Interpretable Machine Learning" 
%% written by Boris Kovalerchuk, Nathan Neuhaus  
%% EECE 5644 Final Project, Marissa D'Alonzo, Ryan Hubelbank 
% Notes - needs to be modified to work for all inputs, 
% Classes must start at 1 
% Load dataset
load('iris.mat')
%gauss4(:,3) = gauss4(:,3) + 1; 
% Use 80% for training
train = randperm(150);
test = iris(train(121:150),:); 
iris = iris(train(1:120),:);
numAttributes = 4;
numClasses = 2;

%% Create Dominance Classifier Structure
training_set = {};
for i = 1:numAttributes
    training_set{i} = training(iris(:,i), iris(:,5));
end

%% Classification

% Guess Classes
guess = {};
for i = 1:size(test,1)
    point = test(i,:);
    guess{i} =  guessClasses(point, numAttributes, training_set);
end

%% Combine Dominances

% Voting Method 1
results1 = vm1(test, guess, numAttributes);

% Voting Method 2
results2 = vm2(test,guess,numAttributes, training_set); 

% Voting Method 3 
results3 = vm3(test,guess,numAttributes, training_set); 

% Voting Method 4 
intervalCap = .2; 
votingCap = 20; 
results4 = vm4(test,guess, numAttributes,training_set, intervalCap, votingCap); 

%Plot accuracy 
figure; 
bar([results1.accuracy, results2.accuracy, results3.accuracy, results4.accuracy])

