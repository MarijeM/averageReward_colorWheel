function [subNo,dataFilename,dataFilenamePrelim,practice,session]=getInfoChoice(varargin)
%gives subject number

switch nargin
    case 0
prompt1='subject number:';
subNo=input(prompt1);

prompt2='practice? Press 1 for practice and 0 for real task.';
practice=input(prompt2);

prompt4='session: ';
session=input(prompt4);

switch practice
    case 1
        prompt3=sprintf('participant %d will start practice now, session %d.',subNo,session);
    case 0
        prompt3=sprintf('participant %d will start the choice task now,session %d.',subNo,session);
end

      
 
checked=input(prompt3);
    case 3
        subNo=varargin{1};
        practice=varargin{2};
        session=varargin{3};
end
        
if practice==0
    dataFilename = sprintf('ColorFunChoice_s%d_ses%d.mat',subNo,session);
    dataFilenamePrelim=sprintf('CFChoice_s%d_ses%d_pre.mat',subNo,session);
elseif practice==1
    dataFilename = sprintf('ColorFunChoice_s%d_ses%d_practice.mat',subNo,session);
    dataFilenamePrelim=sprintf('CFChoice_s%d_ses%d_pre_practice.mat',subNo,session);
end

if exist (dataFilename,'file')
    randAttach = round(rand*10000);
    dataFilename = strcat(dataFilename, sprintf('_%d.mat',randAttach));  
    if exist (dataFilenamePrelim, 'file')
        dataFilenamePrelim = strcat(dataFilenamePrelim, sprintf('_%d.mat',randAttach));
    end
end
end

