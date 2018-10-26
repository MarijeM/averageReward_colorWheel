function [trial]=defstruct(pms,rect)
%%function that creates the Stimuli structure for the predefined stimuli. 
% Stimuli.mat matrix is created in sampleStimuli.m. It contains locations and
% colors numerically coded(colors 1:12, referring to pie of colorwheel; locations 1:4 for 4 locations).
% --> Here the actual colors and locations are added.

% SYNTAX 
% 
% [Stimuli]=DEFSTRUCT(pms,rect)
% 
% Stimuli:       structure that contains all information required to present the stimuli for the colorwheel task
% pms:         parameters defined in main script
% rect:        dimensions of Screen provided by PTB in main script
% 
% subfunction called: [~,pie]=sampledColorMatrix(pms). 
% Pie is a struct with 12 color categories (pies) as fields, each pie contains colPerPie colors.

% matrix created in [Stimuli]=sampleStimuli and saved so that all participants
% see same stimuli
 
% add path to load stimuli structs
addpath(fullfile(pms.inccwdir,'Stimuli_structs'));


% loop over block and counterbalance block order for 4 blocks.
if pms.blockCB == 0
    blockOrder = [1 2 3 4]; % Low1, High2, High3, Low4
elseif pms.blockCB == 1
    blockOrder = [2 1 4 3]; % High2, Low1, Low4, High3
end

trials = [];
trialsPerSetsize = round(pms.numTrials/length(pms.maxSetsize));
if pms.shape==0 %squares
    for ss = pms.maxSetsize
        filename = sprintf('Stimuli_%d.mat', ss);        
        load(filename);
        trials = [trials;Stimuli(1:trialsPerSetsize,:)];
    end
    trial = [];                                                                              

    % locationmatrix
    % the square locations are created as fraction of rect (screen size), 
    % so that screen size differences are irrelevant. 
    xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]'; %the locations go clockwise, Left to Right       
    locationmatrix=zeros(size(xyindex,1),size(xyindex,2)); 
    for r=1:length(locationmatrix)
        locationmatrix(r,1)=(rect(3)*xyindex(r,1));
        locationmatrix(r,2)=(rect(4)*xyindex(r,2));
    end
elseif pms.shape==1 %circles
    for ss = pms.maxSetsize
        filename = sprintf('Stimuli_circles_%d.mat', ss);        
        load(filename);
        trials = [trials;Stimuli(1:trialsPerSetsize,:)];
    end
    trial = [];
    
    locationmatrix = [0 0 rect(3)*0.04 rect(3)*0.04; 0 0 rect(3)*0.08 rect(3)*0.08; 0 0 rect(3)*0.12 rect(3)*0.12; 0 0 rect(3)*0.16 rect(3)*0.16]; % circles will be centered in middle of screen
end

[~,pie]=sampledColorMatrix(pms);

for b = blockOrder
    for j=1:pms.numTrials %create new fields in trial-struct
        trials(j,1).colors=[];
        trials(j,1).locations=[];
        trials(j,1).probeColorCorrect=[];
        trials(j,1).block=b;
    end

%% sample colors
    for x=1:size(trials,1) %numtrialss (total)
        for n=1:numel(trials(x,1).cols) %1: max number of colors per Stimuli (colors per Stimuli are setSize*2)
            for k = trials(x,1).cols %for each color catergory per Stimuli eg k=[4 5 2 7]
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
 
 %% to make analysis easier, create fields with the color of every square location per Stimuli
