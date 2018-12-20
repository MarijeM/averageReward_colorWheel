function [resp,onLeft,choiceOnset,choiceRT,onTop] = MshowChoiceTrial(wPtr,rect,rects,trial,adjDel,offerAmt,pms,data)
%%%% setup at the beginning of a trial
Screen('TextSize',wPtr,pms.txtSize);
Screen('TextFont',wPtr,pms.txtFont);
Screen('TextStyle',wPtr,pms.txtStyle);
    
easyTask = data.easyTask(trial);
hardTask = data.hardTask(trial);

% draw each offer onto its texture
tasks = pms.tasks;
ssT = cell2mat(tasks(easyTask));
llT = cell2mat(tasks(hardTask));

% determine which task is being discounting    
if adjDel == 1 
    ssA = sprintf('%.2f euros',offerAmt);
    llA = sprintf('%.2f euros',data.amt(trial));
else
    ssA = sprintf('%.2f euros',data.amt(trial));
    llA = sprintf('%.2f euros',offerAmt);
end

% positioning matrix
whichOrder = randi([1,4],1); 
rectMat = [1,3,2,4; 2,4,1,3; 3,1,4,2; 4,2,3,1];
ordMat = [1,1; 1,2; 2,1; 2,2];
onTop = ordMat(whichOrder,1); % 1 for amounts and 2 for tasks on top
onLeft = ordMat(whichOrder,2); % 1 for ss and 2 for ll

% create parameters dotted background pattern
     [screenXpixels,screenYpixels]=Screen('WindowSize', wPtr); 
     %create base dot coordinates
     dim = 10;
     [x, y] = meshgrid(-dim:1:dim, -dim:1:dim); 
     %scale grid by screen size
     pixelScale = screenYpixels / (dim);
         x = x .* pixelScale;
         y = y .* pixelScale; 
     %create matrix of positions for dots 
     numDots = numel(x);
     dotPositionMatrix = [reshape(x, 1, numDots); reshape(y, 1, numDots)];

% create parameters checkerboard background pattern
     [xCenter, yCenter] = RectCenter(rect);
     %creat base rectangle
     dim = 101;
     baseRect = [0 0 dim dim]; 
     %make coordinates for grid of squares
     npatches = 9;
     [xPos, yPos] = meshgrid(-npatches:1:npatches, -npatches:1:npatches); 
     %reshape matrices of coordinates into vector
     [s1, s2] = size(xPos);
     numSquares = s1 * s2;
       xPos = reshape(xPos, 1, numSquares); 
       yPos = reshape(yPos, 1, numSquares); 
     %scale grid spacing to size of squares and centre
     xPosCenter = xPos .* dim + xCenter;
     yPosCenter = yPos .* dim + yCenter; 
     %set colors of squares
     squareColors = [255 200; 200 255];
     bwColors = repmat(squareColors, (npatches+1), (npatches+1));
     bwColors = bwColors(1:end-1, 1:end-1);
     bwColors = reshape(bwColors, 1, numSquares);
     bwColors = repmat(bwColors, 3, 1); 
     %make rectangle coordinates
     rectCenter = nan(4, 3); 
     for i = 1:numSquares 
        rectCenter(:, i) = CenterRectOnPointd(baseRect,...
            xPosCenter(i), yPosCenter(i));
     end

