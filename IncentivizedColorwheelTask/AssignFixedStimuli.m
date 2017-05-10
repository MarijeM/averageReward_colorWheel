function AssignFixedStimuli(numSetsize,trialsPerSZ,numCounter,pieColors,varargin)
%assings wheelstarts for the predifined stimuli

switch nargin
    case 4
        excelFileName='predifinedStimuliBetter.xls';
    case 5
        excelFileName=varargin{1};
end

%each shete contains trials for one set size
for n=1:numSetsize
  

%% assign set size
  xlswrite(excelFileName,n,n,'B2:B33')
  
% %% assign location
% locLeft=[1 4];
% locRight=[2 3];
% 
% switch n
%     case 1
%         location=repmat(1:numSetsize,trialsPerSZ/(numCounter+numSetsize)); location=location(:);
%     case 2
%         location(1,:)=[locLeft(1),locRight(1)];
%         location(2,:)=[locLeft(1),locRight(2)];
%         location(3,:)=[locLeft(2),locRight(1)];
%         location(4,:)=[locLeft(2),locRight(2)];
%         location(5:8,:)=[location(1:4,2) location(1:4,1)];  
%         location = location(repmat(1:size(location,1),numCounter,1),:);
%     case 3
%         
%% assign wheel start values in excel file

wheelValues=zeros(numCounter,trialsPerSZ/numCounter);

for i=1:trialsPerSZ/numCounter       
    wheelValues(1:numCounter,i)=randsample(360,1);
end

wheelValues=wheelValues(:);

%% assign color index
colorIndex=zeros(numCounter,trialsPerSZ/numCounter);

for i=1:trialsPerSZ/numCounter       
    colorIndex(1:numCounter,i)=randsample(pieColors,1);
end

colorIndex=colorIndex(:);
%% assign condition
conditions=[0;2];
cond=repmat(conditions,trialsPerSZ/length(conditions),1);

%% assign delay 1
delays=[2;6];
delay1=repmat(delays,length(delays),trialsPerSZ/numCounter);delay1=delay1(:);delay1=kron(delay1,[1;1]);
delay2=repmat(flipud(delays),length(delays),trialsPerSZ/numCounter);delay2=delay2(:);delay2=kron(delay2,[1;1]);

%% assign color pie
colPies=1:12;
numColorsProbed=trialsPerSZ/(numCounter/length(conditions));
switch n
    case 1
        
        

xlswrite(excelFileName,delay1,n,'I2:I33')
xlswrite(excelFileName,delay2,n,'J2:J33')
xlswrite(excelFileName,cond,n,'E2:E33')
xlswrite(excelFileName,wheelValues,n,'K2:K33')
xlswrite(excelFileName,colorIndex,n,'L2:L33')

end
end


