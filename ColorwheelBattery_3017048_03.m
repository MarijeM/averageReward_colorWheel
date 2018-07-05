%%%%%%%Colorwheel behavioral study script%%%%%%%%%%
% Used for study 3017048.03 Trait Impulsivity and Motivational Control
% In this study, the regular delayed match to sample color wheel task, the
% choice task belonging to the colorwheel task, the redo, following on the
% choice task, and a new, incentivized colorwheel task is used, where the
% colorwheel trials are preceded by a high or low reward. 

clear; 
clc;
rng('shuffle');

subNo= input('Subject ID: '); %request user input: subject ID
checked=input(sprintf('participant number is %d',subNo)); %returns answer
pms.blockCB= input('Which block first?\n\nPress 0 for Ignore\nPress 2 for Update\n\n'); %request user input: block order
if pms.blockCB == 0
    firstBlock = 'Ignore';
elseif pms.blockCB == 2
    firstBlock = 'Update';
end 
checked=input(sprintf('Block order: first %s',firstBlock)); %returns answer


%% create directories.
pms.rootdir         = pwd; %current directory
pms.logdir          = fullfile(pms.rootdir,'Log'); %create new folder in current directory: ...\log
pms.inccwdir        = fullfile(pms.rootdir,'IncentivizedColorwheelTask');

if ~exist(pms.logdir,'dir') %if subject x does not exist
    mkdir(pms.rootdir,'Log'); %make directory
end

%% incentivized colorwheel task
%incentivized colorwheel directory (= colorwheel including reward)
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

%% incentivized colorwheel task (when debugging and wanting to run only 1 phase, see next section and skip this one)
cd(pms.inccwdir);
disp('TASK: Color Wheel');          % display which task starts.
WaitSecs(2); %show message for 2 sec
[dataPractice,~,~,~,pms] = BeautifulColorwheel(subNo,1,pms); %practice=1: color vision task and practicing task
[dataPracticeRewards,~,~,~,~] = BeautifulColorwheel(subNo,2,pms); %practice=2: instructions reward and eyetracking + practice
dataPr = [dataPractice; dataPracticeRewards];
BeautifulColorwheel(subNo,0,pms,dataPr); %practice=0: 50/50 task + instructions majority update/ignore blocks + task

cd(pms.rootdir)


%% debugging: either practice phase 1, 2 or 0, without needing the previous ones; just comment out the phase you want to debug
% cd(pms.inccwdir);
% [~,~,~,~,pms] = BeautifulColorwheel(subNo,1,pms,[], 1); %practice=1 
% BeautifulColorwheel(subNo,2,pms, [],1); %practice=2: practice with rewards
% BeautifulColorwheel(subNo,0,pms,[], 1); %practice=0
% 
% cd(pms.rootdir)