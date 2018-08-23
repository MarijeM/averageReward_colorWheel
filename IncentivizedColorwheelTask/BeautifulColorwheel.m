function [data, trial, T, bonus, pms] = BeautifulColorwheel(varargin)
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
    if nargin>3
        dataPr          = varargin{4};
    end
    [subNo,dataFilename,dataFilenamePrelim,practice]=getInfo(subNo,practice);
    
    data    = []; 
    trial   = []; 
    T       = []; 
    bonus   = []; 

    %% set experiment parameters
    pms.numTrials           = 120; % adaptable max trials per block; important to be dividable by 2 (conditions) and multiple of 4 (set size)
    pms.numBlocks           = 3;  

    pms.numCondi            = 2;  % 0 IGNORE, 2 UPDATE
    if pms.spaceBar==1
        pms.numTrialsPr         = 8;  
    elseif pms.spaceBar==0
        pms.numTrialsPr         = 16;  
    end 
    pms.numBlocksPr         = 1; 
    pms.maxSetsize          = 3; %maximum number of squares used
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
    pms.matlabVersion       = 'R2016a';
    %eyelink parameters
%     pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated (changes into green)
%     pms.allowedResps.drift = 'left_control';
%     pms.allowedResps.drift = 'c';
%     pms.allowedResps.driftOK = 'd';
%     pms.fixDuration = 0.75; % required fixation duration in seconds before trials initiate
    pms.offerDuration = 0.75; % in case of no eyetracking
%     pms.diagTol = 100; % diagonal pixels of tolerance for fixation
    % timings
    pms.maxRT               = 4; % max RT
    pms.cueduration         = 1.0;
    pms.cuedelay            = 0.75;
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
    pms.rewardduration      = 0.75; %duration of "you win xx" 
    if practice==0 && pms.cutoff==1
        dataTable = struct2table(dataPr);
        dataMatrix = dataTable(:,[10,17]);
        dataMatrix = [dataMatrix.respDif,dataMatrix.type];
        pms.dataMatrix = dataMatrix;
        pms.minAcc_I              = prctile(abs(dataMatrix(dataMatrix(:,2)==0,1)),85); % maximum deviance to win reward, 85 percentile of practice trials
        pms.minAcc_U              = prctile(abs(dataMatrix(dataMatrix(:,2)==2,1)),85);
        if isfield(pms,'minAcc_I') == 0 %if debugging, possible that minacc cannot be calculated, since prior data does not exist
             pms.minAcc_I            = 100; % maximum deviance to win reward
             pms.minAcc_U            = 60; 
        end 
    end

    pms.minAcc              = 15;    
    pms.blockDuration       = 1*60; %duration in seconds of one block
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
    if pms.instructions==0 %when debugging and skipping practice 1(color sensitivity test) there is no open screen, so we open a screen here.
        [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background, [0 0 1920 1080]);
        pms.wPtr = wPtr;
        pms.rect = rect; 
    elseif practice ~= 1
        wPtr = pms.wPtr;
        rect = pms.rect;
    elseif practice == 1
        [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),pms.background, [0 0 1920 1080]);
        pms.wPtr = wPtr;
        pms.rect = rect;
    end 
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
    if practice==1
       if pms.CV==1
            getInstructions(1,pms,wPtr); %intro + instruction color vision
           hooray = 0; 
           while hooray==0
            [hooray,median_rtMovement]=colorVision(pms,wPtr,rect);
            pms.median_rtMovement = median_rtMovement;
           end
       end
       getInstructions(2,pms,wPtr); % instruction regular color wheel
       if pms.shape==0 %squares
           [trial]= trialstruct(pms,rect,1,0,0);  
       elseif pms.shape==1 %circles
           [trial]= trialstruct_circles(pms,rect,1,0,0);  
       end 
    elseif practice==2
       getInstructions(3,pms,wPtr);
       if pms.shape==0 %squares
           [trial]= trialstruct(pms,rect,1,0,1);  
       elseif pms.shape==1 %circles
           [trial]= trialstruct_circles(pms,rect,1,0,1);  
       end   
    elseif practice==0
        if pms.points==1
           if pms.spaceBar==0
               getInstructions(31,pms,wPtr);
           elseif pms.spaceBar==1
               getInstructions(4,pms,wPtr);
           end  
        elseif pms.points==0
            getInstructions(32,pms,wPtr);
        end
       if pms.shape==0 %squares
           [trial]=defstruct(pms,rect);
       elseif pms.shape==1 %circles
           [trial]=defstruct_circles(pms,rect);
       end   
    end

    WaitSecs(1); % initial interval (blank screen)
    %%%%%%
    % showTrial: in this function, the trials are defined and looped
    if pms.shape==0
        [pms,data,T,money,gazedata] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect); 
    elseif pms.shape==1 
        [pms,data,T,money,gazedata] = showTrial_circles(trial,pms,practice,dataFilenamePrelim,wPtr,rect); 
    end
    
    %% Save the data
    save(fullfile(pms.subdirICW,dataFilename));
    %% Close-out tasks
    Screen('TextSize',wPtr,pms.textSize);
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);
    if practice==0
       getInstructions(6,pms,wPtr,money);  
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
    save(fullfile(pms.subdirICW,dataFilename));
    
end %try-catch loop
end % main function



