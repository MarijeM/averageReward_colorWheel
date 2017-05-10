function drawFixationCross(wPtr,rect,varargin) 
%% function that draws a fixation cross in the center of the screen. It requires monitor number (wPtr) and
% screen dimensions (rect) as input. You may also provide as input the length, width and color of the cross,
% otherwise defaults are set to 10,3 and black. 
%     
% SYNTAX
% 
% drawFixationCross(wPtr,rect) 
% wPtr:           monitor number provided in main script by Screen('Open Window') PTB function.
% rect:           dimensions of screen provided in main script by Screen('Open Window') PTB function.
% 
% drawFixationCross(wPtr,rect,lineLength) 
% lineLength:     length of cross lines
% 
% drawFixationCross(wPtr,rect,lineLength,lineThickness)
% lineThickness:  thickness of fixation cross lines   
% 
% drawFixationCross(wPtr,rect,lineLength,lineThickness,crossColor) 
% crossColor:      fixation cross color in RGB values
% 

%use defaults if input is not provided
switch nargin
    case 2
        lineLength=10;
        crossColor=[0 0 0];
        lineThickness=3;
    case 3
        lineLength=varargin{1};
        crossColor=[0 0 0];
        lineThickness=3;
    case 4
        lineLength=varargin{1};
        lineThickness=varargin{2};    
        crossColor=[0 0 0];
    case 5
        lineLength=varargin{1};     
        lineThickness=varargin{2};    
        crossColor=varargin{3};
end

%define dimensions
 crossLines=[-lineLength,0;lineLength,0; 0, -lineLength; 0, lineLength];
 crossLines=crossLines';
 
%defince screen center
 xCenter=rect(3)/2;
 yCenter=rect(4)/2;
 
%Draw fixation cross in PTB
 Screen('DrawLines',wPtr,crossLines,lineThickness,crossColor,[xCenter,yCenter]);
end
