 function [data,varargout] = BeautifulChoices(varargin) 

%% COGEDp
%
% This function presents the delay discounting task for eye tracking.
%
% Participants make a series of choices between tasks varying in
% delay for different amounts of money. The task starts with practice
% trials and then proceeds to a series of pairwise offers designed first to
% find indifference points, then repeat offers varying orthogonally across
% amounts, bias (toward or away from higher effort option), and delay. 
%
% This file includes the following subfunctions:
%   displayMessage
%   getSubjectInfo
%   disp_Tasks
%   showDmTrial
%   showITI
%
% Last updated by JAW on 10/19/17

%% Colorwheel
%
% This function presents the Discounting choice task - here: part 2 of the
% QuantifyingCC study, part 1 is the DMS
% The aim of the choice task is to determine the Subjective Value (SV) that participants ascribe to the 2 processes that they experienced during the phase 1 of DMS task:
% During the DMS task participants saw different trials:

%       i) IGNORE/NEGLECT (indicated by the letter 'I' in the centre): pps should ignore the new stimuli
%           and still remember the colors/locations presented during ENCODING.
%       ii) UPDATE (indicated by the letter 'U'): pps should overwrite/forget the colors/locations of the ENCDOING,
%           but ONLY remember the latest colors/locations presented during interference phase.
% 
% Version 1: Task vs No task  (easy offer: task)
% In this version participants choose between repeating all levels of the DMS task
% and not repeating the task at all
% 
% This file calls the following (sub)functions:
%   getInfoChoice
%   defChoicesFIxed
%   getInstructionsChoice
%   showChoiceTrialFixed

try %because if error in PTB: black screen only

       if nargin==0
           [subNo,dataFilename,dataFilenamePrelim,practice,pms]=getInfoChoice; 
       elseif nargin>0
            subNo            = varargin{1};
            practice         = varargin{2};            
            pms              = varargin{3};
            if nargin>3
                dataPr       = varargin{4};
            end
            [subNo,dataFilename,dataFilenamePrelim,practice,pms]=getInfoChoice(subNo,practice,pms); 
       end

    
 %% set experiment parameters (pms)
 
%    subNo = 1;
%    practice = 1;
%    pms.blockCB = 1;
 
    pms.subNo = subNo;
    pms.practice = practice;
%    pms.blockCB = blockCB;
%    pms.patternCB = patternCB;
%    pms.instructions = instructions;
%    pms.choicelogdir = choicelogdir;
%    if practice~=1 && pms.instructions==1
%        pms.rect = rect;
%        pms.wPtr = wPtr;
%    end
    pms.numBlocks = 4;
    pms.setsize = [1 3]; 
    pms.conditions = {0,2}; %0=IGNORE 2=UPDATE
    pms.tasks = {'Update1', 'Update3', 'Ignore1', 'Ignore3', 'No redo'}; %[1 2 3 4 5]; 
    pms.EasyTaskPairs = {{1,3,1,2},{5}};
    pms.HardTaskPairs = {{2,4,3,4},{1,2,3,4}};
%    pms.taskPairs = {{1,3,1,2},{2,4,3,4}}; % combination of task pairs, first cell for easy tasks and second cell for hard tasks, numbers corresponding to pms.tasks
%    pms.taskPairsNR = {{5},{1,2,3,4}}; % 5=no redo
    pms.availableColors = {[0, 0, 0]; [240, 0, 0]; [0, 0, 255]; [95, 0, 115]}; %M:remove??
    % set base offer amounts (in $s)
    pms.amts = [2]; % set amount of money for the hard task
    % set the number of decision trials
    pms.nCalTrials = 6; % Number of calibration trials per task combination to detect indifference point; should be divisible by 2
    % practice
    if practice==1  % different values for practice runs
        pms.numBlocks = 1;
        pms.nCalTrials = 1;
        pms.availableColors = pms.availableColors(1); % set text colors for practice decisions
        pms.chcDuration = 12; % max choice duration
        pms.trlDuration = 3; % max trial duration in seconds (including ITI)
    end
    
    %text
    pms.txtFont = 'Times New Roman';
    pms.txtSize = 30;
    pms.txtSpacing = 3; % vertical spacing between lines of text
    pms.txtStyle = 1;
    pms.textCol = [zeros(1,3), 255]; % text color
    pms.selCol = [zeros(1,3), 255]; % selection box color
    pms.ground = 200; % size of squares for option locations
    % allowable response characters
    pms.allowedResps.left = ',1';
    pms.allowedResps.right = '.2'; 
    % timings
    pms.maxRT = 4;
    pms.chcDuration = 9; % max choice duration
    pms.trlDuration = 3; % max trial duration in seconds (including ITI)
    pms.iti = 0.3; % CT, between trials
    pms.jitter = 0; % CT, should trial duration be jittered (no: 0, yes: 1)
    
    [pms.keyboards] = GetKeyboardIndices();
    
