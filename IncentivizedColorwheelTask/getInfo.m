function [subNo,dataFilename,dataFilenamePrelim,practice]=getInfo(varargin)
%asks for subject number and practice(0 for no practice, 1 for practice)
%via keyboard and provides subNo, practice status and file names for data.

subNo=varargin{1};
practice=varargin{2};


if practice==0
    dataFilename = sprintf('ColorFun_s%d.mat',subNo);
    dataFilenamePrelim=sprintf('CF_s%d_pre.mat',subNo);
elseif practice==1
    dataFilename = sprintf('ColorFun_s%d_practice.mat',subNo);
    dataFilenamePrelim=sprintf('CF_s%d_pre_practice.mat',subNo);
end

if exist (dataFilename,'file')
    randAttach = round(rand*10000);
    dataFilename = strcat(dataFilename, sprintf('_%d.mat',randAttach));
end

