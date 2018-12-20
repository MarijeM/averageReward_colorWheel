%%%%%%%Colorwheel behavioral study script%%%%%%%%%%
% Used for study 3017048.03 Trait Impulsivity and Motivational Control
% In this study, the regular delayed match to sample color wheel task, the
% choice task belonging to the colorwheel task, the redo, following on the
% choice task, and a new, incentivized colorwheel task is used, where the
% colorwheel trials are preceded by a high or low reward. 

clear; 
clc;
rng('shuffle');

% load counterbalanced parameters
load('subjectsCB.mat')
pms.battery = 1; % battery of CW, Choice and Redo after eachother, 1 if do not close each task, 0 if close each task 


%% 1. Colorwheel task

% ask for subject number
subNo= input('Subject ID: '); %request user input: subject ID
checked=input(sprintf('participant number is %d',subNo)); %returns answer

% ask for counterbalancing reward: 0 is no reward, reward context, 1 is reward, no
% reward context
%pms.blockCB = input('\n\nWhich block first?\n\nPress 0 for Low reward context\nPress 1 for High reward context:   '); %request user input: block order
%if pms.blockCB == 0
%    firstBlock = 'Low';
%elseif pms.blockCB == 1
%    firstBlock = 'High';
%end 
%checked=input(sprintf('Block order: first %s',firstBlock)); %returns answer
pms.blockCB = subjectsCB.block(subNo);
if pms.blockCB == 0
    firstBlock = 'Low';
elseif pms.blockCB == 1
    firstBlock = 'High';
end 

% ask for counterbalancing pattern: 1 is dotted, 2 is checkerboard
%pms.patternCB = input('\n\nWhich pattern for the Low reward context?\n\nPress 1 for Dotted\nPress 2 for Checkerboard:   '); %request user input: pattern association
%if pms.patternCB == 1
%    patternLow = 'Dotted';
%elseif pms.patternCB == 2
%    patternLow = 'Checkerboard';
%end 
%checked=input(sprintf('Pattern association: Low reward with %s',patternLow)); %returns answer
pms.patternCB = subjectsCB.pattern(subNo);
if pms.patternCB == 1
    patternLow = 'Dotted';
elseif pms.patternCB == 2
    patternLow = 'Checkerboard';
end  



% ask if fast or slow paradigm
%pms.slow = input('\n\nFast or slow paradigm?\n\nPress 0 for fast\nPress 1 for slow:   '); 
%if pms.slow == 0
%    pace = 'fast';
%elseif pms.slow == 1
%    pace = 'slow';
%end 
%checked=input(sprintf('Pace is %s',pace)); %returns answer
pms.slow = subjectsCB.pace(subNo);
if pms.slow == 0
    pace = 'fast';
elseif pms.slow == 1
    pace = 'slow';
end 

% Show instructions and practice?
%pms.instructions = input('\n\nShow instructions and practice or not?\n\nPress 0 for no\nPress 1 for yes:   '); 
%if pms.instructions== 0
%    Ins = 'Do not show instructions';
%    pms.cutoff = 0;
%elseif pms.instructions == 1
%    Ins = 'Show instructions';
%end 
%checked=input(sprintf('%s',Ins)); %returns answer
pms.instructions = subjectsCB.instructions(subNo);
if pms.instructions== 0
    Ins = 'Do not show instructions';
    pms.cutoff = 0;
elseif pms.instructions == 1
    Ins = 'Show instructions';
end 

if pms.instructions==1
    % Do color vision test?
%    pms.CV = input('\n\nDo color vision test or not?\n\nPress 0 for no\nPress 1 for yes:   '); 
%    if pms.CV== 0
%        CV = 'No color vision test';
%    elseif pms.CV == 1
%        CV = 'Do color vision test';
%    end 
%    checked=input(sprintf('%s',CV)); %returns answer
    pms.CV = 1;
else
    pms.CV = 0;
end

pms.cutoff = 0;
if pms.instructions==1
    % ask for cut off deviance for reward
%    pms.cutoff = input('\n\nCut off?\n\nPress 0 for fixed\nPress 1 for individual:   '); 
%    if pms.cutoff == 0
%        cutoff = 'Fixed';
%    elseif pms.cutoff == 1
%        cutoff = 'Individual';
%    end 
%    checked=input(sprintf('Cutoff is %s',cutoff)); %returns answer
     pms.cutoff = 1;
     cutoff = 'Individual';
end

% ask if circles or squares
%pms.shape = input('\n\nShape of stimuli?\n\nPress 0 for squares\nPress 1 for concentric circles:   '); 
%if pms.shape == 0
%    shape = 'squares';
%elseif pms.shape == 1
%    shape = 'concentric circles';
%end 
%checked=input(sprintf('Shape of stimuli is %s',shape)); %returns answer
pms.shape = subjectsCB.shape(subNo);
if pms.shape == 0
    shape = 'squares';
elseif pms.shape == 1
    shape = 'concentric circles';
end 

%% 1a create directories
pms.rootdir         = pwd; %current directory
pms.logdir          = fullfile(pms.rootdir,'Log'); %create new folder in current directory: ...\log
pms.inccwdir        = fullfile(pms.rootdir,'IncentivizedColorwheelTask');

if ~exist(pms.logdir,'dir') %if subject x does not exist
    mkdir(pms.rootdir,'Log'); %make directory
end

%% 1b colorwheel task

