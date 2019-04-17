% Guess which class the data point belongs to 
function [guess] = guessClasses(point, numAttributes, training_set) 

% Must be modified for different number of attributes
guess = struct('one',0, 'two',0,'three',0,'four',0, 'interval1',0, 'interval2',0, 'interval3',0, 'interval4',0); 
names = fieldnames(guess); 
for j = 1:numAttributes
    for i = 1:size(training_set{j}.intervals,1)
        if training_set{j}.intervals(i,1) <= point(j) && training_set{j}.intervals(i,2) >= point(j)
            guess.(names{j}) = training_set{j}.intervalClasses(i); 
            guess.(names{j+4}) = i; 
        end 
    end 
end 
end 