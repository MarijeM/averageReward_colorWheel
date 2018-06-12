% numSetsize: maximum numbers of squares/color to remember on a given trial
% trialsPerSZ: how many trials per set size do you want to prespecify?
% numCounter: how many observations per cell (i.e. how many observations
%   per color set, counterbalanced over hemisphere and condition, where we
%   have 2 hemispheres, and 2 conditions (update and ignore). So numCounter
%   has a minimum of 4: 1 observation for update-left, 1 for update-right,
%   1 for ignore-left, 1 for ignore-right).
%   pieColors: the number of possible subcolors per color pie.  
%   Also defines wheelstarts for the predefined stimuli

numSetsize  = 4;
trialsPerSZ = 160;
numCounter  = 4;
pieColors   = 15; 

for n=1:numSetsize
    
%% assign location
    locLeft=[1 4];
    locRight=[2 3];
    location = [];
    
    switch n
    case 1
        location=repmat(1:4,4,trialsPerSZ/16); location=location(:);
    case 2
        location(1,:)=[locLeft(1),locRight(1)];
        location(2,:)=[location(1,2) location(1,1)];  
        location(3,:)=[locLeft(1),locRight(2)];
        location(4,:)=[location(3,2) location(3,1)];  
        location(5,:)=[locLeft(2),locRight(1)];
        location(6,:)=[location(5,2) location(5,1)];  
        location(7,:)=[locLeft(2),locRight(2)];
        location(8,:)=[location(7,2) location(7,1)];  
        location = location(repmat(1:size(location,1),numCounter,1),:);
        location = repmat(location,ceil(trialsPerSZ/size(location,1)),1);      
        location([trialsPerSZ+1:end],:) = [];    
    case 3
        location = [1 2 3; 2 1 4; 3 2 4; 4 1 3; 1 2 4; 2 1 3; 3 1 2; 4 2 3; 1 3 4; 2 3 4; 3 1 4; 4 1 2];  
        location = location(repmat(1:size(location,1),4,ceil(trialsPerSZ/46)),:);   
        location([trialsPerSZ+1:end],:) = [];    
    case 4
        location = [1 2 3 4; 2 1 3 4; 3 1 2 4; 4 1 2 3];
        location = location(repmat(1:size(location,1),numCounter,1),:);
        location = repmat(location,trialsPerSZ/size(location,1),1);
    end 
    probelocation = location(:,1);

%% assign colors 
    colors = zeros(trialsPerSZ,2);
    for iteration = [1:trialsPerSZ/numCounter]
            Colors = randsample([1:12],n*2); 
            Colors = repmat(Colors,2,1);
            Colors2(:,1:size(Colors,2)/2) = Colors(:,size(Colors,2)/2+1:size(Colors,2));
            Colors2(:,size(Colors,2)/2+1:size(Colors,2)) = Colors(:,1:size(Colors,2)/2);
            allColors = [Colors;Colors2];
            colors(((iteration-1)*4+1):(iteration*4),1:n*2) = allColors;
    end
    odd = [1:2:trialsPerSZ];
    even = [2:2:trialsPerSZ];
    probecolor(odd,1) = colors(odd,1);
    probecolor(even,1) = colors(even,n+1);
    
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

%% assign cue ("it will likely be update/ignore") and validity of cue (indeed update/ignore). valid = 1, invalid = 0. 
cues = zeros(trialsPerSZ,1);  % set all trials to default valid (=0)
even = [2:2:length(cues)];
odd = [1:2:length(cues)];
cues(even) = 2; % set all update trials to default valid (=2)
n_valid = round(0.75*trialsPerSZ/length(conditions));     
n_invalid = trialsPerSZ/length(conditions)-n_valid;
cues(odd([1:2:n_invalid*2])) = 2; % every second ignore trial in de condition vector (specified above) will get an invalid cue (update cue) up to 16 invalid cues (every second to stick to the counterbalancing)
cues(even([2:2:n_invalid*2])) = 0; % every second updade trial in de condition vector will get an invalid cue
valid = zeros(trialsPerSZ,1); 
valid(find(cues==0 & cond==0 | cues==2 & cond==2)) = 1;


    
%% put everything together
    predefinedStimuli.setSize       = repmat(n,trialsPerSZ,1);
    predefinedStimuli.type          = cond;
    predefinedStimuli.locNums       = location;
    predefinedStimuli.probelocation = probelocation;
    predefinedStimuli.cols          = colors;
    predefinedStimuli.probecolor    = probecolor;
    predefinedStimuli.wheelValues   = wheelValues;
    predefinedStimuli.colIndex      = colorIndex;
    predefinedStimuli.cue           = cues;
    predefinedStimuli.valid         = valid;
      
    fields = fieldnames(predefinedStimuli);
    for x = 1:size(predefinedStimuli.setSize ,1)
       for field = 1:numel(fields)
          Stimuli(x,1).(fields{field}) = predefinedStimuli.(fields{field})(x,:);
       end        
    end
    
    filename = sprintf('Stimuli_%d.mat', n);
    save(filename,'Stimuli');

%% Divide stimuli into blocks
%     % 6 blocks in total, 2 50/50, 2 majority ignore, 2 majority update
% 
%     a = reshape(Stimuli, 4, size(Stimuli,1)/4);
%     %neutral blocks
%     block1 = [a(1,[1:16]),a(4,[1:16])]';
%     block4 = [a(2,[1:16]),a(3,[1:16])]';
%     %majority ignore blocks
%     block2 = [a(1,[17:40]),a(4,[17:24])]';
%     block5 = [a(2,[17:24]),a(3,[17:40])]';
%     %majority update blocks
%     block3 = [a(1,[41:48]),a(4,[25:48])]';
%     block6 = [a(2,[25:48]),a(3,[41:48])]';
%     
%     blocks = struct('block1', block1, 'block2', block2, 'block3', block3, 'block4', block4, 'block5', block5, 'block6', block6);
% 
%     filename = sprintf('trialsPerBlock_%d.mat', n);
%     save(filename,'blocks');

    % 3 blocks in total, 2 50/50, 2 majority ignore, 2 majority update

    a = reshape(Stimuli, 4, size(Stimuli,1)/4);
    %neutral blocks
    block1 = [a(:,1:30)]; block1 = block1(:);
    %majority ignore blocks
    block2 = [a([1,3],[1:40]),a([2,4],[1:20])]; block2 = block2(:);
    %majority update blocks
    block3 = [a([1,3],[1:20]),a([2,4],[1:40])]; block3 = block3(:);
    
    blocks = struct('block1', block1, 'block2', block2, 'block3', block3);

    filename = sprintf('trialsPerBlock_%d.mat', n);
    save(filename,'blocks');

end



