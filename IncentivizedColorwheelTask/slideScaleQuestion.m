function [position, RT, answer] = slideScaleQuestion(screenPointer, rect, varargin)
%SLIDESCALE This funtion draws a slide scale on a PSYCHTOOLOX 3 screen and returns the
% position of the slider spaced between -100 and 100 as well as the rection time and if an answer was given.
%
%   Usage: [position, secs] = slideScale(ScreenPointer, rect, varargin)
%   Mandatory input:
%    ScreenPointer  -> Pointer to the window.
%    rect           -> Double contatining the screen size.
%                      Obtained with [myScreen, rect] = Screen('OpenWindow', 0);
%
%   Varargin:
%    'linelength'     -> An integer specifying the lengths of the ticks in
%                        pixels. The default is 10.
%    'width'          -> An integer specifying the width of the scala line in
%                        pixels. The default is 3.
%    'startposition'  -> Choose 'right', 'left' or 'center' start position.
%                        Default is center.
%    'scalalength'    -> Double value between 0 and 1 for the length of the
%                        scale. The default is 0.9.
%    'scalaposition'  -> Double value between 0 and 1 for the position of the
%                        scale. 0 is top and 1 is bottom. Default is 0.8.
%    'device'         -> A string specifying the response device. Either 'mouse' 
%                        or 'keyboard'. The default is 'mouse'.
%    'responsekey'    -> String containing name of the key from the keyboard to log the
%                        response. The default is 'return'.
%    'slidecolor'     -> Vector for the color value of the slider [r g b] 
%                        from 0 to 255. The default is red [255 0 0].
%    'scalacolor'     -> Vector for the color value of the scale [r g b] 
%                        from 0 to 255.The default is black [0 0 0].
%    'displaypoition' -> If true, the position of the slider is displayed. 
%                        The default is false. 
%
%   Output:
%    'position'      -> Deviation from zero, scaled form 0.50 to 2.50.
%    'RT'            -> Reaction time in milliseconds.
%    'answer'        -> If 0, no answer has been given. Otherwise this
%                       variable is 1.
%   
%  Based on SlideScale script written by:
%   Author: Joern Alexander Quent
%   e-mail: alexander.quent@rub.de
%
%% Parse input arguments
question  = 'How much money would you give up to not do \n\n the Update trials with one coloured rectangle again?';
endPoints = {'0.50 euros', '2.50 euros'}; % left and right endpoints of the scale 

% Default values
center        = round([rect(3) rect(4)]/2);
lineLength    = 10;
width         = 3;
scalaLength   = 0.9;
scalaPosition = 0.8;
newscalaPosition = scalaPosition-0.2;
sliderColor    = [255 255 255];
scaleColor    = [0 0 0];
device        = 'mouse';
responseKey   = KbName('return');
GetMouseIndices;
startPosition = 'center';
displayPos    = true;  


i = 1;
while(i<=length(varargin))
    switch lower(varargin{i})
        case 'linelength'
            i             = i + 1;
            lineLength    = varargin{i};
            i             = i + 1;
        case 'width'
            i             = i + 1;
            width         = varargin{i};
            i             = i + 1;
        case 'startposition'
            i             = i + 1;
            startPosition = varargin{i};
            i             = i + 1;
        case 'scalalength'
            i             = i + 1;
            scalaLength   = varargin{i};
            i             = i + 1;
        case 'scalaposition'
            i             = i + 1;
            scalaPosition = varargin{i};
            i             = i + 1;
        case 'device' 
            i             = i + 1;
            device = varargin{i};
            i             = i + 1;
        case 'responsekey'
            i             = i + 1;
            responseKey   = KbName(varargin{i});
            i             = i + 1;
        case 'slidecolor'
            i             = i + 1;
            sliderColor    = varargin{i};
            i             = i + 1;
        case 'scalacolor'
            i             = i + 1;
            scaleColor    = varargin{i};
            i             = i + 1;
        case 'displayposition'
            i             = i + 1;
            displayPos    = varargin{i};
            i             = i + 1;
    end
end

% Sets the default key depending on choosen device
if strcmp(device, 'mouse')
    responseKey   = 1; % X mouse button
end

%% Checking number of screens and parsing size of the global screen
screens       = Screen('Screens');
if length(screens) > 1 % Checks for the number of screens
    screenNum        = 1;
