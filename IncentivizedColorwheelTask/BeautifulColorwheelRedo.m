function [data, trial, T, totalBonus, pms] = BeautifulColorwheelRedo(varargin)
% Colorwheel
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
    taskNameRedo        = varargin{4};
    taskRedo            = varargin{5};
    bonusRedo           = varargin{6};
    bonusCW             = varargin{7};
    
    [subNo,dataFilename,dataFilenamePrelim,practice]=getInfo(subNo,practice);
    
    data         = []; 
    trial        = []; 
    T            = []; 
    bonus        = []; 
    
   %% set experiment parameters 
   
   pms.shape=0;
   pms.slow=0;
   pms.patternCB=1;
   pms.incColordir=fullfile(pms.logdir,'IncentivizedColorwheel'); %...\log\colorwheel
   pms.subdirICW = fullfile(pms.incColordir,sprintf('IncentivizedColorwheel_sub_%d',subNo));
   pms.redologdir = fullfile(pms.rootdir,'RedoLog');
   
    pms.numTrials       = 40; % adaptable max trials per block; important to be dividable by 10
    pms.trialStruct     = pms.numTrials/10;
    pms.numBlocks       = 1;
    pms.taskNameRedo    = taskNameRedo;
    pms.taskRedo        = taskRedo;
    pms.bonusRedo       = bonusRedo;
    pms.bonusCW         = bonusCW;
    pms.numCondi            = 2;  % 0 IGNORE, 2 UPDATE
    pms.maxSetsize          = [1,3]; %number of squares/circles used
    pms.colorTrials         = 12;  % trials for colorvision task  
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
    pms.patternSize         = 100; %size of dots in dotted background pattern
    pms.subNo               = subNo;
    pms.matlabVersion       = 'R2016a';
    pms.offerDuration       = 0.75; % in case of no eyetracking
    % timings
    pms.maxRT               = 4; % max RT
    if pms.slow==0
        pms.encDuration         = 0.5;    % encoding
        pms.delay1DurationPr    = 0.5; % delay 1 during practice
        pms.delay1Duration      = 0.5;      
        pms.interfDurationPr    = 0.5; % interfering stim during practice
        pms.interfDuration      = 0.5;
        pms.delay2DurationIgnPr = 0.5; %delay 2 during practice
        pms.delay2DurationUpdPr = 1.5;
        pms.delay2DurationIgn   = 0.5;
        pms.delay2DurationUpd   = 1.5;
        pms.makeUpDurationI     = pms.delay1Duration + pms.interfDuration - pms.delay2DurationIgn; % because I trials are shorter, I need to add some extra time at the end of the trial     
    elseif pms.slow==1
        pms.encDuration         = 2;    % encoding
        pms.delay1DurationPr    = 0.5; % delay 1 during practice
        pms.delay1Duration      = 0.5;      
        pms.interfDurationPr    = 2; % interfering stim during practice
        pms.interfDuration      = 2;
        pms.delay2DurationIgnPr = 0.5; %delay 2 during practice
        pms.delay2DurationUpdPr = 4.5;
        pms.delay2DurationIgn   = 0.5;
        pms.delay2DurationUpd   = 3;
        pms.makeUpDurationI     = pms.delay1Duration + pms.interfDuration - pms.delay2DurationIgn; % because I trials are shorter, I need to add some extra time at the end of the trial         
    end   
    pms.feedbackDuration    = 0.5; %feedback during colorwheel
    pms.feedbackDurationPr  = 1;
    pms.makeUpDurationI     = pms.delay1Duration + pms.interfDuration - pms.delay2DurationIgn; % because I trials are shorter, I need to add some extra time at the end of the trial 
    pms.offerdelay          = 0.5;
    pms.rewardduration      = 2; %duration of reward cue before every trial
    %pms.rewardduration      = 0.75; %duration of "you win xx" 
    pms.minAcc              = 15;   % during practice or when we use a fixed cut off 
    pms.bonusCalculation    = 2500; % by which number does the bonus amount have to be divided?
    if exist('pms.incColordir','var')
        pms.incColordir     = pms.incColordir;
    else
        pms.incColordir     = pwd;
    end
    
    % initialize the random number generator
    randSeed = sum(100*clock);
 
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
%    wPtr = pms.wPtr;
%   rect = pms.rect;
    [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background, [0 0 1920 1080]);
    pms.wPtr = wPtr;
    pms.rect = rect;
    pms.xCenter=rect(3)/2;
    pms.yCenter=rect(4)/2;     
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

    %% prepare data for easy export later
    
    % log general subject and session info
    dataHeader.header           = 'WMcolors';
    dataHeader.randSeed         = randSeed;
    dataHeader.sessionTime      = fix(clock);
    dataHeader.subjectID        = subNo;
    dataHeader.dataName         = dataFilename;
    dataHeader.logdir           = cd; %adapt logdir (MF: e.g.: fullfile(cd, 'log'))
    
    % initialize data set
    data.setsize               = NaN; %trial(:,:).setSize;
    data.trialNum              = NaN; %trial(:,:).number;
    data.trialtype             = NaN; %trial(:,:).trialType;
    data.location              = NaN; %trial(:,:).locations;
    data.colors                = NaN; %trial(:,:).colors;
    data.respCoord             = NaN;
    data.onset                 = NaN;
    data.rt                    = NaN;
    data.probeLocation         = NaN;
    data.stdev                 = NaN;
    data.thetaCorrect          = NaN;
    data.respDif               = NaN;
    data.reward                = NaN; 
    
    % baseline for event onset timestamps
    exptOnset = GetSecs;
    
    %% Experiment starts with instructions
    %%%%%%% get instructions
    % show instructions
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
        
    getInstructions(6,pms,3,rect,wPtr);
    
    % make trial structure
    if pms.taskRedo~=5;
       [trial]= trialstructRedo(pms,rect,1,0,0);

       WaitSecs(1); % initial interval (blank screen)
    
    %% showTrial: in this function, the trials are defined and looped
    
       [pms,data,T,money,~] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect);
    
    

    %% Save the data
       save(fullfile(pms.redologdir,dataFilename));
    
 end  %if pms.taskRedo~=5
 
    %% Close-out tasks
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
    
    % last instructions
    totalBonus = bonusRedo + bonusCW;
    pms.totalBonus = totalBonus
    getInstructions(7,pms,3,rect,wPtr,totalBonus);
    
    
    % close screen
    if pms.battery==0
        clear Screen
        Screen('CloseAll');
        ShowCursor; % display mouse cursor again
        ListenChar(0); % allow keystrokes to Matlab
        Priority(0); % return Matlab's priority level to normal
        Screen('Preference','TextAlphaBlending',0);
    end

   
    
catch ME
    disp(getReport(ME));
    keyboard
    
    % save data
    save(fullfile(pms.redologdir,dataFilename));
    
    % close-out tasks
    Screen('CloseAll'); % close screen
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
end %try-catch loop
end % main function