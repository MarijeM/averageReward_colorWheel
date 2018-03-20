function [hooray,median_rtMovement]=colorVision(pms,wPtr,rect)

%%%function that shows randomly selected colors and checks for color
%%%perception

%% Define Text
numTrials=pms.colorTrials;
rectOne=[0 0 100 100];
centerX=rect(3)/2;
centerY=rect(4)/2;
% wrptx=rect(3)/4;
passingScore=15;

insideRect=[rect(1) rect(2) 0.67*rect(4) 0.67*rect(4)]; %the white oval coordinates
outsideRect=[rect(1) rect(2) 0.9*rect(4) 0.9*rect(4)]; %the wheel coordinates
rectOne=CenterRectOnPoint(rectOne,centerX,centerY);
outsideRect=CenterRectOnPoint(outsideRect,centerX, centerY);
insideRect=CenterRectOnPoint(insideRect,centerX,centerY);

%define colors
colors=hsv(pms.numWheelColors)*255;
colorangle=360/length(colors);  
[~,pie]=sampledColorMatrix(pms);

%depending on number of trials, we first
  %sample from the middle, then the edges of
  %the Pie  
  index=randperm(numTrials);                     
for N=1:numTrials
    respX       = []; 
    respY       = []; 
    radius      = [];
    respDif     = [];
    rtDecision  = [];
    rtMovement  = [];
    rtTotal     = [];
    tau         = [];
    thetaCorrect= [];
    
    if index(N)<=12
      probePie=pie(index(N)).color;
      namePie=pie(index(N)).name;
      numberPie=pie(index(N)).number;
      probeColorCorrect=probePie(round(length(probePie)/2),:);
      colorPosition=1;
    elseif index(N)>12
      probePie=pie(index(N)-12).color;
      namePie=pie(index(N)-12).name;
      numberPie=pie(index(N)-12).number;
      probeColorCorrect=probePie(1,:);
      colorPosition=0;
    elseif index(N)>24
      probePie=pie(index(N)-24).color;
      namePie=pie(index(N)-24).name;
      probeColorCorrect=probePie(end,:);         
      numberPie=pie(index(N)-24).number;                          
      colorPosition=2;
    end


    load starts.mat;
    wheelStart=starts(N);
    startangle=wheelStart:colorangle:360+wheelStart;  
    
    %theta represents the angle for every color
    theta = zeros(length(colors),1);
    for indeX = 1:length(colors)   
       theta(indeX)=(360*indeX)/length(colors);
    end
    
    %colortheta is a structure with number of Colors fields linking "color" to "angle" of presentation
    colortheta  = struct; 
    for n=1:length(colors)
       colortheta(n).color = colors(n,:); %pick color n from all colors
       colortheta(n).theta = theta(n)+wheelStart;    %pick angle n from all angles and add initial shift (wheelStart)
    end
    
    %color wheel
    for ind=1:length(colors)
      Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
    end

    Screen('FillOval',wPtr,pms.background,insideRect);
    Screen('FillRect', wPtr, probeColorCorrect, rectOne'); 

    probeOnset = Screen('Flip',wPtr);
    
    %show and set the mouse in the center
    ShowCursor('Arrow');
    SetMouse(centerX,centerY,wPtr);
    
    movement = 0;
    response = 0;
    while movement == 0
        [x,y,~]     = GetMouse(wPtr); %constantly read mouse position
        radius      = sqrt((x-centerX)^2+(y-centerY)^2);  % calculate radius based on x and y coordinate of the mouse
        if radius > 25 %if they move far enough away from the center, time starts and we measure how long their motor response takes. They are instructed to only start moving the mouse once they have made a decision. 
            startResponse = GetSecs;
            movement = 1;
            while response == 0
                [x,y,~]     = GetMouse(wPtr); %constantly read mouse position
                radius      = sqrt((x-centerX)^2+(y-centerY)^2);                
                if radius > abs(insideRect(1)-insideRect(3))/2 %when the mouse reaches the color wheel
                    RT          = GetSecs; 
                    respX       = x;
                    respY       = y;

                    rtDecision  = startResponse - probeOnset;
                    rtMovement  = RT - startResponse;
                    rtTotal     = RT - probeOnset;
                    response    = 1
                    HideCursor;

                    lureColor=probePie(2,:); %don't need it here
                    [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect); %calculate deviance 
                    
                    % draw the color wheel + response + line for correct
                    % response + feedback
                    for ind=1:length(colors)
                        Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle); % draw color wheel
                    end
                    Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2); % draw line where they reached the wheel
                    Screen('FillOval',wPtr,pms.background,insideRect); % grey middle oval
                    Screen('FillRect', wPtr, probeColorCorrect, rectOne'); % draw square
                    Screen('Flip',wPtr);
                    WaitSecs(0.2);
                    for ind=1:length(colors)
                       Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
                    end
                    Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
                    Screen('FillArc',wPtr,[0 0 0],outsideRect,thetaCorrect-0.2,0.2); %draw line where the correct color is
                    Screen('FillOval',wPtr,pms.background,insideRect);
                    if abs(respDif) <=10
                       message2=sprintf('Good Job! you deviated only %d degrees.',abs(round(respDif)));
                       DrawFormattedText(wPtr, message2, 'center', 'center', [0 0 0]);
                    end
                    Screen('Flip',wPtr);   
                    WaitSecs(0.8);
                end 
            end       
        end 
    end 
        
    colorTestData(N).respCoord      = [respX respY];
    colorTestData(N).respDif        = abs(respDif);    
    colorTestData(N).rtDecision     = rtDecision;
    colorTestData(N).rtMovement     = rtMovement;
    colorTestData(N).rt             = rtTotal;
    colorTestData(N).probeColor     = probeColorCorrect;
    colorTestData(N).pie            = probePie;
    colorTestData(N).pieName        = namePie;
    colorTestData(N).pieNumber      = numberPie;
    colorTestData(N).colorPosition  = colorPosition;
    colorTestData(N).tau            = tau;
    colorTestData(N).thetaCorrect   = thetaCorrect;
             
end  %for N=1:numTrials

%% calculate their mean accuracy and median movement time on the color wheel test.
meanScore           = mean([colorTestData.respDif],'omitnan');
median_rtMovement   = median([colorTestData.rtMovement],'omitnan');


%% save data
filename=sprintf('ColorTest_s%d.mat',pms.subNo);
if exist (filename,'file')
    randAttach = round(rand*10000);
    filename = strcat(filename, sprintf('_%d.mat',randAttach));  
end
save(fullfile(pms.subdirICW,filename),'colorTestData', 'meanScore', 'median_rtMovement');


%% show the color wheel with a message telling them if they passed the color wheel test (or not)
for ind=1:length(colors)
    Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
end
Screen('FillOval',wPtr,pms.background,insideRect);

if meanScore>passingScore
  DrawFormattedText(wPtr, 'We are sorry, but you did not pass the color sensitivity test. Would you like to do it again?','center','center',[],wrptx);
  Screen('Flip',wPtr);
  WaitSecs(5);
  hooray = 0;
elseif meanScore<=passingScore
  DrawFormattedText(wPtr, 'Congratulations! You passed the color sensitivity test. You can continue with the rest of the experiment by pressing the right arrow.','center','center',[],pms.wrapAt);
  Screen('Flip',wPtr);
  KbWait();
  hooray = 1; %as long as hooray is not 1, they have to do the color wheel test again
end

end


