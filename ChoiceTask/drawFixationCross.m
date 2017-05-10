function drawFixationCross(wPtr,rect) 
%DP:you're right! it was one of my first, trying to make everything
%general

% Screen('Preference','SkipSyncTests',1); 
crossLength=10;
crossColor=[0 0 0];
crossWidth=3;
 
 crossLines=[-crossLength,0;crossLength,0; 0, -crossLength; 0, crossLength];
 crossLines=crossLines';
 
%  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));
 
 xCenter=rect(3)/2;
 yCenter=rect(4)/2;
 
 Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[xCenter,yCenter]);
%  Screen('Flip',wPtr);
%  KbStrokeWait;
%  clear Screen
end
%  