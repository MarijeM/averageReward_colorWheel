% Preliminary stuff
% Clear Matlab/Octave window:
clc;


% check for Opengl compatibility, abort otherwise:
AssertOpenGL;

bgColor   = [200 200 200];

HideCursor;

pms=struct();
pms.background = [200 200 200];
pms.patternSize = 100;  
pms.patternCB=1;


rewardContext = 0;

% Get information about the screen and set general things
Screen('Preference', 'SuppressAllWarnings',0);
Screen('Preference', 'SkipSyncTests', 1);
rect = Screen('Rect',0);

pms.xCenter = rect(3)/2;
pms.yCenter = rect(4)/2; 

% Creating screen etc.
[myScreen, rect] = Screen('OpenWindow', 0, bgColor);


[questiondata] = slideScaleQuestion(myScreen, rect, pms, rewardContext, 'device', 'mouse', 'scalaposition', 0.9, 'startposition', 'center', 'displayposition', true);


Screen('CloseAll') 