%% display and screen
    % display parameters
    % bit Added to address problem with high precision timestamping related
    % to graphics card problems
    % Screen settings: suppress screentest PTB
    
    % display parameters
    [pms.screens] = Screen('Screens');
    pms.mon = pms.screens(end); % 0 for primary monitor
    pms.background = [200 200 200];
    pms.bkgd = 200; % M: change; intensity level of background gray
    pms.wrptx = 100; % text wrapping position
    pms.patternSize = 100;
    
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference','VisualDebugLevel',0);
    Screen('Preference', 'VBLTimestampingMode', -1);  
    Screen('Preference','TextAlphaBlending',0);
    
    % initialize the random number generator
    randSeed = sum(100*clock);
    delete(instrfind); %???
    
    % experiment starts
    HideCursor;
    ListenChar(2); %2: enable listening; but keypress to matlab windows suppressed.
    Priority(1);  % level 0, 1, 2: 1 means high priority of this matlab thread = use a lot of CPU power for matlab
          
    % open an onscreen window
    if pms.instructions==0 %when debugging and skipping practice trials there is no open screen, so we open a screen here.
        [wPtr,rect]=Screen('Openwindow',pms.mon,pms.background, [0 0 1920 1080]);
        pms.wPtr = wPtr;
        pms.rect = rect; 
    elseif practice ~= 1
        wPtr = pms.wPtr;
        rect = pms.rect;
    elseif practice == 1
        [wPtr,rect]=Screen('Openwindow',pms.mon,pms.background, [0 0 1920 1080]);
        pms.wPtr = wPtr;
        pms.rect = rect;
    end 

    % Center of offer rects from upper left -> upper right -> ll -> lr
    pms.rectCtrsx = [floor(rect(3)/4),floor(rect(3)*3/4),floor(rect(3)/4),floor(rect(3)*3/4)];
    pms.rectCtrsy = [floor(rect(4)/4),floor(rect(4)/4),floor(rect(4)*3/4),floor(rect(4)*3/4)];
    pms.ifi = Screen('GetFlipInterval', wPtr);
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
  
   %% prepare data for easy export later
    
    % log general subject and session info
    dataHeader=struct();
    dataHeader.header ='Colorwheel_choiceTask';
    dataHeader.randSeed = randSeed;
    dataHeader.sessionTime = fix(clock); %current time in nice format
    dataHeader.subjectID = subNo;
    dataHeader.dataName = dataFilename;
    dataHeader.dataFilenamePrelim = dataFilenamePrelim;
    dataHeader.logdir = cd; %adapt logdir    
    
   %% get trialstructure depending on pms
       [data,pms] = MdefChoices(pms);
 
   %% Experiment starts with instructions
   
    % Define Text
    Screen('TextSize',wPtr,16);
    Screen('TextStyle',wPtr,1);
    Screen('TextFont',wPtr,'Helvetica'); 
    if practice==1  
           getInstructionsChoice(1,pms,wPtr); %instructions practice trials
    elseif practice==0 
           getInstructionsChoice(2,pms,wPtr); %instructions before actual choice task
    end
    
    %% Experiment starts with trials
    
    % baseline for event onset timestamps; current time, based on operating system
    exptOnset = GetSecs;
    pms.exptOnset = exptOnset; 
    
    % run begins
    WaitSecs(1); % initial interval (blank screen)
    
    % show the offers and collect a response (1 = easy, 2 = hard, 9 = too slow)
    [data] = MchoiceTrials(pms, data, wPtr, rect, dataHeader); %=struct used for analysis
 
    %% Save the data      
    save(fullfile(pms.choicelogdir,dataFilename));
    
    %% Close-out tasks
       
    % show a blank screen briefly at the end of the run
    Screen('FillRect',wPtr,pms.background); % clear screen
    Screen(wPtr,'Flip');
    WaitSecs(1);
        
    if nargin > 0 && practice==0 %&& trial == size(data.choice,1)
        getInstructionsChoice(4,pms,wPtr);
    end  
    
    % close-out tasks
    if practice==0 
        if pms.battery==0
            clear Screen
            Screen('CloseAll');
            ShowCursor; % display mouse cursor again
            ListenChar(0); % allow keystrokes to Matlab
            Priority(0); % return Matlab's priority level to normal
            Screen('Preference','TextAlphaBlending',0);
        end
    end
    
%% define varargout 

    varargout{1} = pms;
    
catch ME
    disp(getReport(ME)); %get error message and returns it as text
    sca
    keyboard %pauses execution of the running program and gives control to the keyboard
    
    % save data
    save(fullfile(pms.choicelogdir,dataFilename));
    %save(dataFilename,'data','dataHeader');
    
    % close-out tasks
    Screen('CloseAll'); % close screen
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
end %try-catch loop
end % main function

