function [respX,respY,rtDecision, rtMovement, rtTotal,colortheta, correct,itrack]=probecolorwheel(pms,allRects,probeRectX,probeRectY,practice,probeColorCorrect,lureColor,rect,wPtr,g,p,trial, rewardContext)
% function that gives the colorwheel for the task and the probe of the colorwheel memory task
% Takes as inputs the number of colors displayed on the wheel. 
% respX                         x coordinates of response
% respY                         y coordinates of response
% rt                            response time
% colortheta                    struct with angles and corresponding colors on the colorwheel

% The colorwheel is constructed from two ovals. One is the wheel and the other an oval shape that masks the
% center of the wheel. The coordinates are related to each screen. The
% colors are created with arcs. Arc's size is reversely analogous
% to number of colors used. By default,the first arc starts at vertical (0 degrees) and adds
% on clockwise until the circle is completed. We introduce a shift every
% trial so that the colorwheel orientation changes. Colortheta is a struct with
% the angle of every color in the wheel and the corresponding color. 
% 
% 
% pms                           parameters defined in main script BeautifulColorwheel.m
% probeRectX                    x coordinate of center of probed rectangle, input from showtrial.m function
% probeRectY                    y coordinate of center of probed rectangle, input from showtrial.m function
% practice                      1 for practice, 0 for actual task, input from getInfo.m
% probeColorCorrect             color participants needed to remember, input from showtrial.m
% lureColor                     lure color (intervening for I, encoding for U),input from showtrial.m
% wheelStart                    begining of arc 
% 
% 
% functions called              [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,respX,respY)
%                               drawFixationCross(wPtr,rect)

% respDev provides the angle of the response made by the participant,the correct angle, the deviance
% of the response from the correct color and the radius of the circle created by the response of 
% the participant. We need the radius to estimate if they clicked on the colorwheel.
% 
% drawFixationCross displays the fixation cross in the center of the screen.

itrack = NaN; %defined here to be a NaN, in case it is not called and not specified below.
%center coordinates
centerX         = rect(3)/2;
centerY         = rect(4)/2;

%feedback messages
messageLate     = 'Please respond faster!';
messageColor    = [0 0 0]; %black
%Thickness of response arc
lineThickness   = 0.4;
lineColor       = [0 0 0];

probeThickness  = 3;
probeColor      = [0 0 0];

%rects that form the colorwheel are proportional to screen size
probeRect       = [100 100 200 200];
insideRect      = [rect(1) rect(2) 0.67*rect(4) 0.67*rect(4)]; %the white oval coordinates
outsideRect     = [rect(1) rect(2) 0.9*rect(4) 0.9*rect(4)]; %the wheel coordinates
insideRectColor = pms.background;
%center all rects 
outsideRect     = CenterRectOnPoint(outsideRect,centerX, centerY);
insideRect      = CenterRectOnPoint(insideRect,centerX,centerY);
probeRect       = CenterRectOnPoint(probeRect,probeRectX,probeRectY);

%define colors in RGB values
colors          = hsv(pms.numWheelColors)*255;

%each arc represents one color and shapes a circle
colorangle      = 360/length(colors);  

