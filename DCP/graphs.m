numAttributes = 10; 
intervalColors = {'blue', 'red', 'green'};
for k = 1:numAttributes
    zero = zeros(size(training_set{k}.x,1)); 
    fig = figure('Position',[500 100 500 100]);
    hax = axes;
    set(gca,'YTickLabel',[]);

    hold on;
    plot(training_set{k}.x, zero, 'ko')
     for i = 1:size(training_set{k}.intervals,1)
         for j = 1:size(training_set{k}.intervals,2)
             l = line([training_set{k}.intervals(i,j) training_set{k}.intervals(i,j)],[-.01 .01] , get(hax,'YLim'),'Color','black')
         end
        label(l,  num2str(training_set{k}.intervalClasses(i)))
         diff = training_set{k}.intervals(i,j)  - training_set{k}.intervals(i,j-1);
         rectangle('Position', [training_set{k}.intervals(i,j-1), -.01, diff, .02  ] ,'FaceColor',intervalColors{training_set{k}.intervalClasses(i)})
%  
     end
    xlabel(['Unique Values of Attribute ', num2str(k)])
    title(['Intervals for Attribute', num2str(k)])
    %str = {'Class 1 : blue, Class 2:red'}
    %annotation('textbox', [.65 .51 .5 .5], 'String', str, 'FitBoxToText', 'on');
end

numClasses = 3; 
names = fieldnames(training_set{1}.xCounts); 
for k = 1:numAttributes 
    figure; 
    hold on; 
    for i = 1:numClasses 
        bar([training_set{k}.xCounts.(names{i})])
    end 
    legend('Class 1', 'Class2', 'Class 3')
    title(['Number of Points Per Class Per Unique Value For Attribute', num2str(k)] )
    ylabel('Number of Points')
    %xlabel(['Unique Value for attribute' + num2str(k)])
   % xticks([training_set{k}.x])
    

    
end 


