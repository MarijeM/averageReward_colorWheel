function [trials]=defstruct(pms,rect)
%%function that creates the trials structure for the predefined stimuli. 
% trials.mat matrix is created in sampleStimuli.m. It contains locations and
% colors numerically coded(colors 1:12, referring to pie of colorwheel; locations 1:4 for 4 locations).
% --> Here the actual colors and locations are added.

% SYNTAX 
% 
% [trials]=DEFSTRUCT(pms,rect)
% 
% trials:       structure that contains all information required to present the stimuli for the colorwheel task
% pms:         parameters defined in main script
% rect:        dimensions of Screen provided by PTB in main script
% 
% subfunction called: [~,pie]=sampledColorMatrix(pms). 
% Pie is a struct with 12 color categories (pies) as fields, each pie contains colPerPie colors.

% matrix created in [trials]=sampleStimuli and saved so that all participants
% see same stimuli
 
filename = sprintf('trialsPerBlock_%d.mat', pms.maxSetsize);        
load(filename); 
trial = [];

%loop over block and randomize block order, where the same block types (neutral, majority
%ignore, majority update) can never follow each other directly. 
dif = 1;
while dif==1
    blockOrder = [randsample(pms.numBlocks, pms.numBlocks)]';
    if any(find(abs(diff(blockOrder))==3))
        dif = 1;
    else
        dif = 0;
    end
end

% the square locations are created as fraction of rect (screen size), 
% so that screen size differences are irrelevant. 
xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]'; %the locations go clockwise L->R       1  2
locationmatrix=zeros(size(xyindex,1),size(xyindex,2));                                                                                %  4  3
[~,pie]=sampledColorMatrix(pms);

% locationmatrix
for r=1:length(locationmatrix)
    locationmatrix(r,1)=(rect(3)*xyindex(r,1));
    locationmatrix(r,2)=(rect(4)*xyindex(r,2));
end

block = 1;
for b = blockOrder
    field = sprintf('block%d', b);
    trials = blocks.(field)

    for j=1:pms.numTrials %create new fields in trial-struct
        trials(j,1).colors=[];
        trials(j,1).locations=[];
        trials(j,1).probeColorCorrect=[];
        trials(j,1).block=block;
    end

%% sample colors
    for x=1:size(trials,1) %numtrialss (total)
        for n=1:numel(trials(x,1).cols) %1: max number of colors per trials (colors per trials are setSize*2)
            for k = trials(x,1).cols %for each color catergory per trials eg k=[4 5 2 7]
                if trials(x,1).cols(n)==k 
                    trials(x,1).colors=[trials(x,1).colors; pie(k).color(trials(x,1).colIndex,:)]; %get color in pie based on random predefined index            
                end %if trials(x,y).colPie(n)==k
            end %if k=trials(x,y).colPie
        end %for n=1:numel(trials(x,y).colPie)
        
%% sample locations        
        for j=1:numel(trials(x,1).locNums) %for 1: max number of locations
            for m=trials(x,1).locNums % for each location per trials
                if trials(x,1).locNums(j)==m % if specific position of locations equals the location
                    trials(x,1).locations=[trials(x,1).locations;locationmatrix(m,:)]; %add its coordinates to locations
                  
                    if m==trials(x,1).probelocation %if this is the probed square
                        trials(x,1).probeLoc=trials(x,1).locations(j,:); 
                    end
                end
            end 
        end
 
 %% to make analysis easier, create fields with the color of every square location per trials
%  trials.encColLoc1:4 represents the color of the square in location 1:4. 1 is the location top left
%  and they continue clockwise. If the location does not exist for this trials, the field remains empty. 

          for j=1:numel(trials(x,1).locNums) %for 1: max number of locations
            for m=trials(x,1).locNums % for each location per trials
                if trials(x,1).locNums(j)==m % if specific position of locations equals the location      
                     switch m
                            case 1
                                trials(x,1).encColLoc1=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc1=trials(x,1).colors(trials(x,1).setsize+j,:);
                            case 2
                                trials(x,1).encColLoc2=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc2=trials(x,1).colors(trials(x,1).setsize+j,:);
                            case 3
                                trials(x,1).encColLoc3=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc3=trials(x,1).colors(trials(x,1).setsize+j,:);
                            case 4
                                trials(x,1).encColLoc4=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc4=trials(x,1).colors(trials(x,1).setsize+j,:);  
                     end 
                end
            end
          end
              switch trials(x,1).type
                case 0   %for Ignore
                    %for Ignore trialss the correct color is shown during
                    %encoding and is always the one first in the list of colors in
                    %trials struct, as it was inserted in that way from the excel file.
                    trials(x,1).probeColorCorrect=trials(x,1).colors(1,:);
                    %lure is the color on the same location during
                    %Interference. It is always the first of the intervening
                    %stimuli, so setSize+1. 
                    trials(x,1).lureColor=trials(x,1).colors(trials(x,1).setsize+1,:);

                case 2    %for Update 
                    %reverse for Update; lure in update is the stimulus at same location during encoding.
                    trials(x,1).probeColorCorrect=trials(x,1).colors(trials(x,1).setsize+1,:); 
                    trials(x,1).lureColor=trials(x,1).colors(1,:);
              end

    end %for x=1:size(trials,1)
    
    %% randomize trials in this block
    trialRandomizing = trials;
    rows = size(trials,1); 
    r = 1;
    for i = randperm(rows)
        trials(r,1) = trialRandomizing(i,1);
        r = r+1;
    end
    
    %% assign reward (gaussian random walk)
    
    
    %% combine blocks  
    trial = [trial, trials];

    block = block+1;
end %for b = blockOrder 
end %function

                

