%%%%%%%Colorwheel behavioral study script%%%%%%%%%%
% Used for study 3017048.03 Trait Impulsivity and Motivational Control
% In this study, the regular delayed match to sample color wheel task, the
% choice task belonging to the colorwheel task, the redo, following on the
% choice task, and a new, incentivized colorwheel task is used, where the
% colorwheel trials are preceded by a high or low reward. 

clear all 
close all

subNo= input('Subject ID: '); %request user input: subject ID
sessionNo=input('Session:  '); %request session: 1 or 2
checked=input(sprintf('participant number is %d and session %d',subNo,sessionNo)); %returns answer

%% create directories.
pms.rootdir         = pwd; %current directory
pms.logdir          = fullfile(pms.rootdir,'Log'); %create new folder in current directory: ...\log
pms.cwdir           = fullfile(pms.rootdir,'ColorwheelTask');
pms.chdir           = fullfile(pms.rootdir,'ChoiceTask');
pms.inccwdir        = fullfile(pms.rootdir,'IncentivizedColorwheelTask');

if ~exist(pms.logdir,'dir') %if subject x does not exist
    mkdir(pms.rootdir,'Log'); %make directory
end

%% Colorwheel and choice tasks
if sessionNo == 1 
    %color wheel directory
    pms.colordir=fullfile(pms.logdir,'Colorwheel'); %...\log\colorwheel
    if ~exist(pms.colordir,'dir')
        mkdir(pms.logdir,'Colorwheel');
    end
    pms.subdirCW = fullfile(pms.colordir,sprintf('Colorwheel_sub_%d_session_%d',subNo,sessionNo)); %subject specific folder
    if ~exist(pms.subdirCW,'dir')
        mkdir(pms.colordir,sprintf('Colorwheel_sub_%d_session_%d',subNo,sessionNo));
    else
        errordlg('Caution! Participant file name already exists!','Filename exists');
        return
    end

    %choice directory
    pms.choiceDir = fullfile(pms.logdir,'ChoiceTask');
    if ~exist(pms.choiceDir,'dir')
        mkdir(pms.logdir, 'choiceTask');
    end
    pms.subdirCh = fullfile(pms.choiceDir,sprintf('Choices_sub_%d_session_%d',subNo,sessionNo));
    if ~exist(pms.subdirCh,'dir')
        mkdir(pms.choiceDir,sprintf('Choices_sub_%d_session_%d',subNo,sessionNo));
    else
        errordlg('Caution! Participant file name already exists!','Filename exists');
        return
    end

    %%% colorwheel task
    cd(pms.cwdir)
    disp('TASK 1: Colorwheel');          % display which task starts.
    WaitSecs(2) %show message for 2 sec

    BeautifulColorwheel(subNo,1,pms,sessionNo)%practice=1
    BeautifulColorwheel(subNo,0,pms,sessionNo) %practice=0 

    %%% choice task
    cd(pms.chdir)
    BeautifulChoices(subNo,1,pms,sessionNo); %practice
    [~,choiceSZ,choiceCondition,bonus]=BeautifulChoices(subNo,0,pms,sessionNo); % actual task

    %%% redo 
    cd(pms.cwdir)
    BeautifulColorwheel(subNo,2,pms,choiceSZ,choiceCondition,bonus) %redo; choiceSZ = 3 or 4; choicecondition: 0=ignore, 2=update; bonus = amount in €
 

%% incentivized colorwheel task
elseif sessionNo == 2 
    %repeat colorwheel directory
    pms.colordir=fullfile(pms.logdir,'Colorwheel'); %...\log\colorwheel
    pms.subdirCW = fullfile(pms.colordir,sprintf('Colorwheel_sub_%d_session_1',subNo)); %subject specific folder
    
    %incentivized colorwheel directory = colorwheel including reward
    pms.incColordir=fullfile(pms.logdir,'IncentivizedColorwheel'); %...\log\colorwheel
    if ~exist(pms.incColordir,'dir')
        mkdir(pms.logdir,'IncentivizedColorwheel'); 
    end
    pms.subdirICW = fullfile(pms.incColordir,sprintf('IncentivizedColorwheel_sub_%d_session_%d',subNo,sessionNo));
    if ~exist(pms.subdirICW,'dir')
        mkdir(pms.incColordir,sprintf('IncentivizedColorwheel_sub_%d_session_%d',subNo,sessionNo));
    else
        errordlg('Caution! Participant file name already exists!','Filename exists');
        return
    end

    % incentivized colorwheel task 
    cd(pms.inccwdir)
    disp('TASK: Colorwheel');          % display which task starts.
    WaitSecs(2) %show message for 2 sec

    BeautifulColorwheel(subNo,1,pms,sessionNo) %practice=1
    BeautifulColorwheel(subNo,0,pms,sessionNo) %practice=0
end 

cd(pms.rootdir)
