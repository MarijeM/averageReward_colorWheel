function [trial]=defstruct(pms,rect)
%%function that creates the trial structure for the predefined stimuli. 
% trial.mat matrix is created in sampleStimuli.m. It contains locations and
% colors numerically coded(colors 1:12, referring to pie of colorwheel; locations 1:4 for 4 locations).
% --> Here the actual colors and locations are added.

% SYNTAX 
% 
% [trial]=DEFSTRUCT(pms,rect)
% 
% trial:       structure that contains all information required to present the stimuli for the colorwheel task
% pms:         parameters defined in main script
% rect:        dimensions of Screen provided by PTB in main script
% 
% subfunction called: [~,pie]=sampledColorMatrix(pms). 
% Pie is a struct with 12 color categories (pies) as fields, each pie contains colPerPie colors.

% matrix created in [trial]=sampleStimuli and saved so that all participants
% see same stimuli
 
filename = sprintf('trialsPerBlock_%d.mat', pms.maxSetsize);        
load filename; 

%randomize block order, where the same block types (neutral, majority
%ignore, majority update) can never follow each other directly. 

% the square locations are created as fraction of rect (screen size), 
% so that screen size differences are irrelevant. 

xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]'; %the locations go clockwise L->R       1  2
locationmatrix=zeros(size(xyindex,1),size(xyindex,2));
                                                                                  %  4  3
[~,pie]=sampledColorMatrix(pms);

% locationmatrix
for r=1:length(locationmatrix)
    locationmatrix(r,1)=(rect(3)*xyindex(r,1));
    locationmatrix(r,2)=(rect(4)*xyindex(r,2));
end

for i=1:pms.numBlocks
    for j=1:pms.numTrials
        trial(j,i).colors=[];
        trial(j,i).locations=[];
        trial(j,i).probeColorCorrect=[];
    end
end

%% sample colors
for y=1:size(trial,2) %numblocks
    for x=1:size(trial,1) %numtrials (total)
        for n=1:numel(trial(x,y).colPie) %1: max number of colors per trial (colors per trial are setSize*2)
            for k=trial(x,y).colPie %for each color catergory per trial eg k=[4 5 2 7]
                if trial(x,y).colPie(n)==k 
                    trial(x,y).colors=[trial(x,y).colors; pie(k).color(trial(x,y).colIndex,:)]; %get color in pie based on random predefined index            
                end %if trial(x,y).colPie(n)==k
            end %if k=trial(x,y).colPie
        end %for n=1:numel(trial(x,y).colPie)
        
%% sample locations        
        for j=1:numel(trial(x,y).locNum) %for 1: max number of locations
            for m=trial(x,y).locNum % for each location per trial
                if trial(x,y).locNum(j)==m % if specific position of locations equals the location
                    trial(x,y).locations=[trial(x,y).locations;locationmatrix(m,:)]; %add its coordinates to locations
                  
                    if m==trial(x,y).probeLocNum %if this is the probed square
                        trial(x,y).probeLoc=trial(x,y).locations(j,:); 
                    end
                end
            end 
        end
 
 %% to make analysis easier, create fields with the color of every square location per trial
%  trial.encColLoc1:4 represents the color of the square in location 1:4. 1 is the location top left
%  and they continue clockwise. If the location does not exist for this trial, the field remains empty. 

          for j=1:numel(trial(x,y).locNum) %for 1: max number of locations
            for m=trial(x,y).locNum % for each location per trial
                if trial(x,y).locNum(j)==m % if specific position of locations equals the location      
                     switch m
                            case 1
                                trial(x,y).encColLoc1=trial(x,y).colors(j,:);
                                trial(x,y).interColLoc1=trial(x,y).colors(trial(x,y).setSize+j,:);
                            case 2
                                trial(x,y).encColLoc2=trial(x,y).colors(j,:);
                                trial(x,y).interColLoc2=trial(x,y).colors(trial(x,y).setSize+j,:);
                            case 3
                                trial(x,y).encColLoc3=trial(x,y).colors(j,:);
                                trial(x,y).interColLoc3=trial(x,y).colors(trial(x,y).setSize+j,:);
                            case 4
                                trial(x,y).encColLoc4=trial(x,y).colors(j,:);
                                trial(x,y).interColLoc4=trial(x,y).colors(trial(x,y).setSize+j,:);  
                     end 
                end
            end
          end
              switch trial(x,y).type
                case 0   %for Ignore
                    %for Ignore trials the correct color is shown during
                    %encoding and is always the one first in the list of colors in
                    %trial struct, as it was inserted in that way from the excel file.
                    trial(x,y).probeColorCorrect=trial(x,y).colors(1,:);
                    %lure is the color on the same location during
                    %Interference. It is always the first of the intervening
                    %stimuli, so setSize+1. 
                    trial(x,y).lureColor=trial(x,y).colors(trial(x,y).setSize+1,:);

                case 2    %for Update and Update Long
                    %reverse for Update; lure in update is the stimulus at same location during encoding.
                    trial(x,y).probeColorCorrect=trial(x,y).colors(trial(x,y).setSize+1,:); 
                    trial(x,y).lureColor=trial(x,y).colors(1,:);
              end

    end %for x=1:size(trial,1)
end %fpr y=1:size(trial,2)
 
 %% Nieuwe manier trial:
 trial1=trial(1:32,:);
 trial2=trial(33:64,:);
  
 %verdubbel(D1en2)trial1 en trial2
 trial1D1=trial1;
 trial1D2=trial1;
 trial2D1=trial2;
 trial2D2=trial2;
 
 rewardLow=0.01;
 rewardHigh=0.1;
 
 %preallocate .reward field
 for i=1:32
     trial1D1(i,1).reward=[];
     trial1D2(i,1).reward=[];
     trial2D1(i,1).reward=[];
     trial2D2(i,1).reward=[];
 end
 
% voeg rewards toe aan trial1
 for j=1:32
     trial1D1(j,1).reward=rewardLow;
     trial1D2(j,1).reward=rewardHigh;
 end
 
 %voeg rewards toe aan trial2
 for h=1:32
     trial2D1(h,1).reward=rewardLow;
     trial2D2(h,1).reward=rewardHigh;
 end
 
%voeg trial1D1/2 en trial2D1/2 samen
trial1=[trial1D1; trial1D2];
trial2=[trial2D1; trial2D2];

% first, replicate trial1 en trial2 zodat randomizen niks overschrijft.
trial1extra=trial1;
trial2extra=trial2;

% randomize trial 1
sizetrial1=size(trial1);
rows=sizetrial1(1); 
RandVector=randperm(rows);

    for i = 1:rows
        h=RandVector(i);
        trial1(i,1)=trial1extra(h,1);
    end

% randomize trial 2
sizetrial2=size(trial2);
rows=sizetrial2(1); 
RandVector=randperm(rows);

    for i = 1:rows
        h=RandVector(i);
        trial2(i,1)=trial2extra(h,1);
    end

%maak trial weer compleet
trial=[trial1,trial2]; 

pms.numBlocks=2;                     % 2 blocks of 64 after reshaping

end %function

                

