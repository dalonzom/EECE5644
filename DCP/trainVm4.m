function [dtc, intervalCap, votingCap] = trainVm4(trainingSet)

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
            results = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
            
            setAccuracy(set) = results.accuracy;
        end
        
        %Store the results of each iteration
        accuracyResults = [accuracyResults, mean(setAccuracy)];
        dtcs = [dtcs dtc];
    end

    [~, dtcIdx] = max(accuracyResults);
    dtc = dtcs(dtcIdx);
    dtc = oldDtc+(dtc-oldDtc)*(stepPercent)
    
    [m, freq] = mode(training_set{1}.labels);
    temp = mode(training_set{1}.labels(training_set{1}.labels ~= m));
    [m2, freq2] = mode(temp);
    votingCapAccuracy = [];
    votingCaps = [];
    
    oldVotingCap = votingCap;
    
    for votingCap = max(min(oldVotingCap,freq/freq2)-(freq/freq2)*windowTail,1):(precision*freq/freq2):min(oldVotingCap+(freq/freq2)*windowTail,(freq/freq2))
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
            results = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
            
            setAccuracy(set) = results.accuracy;
        end
        
        votingCapAccuracy = [votingCapAccuracy, mean(setAccuracy)];
        votingCaps = [votingCaps, votingCap];
        
    end
    [~, index] = max(votingCapAccuracy);
    votingCap = votingCaps(index);
    votingCap = oldVotingCap+(votingCap-oldVotingCap)*(stepPercent)
    
    intervalCaps = [];
    intervalCapAccuracy = [];
    
    oldIntervalCap = intervalCap;
    
    for intervalCap = max(oldIntervalCap-windowTail,0):precision:min(oldIntervalCap+windowTail,1)
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
            results = vm4(validate,guess, numAttributes,training_set, intervalCap, votingCap);
            
            setAccuracy(set) = results.accuracy;
        end
        
        intervalCapAccuracy = [intervalCapAccuracy, mean(setAccuracy)];
        intervalCaps = [intervalCaps, intervalCap];
        
    end
    
    [~, index] = max(intervalCapAccuracy);
    intervalCap = intervalCaps(index);
    intervalCap = oldIntervalCap+(intervalCap-oldIntervalCap)*(stepPercent)
    
end
    
end