% create parameters grey rectangles
   greyRectLeft = [rects(1,1:2),rects(3,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
   greyRectRight = [rects(2,1:2),rects(4,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
     
%% present choices on screen

% draw pattern
if pms.practice==0
  if pms.patternCB==1   %counterbalancing pattern
       if data.context(trial)==0
           Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2); %draw dots
       elseif data.context(trial)==1
           Screen('FillRect', wPtr, bwColors, rectCenter); %draw checkerboard
       end
  elseif pms.patternCB==2
       if data.context(trial)==0
           Screen('FillRect', wPtr, bwColors, rectCenter);
       elseif data.context(trial)==1
           Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2);
       end
  end 
end

% draw grey rectangles behind options
Screen('FillRect',wPtr,pms.background,greyRectLeft);
Screen('FillRect',wPtr,pms.background,greyRectRight);

% draw choice options
DrawFormattedText(wPtr,ssT,'center','center',pms.textCol,[],[],[],[],[],rects(rectMat(whichOrder,1),:)); 
DrawFormattedText(wPtr,ssA,'center','center',pms.textCol,[],[],[],[],[],rects(rectMat(whichOrder,2),:)); 
DrawFormattedText(wPtr,llT,'center','center',pms.textCol,[],[],[],[],[],rects(rectMat(whichOrder,3),:)); 
DrawFormattedText(wPtr,llA,'center','center',pms.textCol,[],[],[],[],[],rects(rectMat(whichOrder,4),:)); 

% add line to separate left and right halves of the screen
Screen('DrawLine',wPtr,pms.textCol,rect(3)/2,rect(4)/3,rect(3)/2,rect(4)*2/3,1);
        
% display the screen
offerOnset = Screen('Flip',wPtr,[],1);
choiceOnset = offerOnset-pms.exptOnset;

%printscreen without border
%    imageArray=Screen('GetImage',wPtr);
%    r=randi(100,1);
%    imwrite(imageArray,sprintf('newChoice%d.png',r),'png');

%% check response

    responded = [];
    sampleTime = offerOnset;

while isempty(responded) && (GetSecs() - offerOnset) < pms.chcDuration
    % check keyboard and CMU box
    [keyIsDown, ~, keyCode] = KbCheck([pms.keyboards]);
    
    if keyIsDown==1 % a response has just occurred
        key = KbName(keyCode);
        if any(ismember(key,[pms.allowedResps.left, pms.allowedResps.right])) % response was allowable
            responded = 1;
            respTimeStamp = GetSecs;
            choiceRT = respTimeStamp-offerOnset;
            if any(ismember(key,[pms.allowedResps.left])) && onLeft==1;  % left key was pressed and easy choice was on left
                resp = 1;
                respRect = [rects(1,1:2),rects(3,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
            elseif any(ismember(key,[pms.allowedResps.left])) && onLeft==2;  % left key was pressed and easy choice was on right
                resp = 2;
                respRect = [rects(1,1:2),rects(3,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
            elseif any(ismember(key,[pms.allowedResps.right])) && onLeft==1;  % right key was pressed and easy choice was on left
                resp = 2;
                respRect = [rects(2,1:2),rects(4,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
            elseif any(ismember(key,[pms.allowedResps.right])) && onLeft==2;  % right key was pressed and easy choice was on right
                resp = 1;
                respRect = [rects(2,1:2),rects(4,3:4)]+[-pms.ground/5,0,pms.ground/5,0];
            end
        end
    end
    
    buffer = pms.trlDuration - (GetSecs - offerOnset) - .75;
    WaitSecs(.001);
end

 % check to see if participant is too slow
    if isempty(responded);
       resp = 9;
       choiceRT = 0;
%       Screen('FillRect',wPtr,pms.background);
       if pms.practice==0
         if pms.patternCB==1   %counterbalancing pattern
              if data.context(trial)==0
                  Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2); %draw dots
              elseif data.context(trial)==1
                  Screen('FillRect', wPtr, bwColors, rectCenter); %draw checkerboard
              end
         elseif pms.patternCB==2
              if data.context(trial)==0
                  Screen('FillRect', wPtr, bwColors, rectCenter);
              elseif data.context(trial)==1
                  Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2);
              end
         end
         % draw grey rectangles behind options
         Screen('FillRect',wPtr,pms.background,greyRectLeft);
         Screen('FillRect',wPtr,pms.background,greyRectRight);
       end
       DrawFormattedText(wPtr,'Too slow!','center','center',pms.textCol); % draw too slow feedback
       buffer = pms.trlDuration - pms.chcDuration - .75;
    else
       Screen('FrameRect',wPtr,pms.selCol,respRect,4); % feedback verifying participant's response
    end
    
 % display the screen
    Screen('Flip',wPtr);
    WaitSecs(0.5);

 % printscreen with border
%    imageArray=Screen('GetImage',wPtr);
%    r=randi(100,1);
%    imwrite(imageArray,sprintf('newChosen%d.png',r),'png');
    
%% clear the screen
if pms.practice==0
  if pms.patternCB==1   %counterbalancing pattern
       if data.context(trial)==0
           Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2); %draw dots
       elseif data.context(trial)==1
           Screen('FillRect', wPtr, bwColors, rectCenter); %draw checkerboard
       end
  elseif pms.patternCB==2
       if data.context(trial)==0
           Screen('FillRect', wPtr, bwColors, rectCenter);
       elseif data.context(trial)==1
           Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [xCenter yCenter],2);
       end
  end
  % draw grey rectangles behind options
  Screen('FillRect',wPtr,pms.background,greyRectLeft);
  Screen('FillRect',wPtr,pms.background,greyRectRight);
end
%Screen('FillRect',wPtr,pms.background);
Screen('Flip',wPtr);

%% inter-trial interval

WaitSecs(buffer);
keyIsDown = 1;
   while keyIsDown;
        keyIsDown= KbCheck([pms.keyboards]);
        WaitSecs(.001);
   end

end % function