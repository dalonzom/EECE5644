%% Train DCP algorithm 
function [s] = training(dataset, labels)

s = struct;
s.labels = labels;
%Find unique vales
s.x = sort(unique(dataset));
hold = [];
%Find which classes the unique values are associated with
for i = 1:size(s.x)
    labels = struct;
    labels.class1 = 0;
    labels.class2 = 0;
    labels.class3 = 0;
    temp  = find(dataset == s.x(i));
    for j = 1:size(temp)
        if(s.labels(temp(j)) == 1)
            labels.class1 = labels.class1 + 1;
        end
        if(s.labels(temp(j)) == 2)
            labels.class2 = labels.class2 + 1;
        end
        if(s.labels(temp(j)) == 3)
            labels.class3 = labels.class3 + 1;
        end
    end
    hold = [hold; labels]; 
end
s.xCounts = hold;

%Calculate the dominant class
allCounts = [s.xCounts.class1; s.xCounts.class2; s.xCounts.class3];
[~, s.DominantClass] = max(allCounts);
s.DominantClass = s.DominantClass';

%Calculate Intervals - Length Threshold issue?
intervals = [];
i = 1;
j = 1;
iteration = size(s.DominantClass,1);
classes = [];
class1Counts = 0;
class2Counts = 0;
class3Counts = 0;
intervalCounts = [];
while i <= iteration
    val1 = s.x(j);
    % Count how many instances of each class are in the interval 
    class1Counts = class1Counts + s.xCounts(i).class1;
    class2Counts = class2Counts + s.xCounts(i).class2;
    class3Counts = class3Counts + s.xCounts(i).class3;
    if ((i ~= 1 && s.DominantClass(i) ~= s.DominantClass(i-1)) || i == iteration)
        class1Counts = class1Counts - s.xCounts(i).class1;
        class2Counts = class2Counts - s.xCounts(i).class2;
        class3Counts = class3Counts - s.xCounts(i).class3; 
        val2 = s.x(i);
        intervals = [intervals; [val1, val2]];
        classes = [classes, s.DominantClass(i-1)];
        intervalCounts = [intervalCounts; [class1Counts, class2Counts, class3Counts]];
        class1Counts = 0;
        class2Counts = 0;
        class3Counts = 0;
        j = i +1;
    end
    i = i+1;
end
s.intervals = intervals;
s.intervalClasses = classes;
s.intervalCounts = intervalCounts;




