function [sz1 sz2 sz3 sz4]=readingStimuli(varargin)
%% reads the predefined stimuli for the colorwheel memory task from the excel file
%and converts them into usable form. As output it gives 4 structs, 1 per
%setsize with type, colors, location, probe, delay 1&2 features. The
%stimuli are defined in an excel file, each sheet represents a
%different set size (1:4). For every sheet 64 trials of each set size are
%defined. The locations of the stimuli are represented with numbers (1:4),
%starting from the top left location and going clockwise.The colors are 
%defined with 12 numbers each of which represents a color category on the
%colorwheel:'red','orange','yellow','light green','green','blue green',
%'turquoise','cyan','blue','purple','pink','magenda'. The condition is
%either Update (2) or Ignore (0).
%The location numbers are written in a way so that the first
%always represents the probed location. All colors of each trial for both encoding 
%and interference are in the same cell. The first color represents
%the probed square color during encoding and the set size+1 represents the probed
%square color during interference. If the trial is I the first color is the one 
%they needed to remember, if the trial is U they need to remember the set size+1 color. 
%Every set of stimuli appears 4 times, twice per condition and they include the target color
%once per condition. In that way encoding and interfering stimuli, as well
%as probed stimuli are counterbalanced between the two conditions. The
%location of the probed square is also counterbalanced for all conditions
%and left right hemisphere. 

maxSetsize=varargin{1};
numPerSZ=varargin{2};
numBlocks=varargin{3};


for setsize=1:maxSetsize 
    filename=sprintf('predefinedStimuli_%d.mat',setsize);
    load(filename);

    col                 = predefinedStimuli.colors; %colors for all squares
    probeLoc            = predefinedStimuli.probelocation; %location for probed square
    loc                 = predefinedStimuli.locations;   %locations for all squares
    type                = predefinedStimuli.condition;     % which condition; 0 = ignore; 22 = updateLong; 2=Update short
    probeColorCorrect   = predefinedStimuli.probecolor; % correct response color
    setSize             = predefinedStimuli.setsize;        % setsize (1:4)
    wheelStart          = predefinedStimuli.wheelValues; %origin of colorwheel 
    colIndex            = predefinedStimuli.colorIndex; %index of color within colorpie
    
%% Split the separated by comma values 
    for n=1:length(col)
        splitCol(n,:)=strsplit(col{n},',');
        if sheet~=1 %sheet 1 contains only 1 location (set size 1)
            splitLoc(n,:)=strsplit(loc{n},',');
        end
    end
    
%% Convert to double    
   matsplitCol=str2double(splitCol);
    
    if sheet~=1 %sheet 1 contains only 1 location (set size 1)
        loc=str2double(splitLoc);
    else 
        loc=cell2mat(loc); 
    end
    
%% Create struct variables for all set sizes, each struct has as fields 
%locations and colors of squares, location and color of probed square, set
%size, type(condition) and delay durations.  
    for x=1:length(matsplitCol)
        eval(sprintf('sz%d(x).colPie=matsplitCol(x,:)',sheet));
        eval(sprintf('sz%d(x).type=type(x,:)',sheet));
        eval(sprintf('sz%d(x).probeLocNum=probeLoc(x,:)',sheet));
        eval(sprintf('sz%d(x).probeColNum=probeColorCorrect(x,:)',sheet));
        eval(sprintf('sz%d(x).setSize=setSize(x,:)',sheet));
        eval(sprintf('sz%d(x).locNum=loc(x,:)',sheet));
        eval(sprintf('sz%d(x).wheelStart=wheelStart(x,:)',sheet));             
        eval(sprintf('sz%d(x).colIndex=colIndex(x,:)',sheet));             
    end
    
end %for sheet 1:4

%save stimuli
save('stimuli','sz1','sz2','sz3','sz4')

end     %function