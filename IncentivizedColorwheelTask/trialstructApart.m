%% set experiment parameters
pms.numTrials = 64; % adaptable; important to be dividable by 2 (conditions) and multiple of 4 (set size)
pms.numBlocks = 2;

pms.numCondi = 2;  % 0 IGNORE, 2 UPDATE
pms.numTrialsPr=16; %trials for practice
pms.numBlocksPr=1; %blocks for practice
pms.redoTrials=128; %trials for Redo
pms.redoBlocks=2; %blocks for Redo
pms.maxSetsize=4; %maximum number of squares used
pms.colorTrials=12;    
%colors
pms.numWheelColors=512;

%% trialstruct function
% [trial]=trialstruct(pms,rect,practice,varargin)
% adapt inputs to pms. (see Beautifulcolorwheel)

% function that creates a numTrials x numBlocks struct with 
% trial number,trial type (IG, NX,UP), rect locations and colors for encoding and
% update/ignore phases if required. 
% Number of colors is included as input so we can define how big a sample of colors we need from the 640 colors of the wheel


% Screen('Preference','SkipSyncTests',1);
% Screen('Preference', 'SuppressAllWarnings', 1);
% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));

% colormatrix=hsv(pms.numWheelColors)*255;       %MF: where define numColors? Maybe as input from main script? DP:It is already an input I think. This is the function that opens the figure
% colormatrix=sampledColorMatrix(pms,step);

% deleted 'if practice ==' , left the practice = 1 code.
% if practice = 1:
    pms.numBlocks=pms.numBlocksPr;
    pms.numTrials=pms.numTrialsPr;
    setsizevector = [ones(1,(pms.numTrials/pms.maxSetsize)), 2*ones(1,pms.numTrials/pms.maxSetsize), 3*ones(1,pms.numTrials/pms.maxSetsize),pms.maxSetsize*ones(1,pms.numTrials/pms.maxSetsize)]';
    setsizevectorFin=repmat(setsizevector,1,pms.numBlocks);
    %         trialTypes=[0 1 2]';
    trialTypes=[0 2]';
    typematrixFin=repmat(trialTypes,pms.numTrials/length(trialTypes),pms.numBlocks);
    % timematrixFin=2*ones(pms.numTrials,pms.numBlocks);

    


%% 3)make location matrix
%pms.background=[200,200,200];
%[wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background);
rect = [0 0 1 1] ;
rectsize=[0 0 100 100];
numrects=4;
%  xyindex=[0.4 0.6 0.6 0.41;0.35 0.37 0.6 0.6]';
xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]';

locationmatrix=zeros(size(xyindex,1),size(xyindex,2));
for r=1:length(locationmatrix)
    locationmatrix(r,1)=(rect(3)*xyindex(r,1));
    locationmatrix(r,2)=(rect(4)*xyindex(r,2));
end

%% 4)color matrix
%%%  Put into structure (for easy output of function)
trialsvector=(1:pms.numTrials)';
trialsmatrix=repmat(trialsvector,1,pms.numBlocks);

trial=struct();
for i=1:pms.numBlocks
    for t=1:pms.numTrials
        trial(t,i).number=trialsmatrix(t,i);
        trial(t,i).type = typematrixFin(t,i);
        trial(t,i).setSize=setsizevectorFin(t,i); 
        %trial(t,i).interTime=timematrixFin(t,i);
        % trial(t,i).probePie=piematrixFin(t,i);
    end                                  
end
%% 5) add locations and colors to trial
for v=1:pms.numBlocks
    for w=1:pms.numTrials
        colormatrix=sampledColorMatrix(pms);
        switch trial(w,v).setSize       %get random colors and locations from predefined matrices
            case 1  %setsize 1
                trial(w,v).colors=datasample(colormatrix,2,'Replace',false);    %2 colors: 1 for ENC, 1 for intervening
                trial(w,v).locations=datasample(locationmatrix,1,'Replace',false);%chooses n rows from matrix without replacement
            case 2  %setsize 2
                trial(w,v).colors=datasample(colormatrix,4,'Replace',false);    %4 colors: 2 ENC, 2 intervening
                trial(w,v).locations=datasample(locationmatrix,2,'Replace',false);  %2 locations
            case 3  %setsize 3
                trial(w,v).colors=datasample(colormatrix,6,'Replace',false);    %6 colors: 3 ENG, 3 interv
                trial(w,v).locations=datasample(locationmatrix,3,'Replace',false);  %3 locations
            case 4  %setsize 4
                trial(w,v).colors=datasample(colormatrix,8,'Replace',false);    %8 colors: 4 for ENG, 4 for interv
                trial(w,v).locations=locationmatrix;                                %all 4 locations
        end
    end
end
%% 6) add rewards to trial by replicating trial, adding low reward to original and high reward to replica, and adding replica to original.
% replicate the original trial struct 
trial2 = trial ;

% add low reward to original trial struct
lowReward = 0.1 ;
for a = 1 : pms.numBlocks
    for b = 1 : pms.numTrials
        trial(b,a).reward = lowReward ;
    end
end

% add high reward to trial2
highReward = 1.0 ;
for a = 1 : pms.numBlocks
    for b = 1 : pms.numTrials
        trial2(b,a).reward = highReward ;
    end
end

% add fields of trial2 beneath fields of trial
rowTrial = length(trial) ;         % rowTrial is lowest row of trial. beneath this row, insert fields of trial2.
lastRowNewStruct = rowTrial*2 ;    % new struct will be twice as big as trial, thus rowTrial*2.

for c = rowTrial+1 : lastRowNewStruct
    for d = 1 : pms.numBlocks 
        trial(c,d) = trial2((c-rowTrial), d) ; % c-rowTrial because trial2 has row coordinates range of 1 to rowTrial.
    end                                        % 1, because t = rowTrial+1. (rowTrial+1)-rowTrial = 1
end
 
% consider preallocating for speed. dont know how to preallocate struct for
% certain size

% make new variable for doubled trials
pms.numTrialsDouble = pms.numTrials * 2 ;