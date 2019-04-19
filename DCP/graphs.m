%numAttributes = 9; 
intervalColors = {'blue', 'red', 'green'};
for k = 1:numAttributes
    fig = figure;
    hax = axes;
    hold on;
    plot(training_set{k}.x, 'ko')
    for i = 1:size(training_set{k}.intervals,1)
        for j = 1:size(training_set{k}.intervals,2)
            l = line([0 size(training_set{k}.x,1)], [training_set{k}.intervals(i,j) training_set{k}.intervals(i,j)], get(hax,'YLim'),'Color','black')
        end
        label(l, ['Dominant Class in Interval = ', num2str(training_set{k}.intervalClasses(i))])
        diff = training_set{k}.intervals(i,j)  - training_set{k}.intervals(i,j-1);
        rectangle('Position', [0, training_set{k}.intervals(i,j-1),size(training_set{k}.x,1),diff  ] ,'FaceColor',intervalColors{training_set{k}.intervalClasses(i)})
 
    end
    ylabel(['Unique Values of Attribute ', num2str(k)])
    title(['Intervals for Attribute', num2str(k)])
    %str = {'Class 1 : blue, Class 2:red'}
    %annotation('textbox', [.65 .51 .5 .5], 'String', str, 'FitBoxToText', 'on');
end
