function [data2, trial, T, bonus] = BeautifulColorwheel(varargin)
% Colorhwheel
%
% This function presents the colorwheel task - here: part 1 of the
% QuantifyingCC study: incentivized version!!!. 
% The task has 5 phases:
% 1) Encoding phase
% 2) Delay 1 phase
% 3) Interference phase
% 4) Delay 2 phase
% 5) Probe phase
%
% 1) During the encoding phase,participants will see different set sizes (=1-4) of colored squares.
%    The task is to encode (=remember) the colors and locations.
%
% 3) During the interference phase, there are 2 conditions:
%       i) IGNORE (indicated by the letter 'I' in the centre): pps should ignore the new stimuli
%           and still remember the colors/locations presented during ENCODING.
%       ii) UPDATE (indicated by the letter 'U'): pps should overwrite/forget the colors/locations of the ENCDOING,
%           but ONLY remember the latest colors/locations presented during interference phase.
%
% 5) During the probe phase: colorhweel appears and a square.
%       Participants should recall the color that was presented at that location of the square:
%       during the ENCODING (for i) or during the intervening phase (for ii).
%       With a mouse click on the colorwheel, they give a response.
%
% This file calls the following (sub)functions:
%   getInfo
%   defstruct
%   trialstruct
%   getInstructions
%   showTrial