pms.incColordir=fullfile(pms.logdir,'IncentivizedColorwheel'); %...\log\colorwheel
if ~exist(pms.incColordir,'dir')
    mkdir(pms.logdir,'IncentivizedColorwheel'); 
end
pms.subdirICW = fullfile(pms.incColordir,sprintf('IncentivizedColorwheel_sub_%d',subNo));
if ~exist(pms.subdirICW,'dir')
    mkdir(pms.incColordir,sprintf('IncentivizedColorwheel_sub_%d',subNo));
else
    errordlg('Caution! Participant file name already exists!','Filename exists');
    return
end

%% 1c incentivized colorwheel task (when debugging and wanting to run only 1 phase, see next section and skip this one)
cd(pms.inccwdir);
disp('TASK: Color Wheel');          % display which task starts.
WaitSecs(2); %show message for 2 sec
if pms.instructions==1
    [dataPractice,~,~,~,pms] = BeautifulColorwheel(subNo,1,pms); %practice=1: color vision task and practicing task without reward cue and pattern
    [dataPractice,~,~,~,pms] = BeautifulColorwheel(subNo,2,pms); %practice=2: practicing task with reward cue and pattern
    [~, ~, ~, bonus, ~] = BeautifulColorwheel(subNo,0,pms,dataPractice); %practice=0: 50/50 task + instructions majority update/ignore blocks + task
else
    [~, ~, ~, bonus, ~] = BeautifulColorwheel(subNo,0,pms); %practice=0: 50/50 task + instructions majority update/ignore blocks + task
end


cd(pms.rootdir) %back to rootdirectory

%% 2. Choice task
  
% ask for subject number
%  subNo= input('Subject ID: '); %request user input: subject ID
%  checked=input(sprintf('participant number is %d',subNo)); %returns answer
  
% ask for counterbalancing reward: 0 is no reward, reward context, 1 is reward, no reward context
%  pms.blockCB = input('\n\nWhich block first?\n\nPress 0 for Low reward context\nPress 1 for High reward context:   '); %request user input: block order
%  if pms.blockCB == 0
%      firstBlock = 'Low';
%  elseif pms.blockCB == 1
%      firstBlock = 'High';
%  end 
%  checked=input(sprintf('Block order: first %s',firstBlock)); %returns answer

% ask for counterbalancing pattern: 1 is dotted, 2 is checkerboard
%  pms.patternCB = input('\n\nWhich pattern for the Low reward context?\n\nPress 1 for Dotted\nPress 2 for Checkerboard:   '); %request user input: pattern association
%  if pms.patternCB == 1
%      patternLow = 'Dotted';
%  elseif pms.patternCB == 2
%      patternLow = 'Checkerboard';
%  end 
%  checked=input(sprintf('Pattern association: Low reward with %s',patternLow)); %returns answer

% Show instructions and practice?
%  pms.instructions = input('\n\nShow instructions and practice or not?\n\nPress 0 for no\nPress 1 for yes:   '); 
%  if pms.instructions== 0
%      Ins = 'Do not show instructions';
%  elseif pms.instructions == 1
%      Ins = 'Show instructions';
%  end 
%  checked=input(sprintf('%s',Ins)); %returns answer
  

%% 2a create directories 
pms.rootdir         = pwd; %current directory
pms.choicelogdir    = fullfile(pms.rootdir,'ChoiceLog'); %create new folder in current directory: ...\ChoiceLog
pms.choicedir       = fullfile(pms.rootdir,'Choicetask');

if ~exist(pms.choicelogdir,'dir');
    mkdir(pms.choicelogdir);
end

if ~exist(pms.choicedir,'dir');
    mkdir(pms.choicedir);
end

cd(fullfile(pms.choicedir)) %go to choice directory

%% 2b show choice task

disp('TASK: Choice Wheel');  % display which task starts.
WaitSecs(2); %show message for 2 sec

if pms.instructions==1
    [dataPracticeChoice,pms] = BeautifulChoices(subNo,1,pms); %practice=1: intructions + practice trials
    [dataChoice] = BeautifulChoices(subNo,0,pms,dataPracticeChoice); %practice=0: actual task
else
    [dataChoice] = BeautifulChoices(subNo,0,pms); %practice=0: actual task
end
%BeautifulChoices(subNo,1,choiceDir,pms.patternCB,pms.blockCB); %practice
%[~,choiceSZ,choiceCondition,bonus]=BeautifulChoices(subNo,0,choiceDir,pms.patternCB,pms.blockCB); % actual task

cd(pms.rootdir) %back to rootdirectory 

%% 3. REDO
%% 3a create directories 
pms.redologdir = fullfile(pms.rootdir,'RedoLog'); %create new folder in current directory: ...\RedoLog

if ~exist(pms.redologdir,'dir');
    mkdir(pms.redologdir);
end

cd(fullfile(pms.inccwdir)) %go to colorwheel directory

%% 3b select random choice for redo

[task,taskName,amount]= selectRedo(dataChoice,pms);

%% 3c show redo task
 %load('tryred0.mat');
 
cd(fullfile(pms.inccwdir)) %go to colorwheel directory
 
% redo task
[dataRedo] = BeautifulColorwheelRedo(subNo,3,pms,taskName,task,amount,bonus);

cd(pms.rootdir) %back to rootdirectory 

% close screen
 Screen('CloseAll');
 ShowCursor; % display mouse cursor again
 ListenChar(0); % allow keystrokes to Matlab
 Priority(0); % return Matlab's priority level to normal
 Screen('Preference','TextAlphaBlending',0); 