%We want to shift the orientation of the colorwheel in every trial so we use an offset. To keep
%it same for every participant we have saved the offset (using formula starts = randi(360,pms.numTrials,pms.numBlocks) 
%and we load it.
if practice==0
    wheelStart  = trial(g,p).wheelValues;
else 
    load starts;
    wheelStart  = starts(g,p);
end 
 

%defines locations of every color arc
wheelAngles         = wheelStart:colorangle:360+wheelStart;

%theta represents the angle for every color
theta = zeros(length(colors),1);
       for index = 1:length(colors)   
           theta(index)=(360*index)/length(colors);
       end
%colortheta is a structure with number of Colors fields linking "color" to "angle" of presentation
 
colortheta  = struct; 

for n=1:length(colors)
   colortheta(n).color = colors(n,:); %pick color n from all colors
   colortheta(n).theta = theta(n)+wheelStart;    %pick angle n from all angles and add initial shift (wheelStart)
end


% create parameters dotted background pattern

[screenXpixels,screenYpixels]=Screen('WindowSize', wPtr); 

dim = 10;
[x, y] = meshgrid(-dim:1:dim, -dim:1:dim); %create base dot coordinates

pixelScale = screenYpixels / (dim);
     x = x .* pixelScale;
     y = y .* pixelScale; %scale grid by screen size

numDots = numel(x);
dotPositionMatrix = [reshape(x, 1, numDots); reshape(y, 1, numDots)]; %create matrix of positions for dots 

% create parameters checkerboard background pattern

[xCenter, yCenter] = RectCenter(rect);

dim = 101;
baseRect = [0 0 dim dim]; %creat base rectangle

npatches = 9;
[xPos, yPos] = meshgrid(-npatches:1:npatches, -npatches:1:npatches); %make coordinates for grid of squares

[s1, s2] = size(xPos);
numSquares = s1 * s2;
xPos = reshape(xPos, 1, numSquares); 
yPos = reshape(yPos, 1, numSquares); %reshape matrices of coordinates into vector

xPosCenter = xPos .* dim + xCenter;
yPosCenter = yPos .* dim + yCenter; %scale grid spacing to size of squares and centre

squareColors = [255 200; 200 255];
bwColors = repmat(squareColors, (npatches+1), (npatches+1));
bwColors = bwColors(1:end-1, 1:end-1);
bwColors = reshape(bwColors, 1, numSquares);
bwColors = repmat(bwColors, 3, 1); %set colors of squares

rectCenter = nan(4, 3); %make rectangle coordinates
for i = 1:numSquares 
    rectCenter(:, i) = CenterRectOnPointd(baseRect,...
        xPosCenter(i), yPosCenter(i));
end

%% Colorwheel 

if practice==0 || practice==2
     if pms.patternCB==1   %counterbalancing pattern
        if rewardContext==0
            Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
        elseif rewardContext==1
            Screen('FillRect', wPtr, bwColors, rectCenter);
        end
     elseif pms.patternCB==2
        if rewardContext==0
            Screen('FillRect', wPtr, bwColors, rectCenter);
        elseif rewardContext==1
            Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
        end
     end
end

for ind=1:length(colors)
  Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle);
end

%ring created with inside circle
Screen('FillOval',wPtr,insideRectColor,insideRect);
%all rectangles
Screen('FrameRect',wPtr,probeColor,allRects);
%probed rectangle 
Screen('FrameRect', wPtr, probeColor, probeRect,probeThickness);
drawFixationCross(wPtr,rect);

probeOnset = Screen('Flip',wPtr);

%show and set the mouse in the center
ShowCursor('Arrow');
SetMouse(centerX,centerY,wPtr);

movement = 0;
response = 0;
if mod(g,10)==0 %if devisible by 10
   median_rtMovement = pms.median_rtMovement-0.1; % in 10% of cases, every 10th trial, participants have 100ms less to reach the wheel, to promote fast responding
else 
   median_rtMovement = pms.median_rtMovement; 
end

