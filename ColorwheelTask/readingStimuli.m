function [sz1 sz2 sz3 sz4]=readingStimuli(varargin)
%% reads the predifined stimuli for the colorwheel memory task from the excel file
%and converts them into usable form. As output it gives 4 structs, 1 per
%setsize with type, colors, location, probe, delay 1&2 features. The
%stimuli are defined in an excel file, each shete of which represents a
%different set size (1:4). For every shete 64 trials of each set size are
%defined. The locations of the stimuli are represented with numbers (1:4),
%starting from the top left location and going clockwise.The colors are 
%defined with 12 numbers each of which represents a color category on the
%colorwheel:'red','orange','yellow','light green','green','blue green',
%'turquoise','cyan','blue','purple','pink','magenda'. The condition is
%either Update (2), Update Long (Update with longer delay 2, (22)) and Ignore (0).
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

switch nargin
    case 0
        numShetes=4;
        numPerSZ=32;
        numBlocks=4;
    case 1
        numShetes=varargin{1};
        numPerSZ=32;
        numBlocks=4;
    case 2
        numShetes=varargin{1};
        numPerSZ=varargin{2};
        numBlocks=4;
    case 3
        numShetes=varargin{1};
        numPerSZ=varargin{2};
        numBlocks=varargin{3};
end

filename='predifinedStimuliBetter.xls';
for sheet=1:numShetes %excel sheets
%reads stimuli from excel    
    [num,~,raw]=xlsread(filename,sheet);
%Raw provides the data in a cell form and num in mat form. The excel
%cells that contain more than one elements are read with raw. The first raw
%is then skipped because it includes the title. 
    col=raw(2:numPerSZ+1,4); %colors for all squares
    probeLoc=num(1:numPerSZ,7); %location for probed square
    loc=raw(2:numPerSZ+1,3);   %locations for all squares
    type=num(1:numPerSZ,5);     % which condition; 0 = ignore; 22 = updateLong; 2=Update short
    probeColorCorrect=num(1:numPerSZ,6); % correct response color
    setSize=num(1:numPerSZ,2);        % setsize (1:4)
    delay1=num(1:numPerSZ,9);   %delay 1 duration
    delay2=num(1:numPerSZ,10);  %delay 2 duration
    wheelStart=num(1:numPerSZ,11); %origin of colorwheel 
    colIndex=num(1:numPerSZ,12); %index of color within colorpie
%Clear the variables from previous sheets to not interfere with strsplit function
    clearvars splitCol
    clearvars splitLoc
    
%% Split the separated by comma values 
    for n=1:length(col)
        splitCol(n,:)=strsplit(col{n},',');
        if sheet~=1 %shete 1 contains only 1 location (set size 1)
            splitLoc(n,:)=strsplit(loc{n},',');
        end
    end
    
%% Convert to double    
   matsplitCol=str2double(splitCol);
    
    if sheet~=1 %shete 1 contains only 1 location (set size 1)
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
        eval(sprintf('sz%d(x).delay1=delay1(x,:)',sheet));
        eval(sprintf('sz%d(x).delay2=delay2(x,:)',sheet)); 
        eval(sprintf('sz%d(x).wheelStart=wheelStart(x,:)',sheet));             
        eval(sprintf('sz%d(x).colIndex=colIndex(x,:)',sheet));             

    end
    
end %for sheet 1:4

%save stimuli
save('stimuli','sz1','sz2','sz3','sz4')

end     %function