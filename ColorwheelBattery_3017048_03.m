%%%%%%%Colorwheel behavioral study script%%%%%%%%%%
% Used for study 3017048.03 Trait Impulsivity and Motivational Control
% In this study, the regular delayed match to sample color wheel task, the
% choice task belonging to the colorwheel task, the redo, following on the
% choice task, and a new, incentivized colorwheel task is used, where the
% colorwheel trials are preceded by a high or low reward. 

clear; 
clc;

subNo= input('Subject ID: '); %request user input: subject ID
checked=input(sprintf('participant number is %d',subNo)); %returns answer

%% create directories.
 

% incentivized colorwheel task 
cd(pms.inccwdir);
disp('TASK: Color Wheel');          % display which task starts.
WaitSecs(2); %show message for 2 sec

[~,~,~,~,pms] = BeautifulColorwheel(subNo,1,pms); %practice=1 
BeautifulColorwheel(subNo,2,pms); %practice=2: practice with cues
BeautifulColorwheel(subNo,0,pms); %practice=0

cd(pms.rootdir)