while movement == 0 && GetSecs-probeOnset < pms.maxRT %while they did not start moving the mouse, but within maxRT
    [x,y,~]     = GetMouse(wPtr); %constantly read mouse position
    radius      = sqrt((x-centerX)^2+(y-centerY)^2);  % calculate radius based on x and y coordinate of the mouse      
    if radius > 25 %if they move far enough away from the center, time starts and we measure how long their motor response takes. They are instructed to only start moving the mouse once they have made a decision. 
        startResponse = GetSecs;
        rtDecision  = startResponse - probeOnset;
        movement = 1;
        while response == 0 && GetSecs-startResponse < median_rtMovement %while they did not reach the color wheel, but still within max movement time
            [x,y,~]     = GetMouse(wPtr); %constantly read mouse position
            radius      = sqrt((x-centerX)^2+(y-centerY)^2);                

            if radius > abs(insideRect(1)-insideRect(3))/2 %when the mouse reaches the color wheel
                RT          = GetSecs; 
                respX       = x;
                respY       = y;

                rtMovement  = RT - startResponse;
                rtTotal     = RT - probeOnset;
                response    = 1;
                HideCursor;

                [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect); %calculate deviance 

                % draw the color wheel + response 
                if practice==0 || practice==2
                  if pms.patternCB==1   %counterbalancing pattern
                      if rewardContext==0
                          Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
                      elseif rewardContext==1
                          Screen('FillRect', wPtr, bwColors, rectCenter);
                      end
                  elseif pms.patternCB==2
                      if rewardContext==0
                          Screen('FillRect', wPtr, bwColors, rectCenter);
                      elseif rewardContext==1
                          Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
                      end
                  end
                end
                
                for ind=1:length(colors)
                    Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle); % draw color wheel
                end
                Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2); % draw line where they reached the wheel
                Screen('FillOval',wPtr,pms.background,insideRect); % grey middle oval
                Screen('FrameRect',wPtr,probeColor,allRects); % draw squares
                Screen('FrameRect', wPtr, probeColor, probeRect,probeThickness); %draw probed square
                drawFixationCross(wPtr,rect);
                Screen('Flip',wPtr);
                WaitSecs(pms.feedbackDuration);  
            end 
        end       
    end 
end 
HideCursor();

%% Feedback
% if response==1 participants responded
correct = 0;
if response==1
    %during practice a second line appears indicating the correct response. The line is
    %drawn as a small arc of 0.4 degrees
    if practice==0 && pms.cutoff==1
        if trial(g,p).type==0 && trial(g,p).setSize==pms.maxSetsize(1) && abs(respDif) <=pms.minAcc_I_easy
            correct = 1;
        elseif trial(g,p).type==0 && trial(g,p).setSize==pms.maxSetsize(2) && abs(respDif) <=pms.minAcc_I_hard
            correct = 1;
        elseif trial(g,p).type==2 && trial(g,p).setSize==pms.maxSetsize(1) && abs(respDif) <=pms.minAcc_U_easy
            correct = 1;
        elseif trial(g,p).type==2 && trial(g,p).setSize==pms.maxSetsize(2) && abs(respDif) <=pms.minAcc_U_hard
            correct = 1; 
        end
    else
        if abs(respDif) <=pms.minAcc
            correct = 1;
        end   
    end
    if practice~=0 && practice~=3
        if practice==2
           if pms.patternCB==1   %counterbalancing pattern
                if rewardContext==0
                   Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
                elseif rewardContext==1
                   Screen('FillRect', wPtr, bwColors, rectCenter);
                end
           elseif pms.patternCB==2
                if rewardContext==0
                   Screen('FillRect', wPtr, bwColors, rectCenter);
                elseif rewardContext==1
                   Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
                end
           end
        end
        
        for ind=1:length(colors)
            Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle);
        end
        %their response
        Screen('FillArc',wPtr,lineColor,outsideRect,tau-lineThickness/2,lineThickness/2);
        Screen('FillArc',wPtr,lineColor,outsideRect,thetaCorrect-lineThickness/2,lineThickness/2);
        Screen('FillOval',wPtr,insideRectColor,insideRect);
        Screen('FrameRect',wPtr,probeColor,allRects);
        Screen('FrameRect', wPtr, probeColor, probeRect,probeThickness);
        
        %feedback if they are +-10 degrees from target color
        if abs(respDif) <=pms.minAcc
            Screen('TextSize',wPtr,15);
            message = sprintf('Good Job! you deviated only %d degrees',abs(round(respDif)));
            DrawFormattedText(wPtr, message, 'center', 'center', messageColor);
        else
            %otherwise no feedback
            drawFixationCross(wPtr,rect);
        end
        Screen('Flip',wPtr);
        WaitSecs(pms.feedbackDurationPr);
    end %if practice~=0
