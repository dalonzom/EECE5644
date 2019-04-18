% Guess which class the data point belongs to 
function [guess] = guessClasses(point, numAttributes, training_set) 

% Currently supports up to 10 different attributes 
attributes = {'one', 0,'two', 0,'three',0, 'four',0, 'five',0, 'six',0, 'seven',0, 'eight',0, 'nine',0,'ten',0}; 
intervals = {'interval1', 0,'interval2',0, 'interval3',0, 'interval4',0, 'interval5',0, 'interval6',0, 'interval7',0, ...
    'interval8',0, 'interval9',0, 'interval10',0}; 

guess = struct(attributes{1:numAttributes*2}, intervals{1:numAttributes*2}); 
names = fieldnames(guess); 
for j = 1:numAttributes
    for i = 1:size(training_set{j}.intervals,1)
        if training_set{j}.intervals(i,1) <= point(j) && training_set{j}.intervals(i,2) >= point(j)
            guess.(names{j}) = training_set{j}.intervalClasses(i); 
            guess.(names{j+numAttributes}) = i; 
        end 
    end 
end 
end 