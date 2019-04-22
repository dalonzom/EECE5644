function [dtc] = trainVm1(trainingSet)

fullDim = size(trainingSet);

folds = 5;
precision = 0.01;

dtc = 0;
intervalCap = 0;
votingCap = fullDim(1);

repetitions = 10;
decayRate = 0.9;
stepPercent = 1/decayRate;
windowTail = 0.3;

windowTail = windowTail / decayRate;

for repeat = 1:repetitions
    
    stepPercent = stepPercent * decayRate
    windowTail = max(precision, windowTail * decayRate);
    
    repeat
    dtcs = [];
    accuracyResults = [];
    
    oldDtc = dtc;
    
    for dtc = max(oldDtc-windowTail,0):precision:min(oldDtc+windowTail,1)
        setAccuracy = zeros(folds,1);
        
        dim = size(trainingSet);
        
        indices = randperm(dim(1));
        trainingSet = trainingSet(indices, :);
        
        for set = 1:folds
            
            starting = round(((set-1)/folds*dim(1))+1);
            ending = round((set)/folds*dim(1));
            validate = trainingSet(starting:ending, :);
            if(set==1)
                train = trainingSet((ending+1):end, :);
            elseif (set==folds)
                train = trainingSet(1:(starting-1), :);
            else
                train = [trainingSet(1:(starting-1), :); trainingSet((ending+1):end, :)];
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
            % Voting Method
            results = vm1(validate,guess, numAttributes);
            
            setAccuracy(set) = results.accuracy;
        end
        
        %Store the results of each iteration
        accuracyResults = [accuracyResults, mean(setAccuracy)];
        dtcs = [dtcs dtc];
    end

    [~, dtcIdx] = max(accuracyResults);
    dtc = dtcs(dtcIdx);
    dtc = oldDtc+(dtc-oldDtc)*(stepPercent)
end
    
end