elseif movement==1 && mod(g,10)==0 %on the faster trials, participants response will be shown if they have started moving, even though they havent reached the wheel yet (response is angle at latest timepoint)
    respX       = x; %take last x as response
    respY       = y; %take last y as response
    rtMovement  = NaN;
    rtTotal     = NaN;
    [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect); %calculate deviance 
    if practice~=0 && abs(respDif) <=pms.minAcc
        correct = 1; 
    elseif practice~=0 && abs(respDif)>pms.minAcc
        correct = 0; 
    elseif pms.cutoff==1 && trial(g,p).type==0 && trial(g,p).setSize==pms.maxSetsize(1) && abs(respDif) <=pms.minAcc_I_easy
        correct = 1;
    elseif pms.cutoff==1 && trial(g,p).type==0 && trial(g,p).setSize==pms.maxSetsize(2) && abs(respDif) <=pms.minAcc_I_hard
        correct = 1;        
    elseif pms.cutoff==1 && trial(g,p).type==2 && trial(g,p).setSize==pms.maxSetsize(1) && abs(respDif) <=pms.minAcc_U_easy
        correct = 1;
    elseif pms.cutoff==1 && trial(g,p).type==2 && trial(g,p).setSize==pms.maxSetsize(2) && abs(respDif) <=pms.minAcc_U_hard
        correct = 1;
    end 
    % draw the color wheel + response 
    for ind=1:length(colors)
        Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle); % draw color wheel
    end
    if practice==0 || practice==2
      if pms.patternCB==1   %counterbalancing pattern
         if rewardContext==0
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
         elseif rewardContext==1
             Screen('FillRect', wPtr, bwColors, rectCenter);
         end
      elseif pms.patternCB==2
         if rewardContext==0
             Screen('FillRect', wPtr, bwColors, rectCenter);
         elseif rewardContext==1
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
         end
      end
    end
    Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2); % draw line where they reached the wheel
    Screen('FillOval',wPtr,pms.background,insideRect); % grey middle oval
    Screen('FrameRect',wPtr,probeColor,allRects); % draw squares
    Screen('FrameRect', wPtr, probeColor, probeRect,probeThickness); %draw probed square
    drawFixationCross(wPtr,rect);
    Screen('Flip',wPtr);
    WaitSecs(pms.feedbackDuration);  
%if the participant started moving on time, but did not reach the wheel in time, movement is 1, but response is 0. 
elseif movement==1
    respX       = x; %take last x as response
    respY       = y; %take last y as response 
    rtMovement  = NaN;
    rtTotal     = NaN;
    if practice==0 || practice==2
      if pms.patternCB==1   %counterbalancing pattern
         if rewardContext==0
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
         elseif rewardContext==1
             Screen('FillRect', wPtr, bwColors, rectCenter);
         end
      elseif pms.patternCB==2
         if rewardContext==0
             Screen('FillRect', wPtr, bwColors, rectCenter);
         elseif rewardContext==1
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
         end
      end
    end
    for ind=1:length(colors)
        Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle);
    end
    Screen('FillOval',wPtr,insideRectColor,insideRect);
    Screen('TextSize',wPtr,15);
    DrawFormattedText(wPtr, messageLate, 'center', 'center', messageColor);
    Screen('Flip',wPtr);
    WaitSecs(pms.feedbackDuration);  
%%if the participant was too late movement is still 0, so respX, respY and rt
%are set to NaN. They receive feedback to respond faster. 
elseif movement==0    
    respX       = NaN;
    respY       = NaN;
    rtDecision  = NaN;
    rtMovement  = NaN;
    rtTotal     = NaN;    
    if practice==0 || practice==2
      if pms.patternCB==1   %counterbalancing pattern
         if rewardContext==0
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2); 
         elseif rewardContext==1
             Screen('FillRect', wPtr, bwColors, rectCenter);
         end
      elseif pms.patternCB==2
         if rewardContext==0
             Screen('FillRect', wPtr, bwColors, rectCenter);
         elseif rewardContext==1
             Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
         end
      end
    end
    for ind=1:length(colors)
        Screen('FillArc',wPtr,colors(ind,:),outsideRect,wheelAngles(ind),colorangle);
    end
    Screen('FillOval',wPtr,insideRectColor,insideRect);
    Screen('TextSize',wPtr,15);
    DrawFormattedText(wPtr, messageLate, 'center', 'center', messageColor);
    Screen('Flip',wPtr);
    WaitSecs(pms.feedbackDuration);  
end
end
              
                        


      