try
    subNo               = varargin{1};
    practice            = varargin{2};
    pms                 = varargin{3};
    [subNo,dataFilename,dataFilenamePrelim,practice]=getInfo(subNo,practice);            

    %% set experiment parameters
    pms.numTrials           = 64; % adaptable; important to be dividable by 2 (conditions) and multiple of 4 (set size)
    pms.numBlocks           = 1;  % 1/2 of blocks of incentivized version, because after reshaping you get 2 blocks of 64.

    pms.numCondi            = 2;  % 0 IGNORE, 2 UPDATE
    pms.numTrialsPr         = 16;  
    pms.numBlocksPr         = 1; 
    pms.redoTrials          = 128; %trials for Redo
    pms.redoBlocks          = 2; %blocks for Redo
    pms.maxSetsize          = 4; %maximum number of squares used
    pms.colorTrials         = 12;    
    %colors
    pms.numWheelColors      = 512;
    
    %text
    pms.textColor           = [0 0 0];
    pms.background          = [200,200,200];
    pms.wrapAt              = 65;
    pms.spacing             = 2;
    pms.textSize            = 22;
    pms.textFont            = 'Times New Roman';
    pms.textStyle           = 1; 
    pms.ovalColor           = [0 0 0];
    pms.subNo               = subNo;
    pms.matlabVersion       = 'R2013a';
    % timings
    pms.maxRT               = 4; % max RT
    pms.encDuration         = 0.5;    %2 seconds of encoding
    pms.encDurationIgn      = 0.5;
    pms.encDurationUpd      = 0.5;
    pms.delay1DurationPr    = 2; %2 seconds of delay 1 during practice
    pms.delay1DurationUpd   = 2;
    pms.delay1DurationIgn   = 2;        
    pms.interfDurationPr    = 0.5; %2 seconds interfering stim during practice
    pms.interfDurationIgn   = 0.5;
    pms.interfDurationUpd   = 0.5;
    pms.delay2DurationIgnPr = 2; %2 seconds of delay 2 during practice
    pms.delay2DurationUpdPr = 4.5;
    pms.delay2DurationIgn   = 2;
    pms.delay2DurationUpd   = 4.5;
    pms.feedbackDuration    = 0.5; %feedback during colorwheel
    pms.feedbackDurationPr  = 0.7;
    pms.responseDuration    = 0.4; 
    pms.jitter              = 0;
    pms.iti                 = 0.1;
    pms.rewardduration      = 1.0;
    pms.rewarddelay         = 0.8;
    pms.bonusduration       = 1.5; %duration that the total reward up to that point is shown
    pms.minAcc              = 10; % maximum deviance to win reward
    if exist('pms.incColordir','var')
        pms.incColordir     = pms.incColordir;
    else
        pms.incColordir     = pwd;
    end
    %% display and screen
   
    % bit Added to address problem with high precision timestamping related
    % to graphics card problems
    
    % Screen settings
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference', 'VBLTimestampingMode', -1);
    Screen('Preference','TextAlphaBlending',0);
    Screen('Preference', 'VisualDebugLevel',0);
    % initialize the random number generator
    randSeed = sum(100*clock);
    delete(instrfind);
    %RandStream.setGlobalStream(RandStream('mt19937ar','seed',randSeed));
    
    HideCursor;                                               %disabled hide cursor 
    ListenChar(2);%2: enable listening; but keypress to matlab windows suppressed.
    Priority(1);  % level 0, 1, 2: 1 means high priority of this matlab thread
    
    % open an onscreen window
    [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background);
    
    pms.xCenter=rect(3)/2;
    pms.yCenter=rect(4)/2;     
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    %% get trialstrcutre depending on pms
    %%%%%% prepare trials
    % function to get trialstructure using pms (parameters) as input
    if practice==0
         [trial]=defstruct(pms,rect);
 %if we have already created a trial structure for all participants (like we did for the real task?)
 %then we can instead load trialFin instead and comment out the above line (MF: which line? still true?)
    elseif practice==1
         [trial]= trialstruct(pms,rect,1);   
    elseif practice==2
        [trial]=trialstruct(pms,rect,2);
    end
    %% prepare data for easy export later
    
    % log general subject and session info
    dataHeader.header           = 'WMcolors';
    dataHeader.randSeed         = randSeed;
    dataHeader.sessionTime      = fix(clock);
    dataHeader.subjectID        = subNo;
    dataHeader.dataName         = dataFilename;
    dataHeader.logdir           = cd; %adapt logdir (MF: e.g.: fullfile(cd, 'log'))
    
    % initialize data set
    data2.setsize               = []; %trial(:,:).setSize;
    data2.trialNum              = []; %trial(:,:).number;
    data2.trialtype             = []; %trial(:,:).trialType;
    data2.location              = []; %trial(:,:).locations;
    data2.colors                = []; %trial(:,:).colors;
    data2.respCoord             = [];
    data2.onset                 = [];
    data2.rt                    = [];
    data2.probeLocation         = [];
    data2.stdev                 = [];
    data2.thetaCorrect          = [];
    data2.respDif               = [];
    data2.reward                = []; 
    
    % baseline for event onset timestamps
    exptOnset = GetSecs;
    
    %% Define Text
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
  %% Color vision task
%   if practice==1
%   colorTestData = colorVision(pms,wPtr,rect); % colorTestData = output colorVisiontest
%   end
    %% Experiment starts with instructions
    %%%%%%% get instructions
    % show instructions
    if     practice==1
           getInstructions(1,pms,wPtr);
    end

    %% Experiment starts with trials
    % stimOnset = Screen(wPtr,'Flip'); CHECK onsets
    % onset = stimOnset-exptOnset;
    % run begins
    
    WaitSecs(1); % initial interval (blank screen)
    %%%%%%
    % showTrial: in this function, the trials are defined and looped
    [data2, T,bonus] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect); 
        % showTrial opens colorwheel2 and stdev function
    
        
    %% Save the data
    save(fullfile(pms.subdirICW,dataFilename));
    %% Close-out tasks
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
    if practice==0
       getInstructions(3,pms,wPtr,bonus)   
    elseif practice==1
       getInstructions(2,pms,wPtr)   
    end
    clear Screen
    Screen('CloseAll');
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
catch ME
    disp(getReport(ME));
    keyboard
    
    % save data
    save(fullfile(pms.subdirICW,dataFilename));
    
end %try-catch loop
end % main function



