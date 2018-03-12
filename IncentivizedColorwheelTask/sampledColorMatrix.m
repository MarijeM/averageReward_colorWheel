function [sampledColors,pie]=sampledColorMatrix(pms,varargin)
%%function that creates a sampled colormatrix for the QuantifyingCC memory
%%task, so that different squares have colors that are distinct (enough).
% There are three versions of sampled colors. 
% Version 1 randomly picks one color and then the rest are picked stepwise. 
% We end up with 360/step equally spaced colors. 
% Version 2 splits the colorwheel in color categories (pies) 
% and then selects the middle color of each pie and two colors around the middle (3 colors per pie). 
% The last step creates a structure with the color categories (pie) and keeps colPerPie colors from
% the middle of each category. This version is used for the defined
% stimuli, the other two can be used for practice or a version of the task with random colors.

colormatrix=hsv(pms.numWheelColors)*255;
%how many colors we want to keep per color category
colPerPie=15;

%% sampledColors version 1
%sample every step degrees
step=30;
stepS=floor(pms.numWheelColors/(360/step)); %MF: stepS is stepSample? Or where does S stand for?
%select one color randomly
index1=randi(pms.numWheelColors,1);
%create equally spaced samples
samples=0:stepS:pms.numWheelColors-stepS;
%add the random index to the samples and use mod() when it exceeds max colors
indices=samples+index1;
for n=1:length(indices)
    if indices(n)>pms.numWheelColors
        indices(n)=mod(indices(n),pms.numWheelColors);
    end
end

%sample the randomly selected equally spaced colors
sampledColors=colormatrix(indices,:);

%% sampled Colors version 2(?)
%%Middle is the middle of all (12) pies. We sample 1 color from each smaller pie that surrounds the middle
%for the first sampling (around 0-red) it samples one color between 0-maxPie/2 or
%512-maxPie/2-512.

numPies=12;
stepS=floor(length(colormatrix)/numPies);
middle=0:stepS:512;
sampledColors=zeros(length(middle)-1,3); 
maxPie=20; %the degree to which it is allowed to vary; 30 would be whole pie, here exclude 5 degrees border right?

for x=1:length(middle)-1
    if x==1
        colormatrix=[colormatrix(1:maxPie/2,:);colormatrix((length(colormatrix)-maxPie/2):end,:)];
        sampledColors(x,:)=datasample(colormatrix,1);
    else
        colormatrix=hsv(512)*255;
        sampledColors(x,:)=datasample(colormatrix((middle(x)-maxPie/2):(middle(x)+maxPie/2),:),1);
    end 
end

pie.color=struct;
K=round(stepS/2):stepS:pms.numWheelColors;
pie(1).color=[colormatrix((pms.numWheelColors-stepS/2):pms.numWheelColors,:);colormatrix(1:stepS/2,:)];
for N=2:numPies
   pie(N).color=colormatrix(K(N-1):K(N),:);
end

names={'red','orange','yellow','light green','green','blue green','turquoise','cyan','blue','purple','pink','magenta'};

for i=1:length(pie)
    pie(i).color=wkeep(pie(i).color,[colPerPie,3]);
    pie(i).name=names{i};
    pie(i).number=i;
end