%  Stimuli.encColLoc1:4 represents the color of the square in location 1:4. 1 is the location top left
%  and they continue clockwise. If the location does not exist for this Stimuli, the field remains empty. 

          for j=1:numel(trials(x,1).locNums) %for 1: max number of locations
            for m=trials(x,1).locNums % for each location per trials
                if trials(x,1).locNums(j)==m % if specific position of locations equals the location      
                     switch m
                            case 1
                                trials(x,1).encColLoc1=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc1=trials(x,1).colors(trials(x,1).setSize+j,:);
                            case 2
                                trials(x,1).encColLoc2=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc2=trials(x,1).colors(trials(x,1).setSize+j,:);
                            case 3
                                trials(x,1).encColLoc3=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc3=trials(x,1).colors(trials(x,1).setSize+j,:);
                            case 4
                                trials(x,1).encColLoc4=trials(x,1).colors(j,:);
                                trials(x,1).interColLoc4=trials(x,1).colors(trials(x,1).setSize+j,:);  
                     end 
                end
            end
          end
              switch trials(x,1).type
                case 0   %for Ignore
                    %for Ignore Stimulis the correct color is shown during
                    %encoding and is always the one first in the list of colors in
                    %Stimuli struct, as it was inserted in that way from the excel file.
                    trials(x,1).probeColorCorrect=trials(x,1).colors(1,:);
                    %lure is the color on the same location during
                    %Interference. It is always the first of the intervening
                    %stimuli, so setSize+1. 
                    trials(x,1).lureColor=trials(x,1).colors(trials(x,1).setSize+1,:);

                case 2    %for Update 
                    %reverse for Update; lure in update is the stimulus at same location during encoding.
                    trials(x,1).probeColorCorrect=trials(x,1).colors(trials(x,1).setSize+1,:); 
                    trials(x,1).lureColor=trials(x,1).colors(1,:);
              end


    %% assign rewards on offer
        if b==1 || b==4 % low reward context
            trials(x,1).offer = 10;
        elseif b==2 || b==3 % high reward context
            trials(x,1).offer = 40;
        end
        
        %if b==1 && pms.blockCB==0 || b==2 && pms.blockCB==1
            %trials(x,1).offer = 0;
        %elseif b==2 && pms.blockCB==0 || b==1 && pms.blockCB==1
            %trials(x,1).offer = 50;
                 %in 25% of the cases, no points are offered
            %if (mod(x,4)==1 || mod(x,4)==0) && mod(x,trialsPerSetsize)<= trialsPerSetsize/length(pms.maxSetsize) && mod(x,trialsPerSetsize)~= 0 
               %trials(x,1).offer = 0; 
            %end
        %end 
    end %for x=1:size(trials,1)

    
    %% randomize trials in this block
    trialRandomizing = trials;
    rows = size(trials,1); 
    %first8rewarded = 0;
    
    % In the rewarded context, I want to make the first 8 trials rewarded,
    % such that people really have the notion of being rewarded.
    %while first8rewarded==0
        r = 1; 
        for i = randperm(rows)
            trials(r,1) = trialRandomizing(i,1);
            r = r+1;
        end
        %for r = 1:rows 
            %rewardOnOffer(r) = trials(r,1).offer;
        %end

        %if (b==2 && pms.blockCB==0 || b==1 && pms.blockCB==1) && (sum(rewardOnOffer(1:8)==0)>0) 
            %first8rewarded = 0;
        %elseif (b==2 && pms.blockCB==0 || b==1 && pms.blockCB==1) && (sum(rewardOnOffer(1:8)==0)==0) 
            %first8rewarded = 1;
        %elseif b==1 && pms.blockCB==0 || b==2 && pms.blockCB==1
            %first8rewarded = 1;
        %end
    %end
    
%% randomize trials in this block

% % put all offers in one vector (instead of in struct)
% for r = 1:size(trials,1) 
%     rewardOnOffer(r) = trials(r,1).offer;
% end
% % divide into rewarded and unrewarded trialnumbers
% unrewardedTrials = find(rewardOnOffer==0); 
% rewardedTrials = find(rewardOnOffer==50);  
% 
% % combine trials, where first 8 need to be rewarded and no 2 unrewarded
% % trials can follow each other.
% % In case all the rewarded trials are "used" and we are still
% % randomizing, we need to start over. 
% enoughRewardedLeft = 0;
% hoi = 0;
% while enoughRewardedLeft==0
%     randomizedtrials = [];
%     for r = 1:size(trials,1)
%         if length(unrewardedTrials) - length(rewardedTrials) > 1 
%            hoi = hoi + 1 
%            break; % start over with the for loop, not enough rewardedTrials left.
%         end
%         if r<=8
%             randomizedtrials(r) = datasample(rewardedTrials,1);
%             % remove chosen trial from list, so it cannot be picked twice
%             rewardedTrials = rewardedTrials(rewardedTrials~=randomizedtrials(r));
%         elseif r>8
%            if sum(rewardOnOffer(randomizedtrials(r-5:r-1))==50) == 5 % I want no more than 8 consecutive rewarded trials
%                randomizedtrials(r) = datasample(unrewardedTrials,1);
%                unrewardedTrials = unrewardedTrials(unrewardedTrials~=randomizedtrials(r));
%            elseif rewardOnOffer(randomizedtrials(r-1))==50 %if last trial was rewarded, this trial can be either rewarded or unrewarded
%                allTrials = [rewardedTrials, unrewardedTrials];
%                randomizedtrials(r) = datasample(allTrials,1);
%                if sum(randomizedtrials(r)==rewardedTrials)==1 %if the new pick is from the rewarded trials, remove it from the rewardedTrials vector
%                    rewardedTrials = rewardedTrials(rewardedTrials~=randomizedtrials(r));
%                elseif sum(randomizedtrials(r)==unrewardedTrials)==1 %if the new pick is from the unrewarded trials, remove it from the unrewardedTrials vector
%                    unrewardedTrials = unrewardedTrials(unrewardedTrials~=randomizedtrials(r));
%                end
%            elseif rewardOnOffer(randomizedtrials(r-1))==0 %if last trial was unrewarded, this trial has to be rewarded
%                randomizedtrials(r) = datasample(rewardedTrials,1);
%                rewardedTrials = rewardedTrials(rewardedTrials~=randomizedtrials(r));
%            end
%         end
%         if r==size(trials,1) % last trial, so break out of while loop
%             enoughRewardedLeft = 1;
%         end
%     end
% end 
% 
% % use the randomizedTrials vector to shuffle trials
% trials = trials(randomizedtrials, :);    

% r = 1:size(trials,1); 
% r = datasample(r,size(trials,1),'Replace',false);
% trials = trials(r, :);



    
    %% combine blocks  
    trial = [trial, trials];
end %for b = blockOrder
end %function

                

