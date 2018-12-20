function [subNo,dataFilename,dataFilenamePrelim,practice,pms]=getInfoChoice(varargin)
%gives subject number

switch nargin
  case 0
  % ask for subject number
    subNo= input('Subject ID: '); %request user input: subject ID
    checked=input(sprintf('participant number is %d',subNo)); %returns answer

  % ask for counterbalancing reward: 0 is no reward, reward context, 1 is reward, no
  % reward context
    pms.blockCB = input('\n\nWhich block first?\n\nPress 0 for Low reward context\nPress 1 for High reward context:   '); %request user input: block order
    if pms.blockCB == 0
        firstBlock = 'Low';
    elseif pms.blockCB == 1
        firstBlock = 'High';
    end 
    checked=input(sprintf('Block order: first %s',firstBlock)); %returns answer

  % ask for counterbalancing pattern: 1 is dotted, 2 is checkerboard
    pms.patternCB = input('\n\nWhich pattern for the Low reward context?\n\nPress 1 for Dotted\nPress 2 for Checkerboard:   '); %request user input: pattern association
    if pms.patternCB == 1
        patternLow = 'Dotted';
    elseif pms.patternCB == 2
        patternLow = 'Checkerboard';
    end 
    checked=input(sprintf('Pattern association: Low reward with %s',patternLow)); %returns answer

  % Show instructions and practice?
    pms.instructions = input('\n\nShow instructions and practice or not?\n\nPress 0 for no\nPress 1 for yes:   '); 
    if pms.instructions== 0
        Ins = 'Do not show instructions';
        practice = 0;
    elseif pms.instructions == 1
        Ins = 'Show instructions';
        practice = 1;
    end 
    checked=input(sprintf('%s',Ins)); %returns answer

    %prompt2='practice? Press 1 for practice and 0 for real task.';
    %practice=input(prompt2);
    %switch practice
    %    case 1
    %        prompt3=sprintf('participant %d will start practice now',subNo);
    %    case 0
    %        prompt3=sprintf('participant %d will start the choice task now',subNo);
    %end
    %checked=input(prompt3); %return 0 or 1 for practice
    
  case 3
    subNo=varargin{1};
    practice=varargin{2};
    pms =varargin{3};

end
        
if practice==0
    dataFilename = sprintf('ColorFunChoice_s%d.mat',subNo);
    dataFilenamePrelim=sprintf('CFChoice_s%d_pre.mat',subNo);
elseif practice==1
    dataFilename = sprintf('ColorFunChoice_s%d_practice.mat',subNo);
    dataFilenamePrelim=sprintf('CFChoice_s%d_pre_practice.mat',subNo);
end

if exist (dataFilename,'file')
    randAttach = round(rand*10000); %rouned number of random[0:1]*10000 to attach to filename if filename already existed for some reason, so no data gets lost
    dataFilename = strcat(dataFilename, sprintf('_%d.mat',randAttach));  
    if exist (dataFilenamePrelim, 'file')
        dataFilenamePrelim = strcat(dataFilenamePrelim, sprintf('_%d.mat',randAttach));
    end
end
end