else
    screenNum        = 0;
end
globalRect          = Screen('Rect', screenNum);

%% Coordinates of scale lines and text bounds
if strcmp(startPosition, 'right')
    x = globalRect(3)*scalaLength;
elseif strcmp(startPosition, 'center')
    x = globalRect(3)/2;
elseif strcmp(startPosition, 'left')
    x = globalRect(3)*(1-scalaLength);
else
    error('Only right, center and left are possible start positions');
end
SetMouse(round(x), round(rect(4)*newscalaPosition), screenPointer, 1);
midTick    = [center(1) rect(4)*newscalaPosition - lineLength - 5 center(1) rect(4)*newscalaPosition  + lineLength + 5];
leftTick   = [rect(3)*(1-scalaLength) rect(4)*newscalaPosition - lineLength rect(3)*(1-scalaLength) rect(4)*newscalaPosition  + lineLength];
rightTick  = [rect(3)*scalaLength rect(4)*newscalaPosition - lineLength rect(3)*scalaLength rect(4)*newscalaPosition  + lineLength];
horzLine   = [rect(3)*scalaLength rect(4)*newscalaPosition rect(3)*(1-scalaLength) rect(4)*newscalaPosition];
textBounds = [Screen('TextBounds', screenPointer, endPoints{1}); Screen('TextBounds', screenPointer, endPoints{2})];

% Calculate the range of the scale, which will be need to calculate the
% position
scaleRange        = round(rect(3)*(1-scalaLength)):round(rect(3)*scalaLength); % Calculates the range of the scale
scaleRangeShifted = round((scaleRange)-mean(scaleRange));                      % Shift the range of scale so it is symmetrical around zero

%% Loop for scale loop
t0                         = GetSecs;
answer                     = 0;
while answer == 0
    [x,y,buttons,focus,valuators,valinfo] = GetMouse(screenPointer, 1);
    if x > rect(3)*scalaLength
        x = rect(3)*scalaLength;
    elseif x < rect(3)*(1-scalaLength)
        x = rect(3)*(1-scalaLength);
    end
    
    % Drawing the question as text
    Screen('Textsize', screenPointer, 34);
    Screen('Textfont', screenPointer, 'Times New Roman');
    DrawFormattedText(screenPointer, question, 'center', rect(4)*0.2); 
    
    % Drawing the end points of the scala as text
    DrawFormattedText(screenPointer, endPoints{1}, leftTick(1, 1) - textBounds(1, 3)/2,  rect(4)*(newscalaPosition-0.1)+40, [],[],[],[],[],[],[]); % Left point
    DrawFormattedText(screenPointer, endPoints{2}, rightTick(1, 1) - textBounds(2, 3)/2,  rect(4)*(newscalaPosition-0.1)+40, [],[],[],[],[],[],[]); % Right point
    
    % Drawing the scala
    Screen('DrawLine', screenPointer, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
    Screen('DrawLine', screenPointer, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
    Screen('DrawLine', screenPointer, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
    Screen('DrawLine', screenPointer, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
    
    % The slider
    Screen('DrawLine', screenPointer, sliderColor, x, rect(4)*newscalaPosition - lineLength, x, rect(4)*newscalaPosition  + lineLength, width);
    
    % Caculate position
    position = (x)-min(scaleRange);                       % Calculates the deviation from 0.
    position = round(((position/(max(scaleRange)-min(scaleRange)))*2 + 0.5),2); % Converts the value to 0.5-2.5 scale
    
    % Display position
    if displayPos
        DrawFormattedText(screenPointer, num2str(round(position,2)), 'center', rect(4)*(newscalaPosition+0.05)); 
    end
    
    % Flip screen
    onsetStimulus = Screen('Flip', screenPointer);
    
    % Check if answer has been given
    if strcmp(device, 'mouse')
        secs = GetSecs;
        if buttons(responseKey) == 1
            answer = 1;
        end
    elseif strcmp(device, 'keyboard')
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(responseKey) == 1
            answer = 1;
        end
    else
        error('Unknown device');
    end
    
end
%% Wating that all keys are released and delete texture
KbReleaseWait; %Keyboard
KbReleaseWait(1); %Mouse
%% Calculating the rection time and the position
RT                = (secs - t0)*1000;                                          % converting RT to millisecond
end