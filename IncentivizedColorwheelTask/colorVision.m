function [hooray]=colorVision(pms,wPtr,rect)

%%%function that shows randomly selected colors and checks for color
%%%perception

%% Define Text
numTrials=pms.colorTrials;
rectOne=[0 0 100 100];
centerX=rect(3)/2;
centerY=rect(4)/2;
testOnset=GetSecs();
wrptx=rect(3)/4;
message='Welcome to our memory task!\n\n\n Before we start we need to check your color sensitivity. \n\n You will see a colored square in the middle of the screen.\n\n Find the corresponding color on the color wheel and click it!\n\n\n\n Clicking on the color wheel works like this:\n\nFirst you determine the correct color.\n\nOnce you know where you want to click, you click on the mouse and you hold it.\n\nThen you move the arrow to the color wheel as fast as possible and release it once you reach the right color.\n\n\n\n Try to be as accurate as possible, but no need to take a lot of time to respond!\n\n\n\n\nPress space to start.';
passingScore=15;

DrawFormattedText(wPtr, message,'center','center',[],wrptx);
Screen('Flip',wPtr);
KbWait();

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
    wheelclick  = 0;
    rtDecision  = [];
    rtResponse  = [];
    tau         = [];
    radius      = [];
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
    
    response = 0;
    while response==0
        [~,~,buttons]   = GetMouse(wPtr);
        mousePress      = any(buttons);%response was made
        if mousePress==1;
            tDecision           = GetSecs; 
            %show mouse and place it in the center of the screen
            ShowCursor('Arrow');
            SetMouse(centerX,centerY,wPtr);
            response = 1;
            while mousePress==1 && GetSecs-tDecision<pms.maxMotorTime;
                [x,y,buttons]   = GetMouse(wPtr);
                toolate = 1; %as long as we don't go into the if statement, they have not yet released the mouse
                if buttons(1)==0 %mouse was released
                    toolate = 0; 
                    rtDecision  = tDecision-probeOnset;
                    respX       = x;
                    respY       = y;
                    rtResponse  = GetSecs-probeOnset;
                    HideCursor;
                    %theta represents the angle for every color
                    theta=zeros(length(colors),1);
                    for ind=1:length(colors)   
                        theta(ind)=(360*ind)/length(colors);
                    end

                    lureColor=probePie(2,:); %don't need it here
                    [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect);
                    
                    %determine if participant clicked on the wheel, and not
                    %inside or outside of the wheel
                    if radius>abs(insideRect(1)-insideRect(3))/2 && radius<abs(outsideRect(1)-outsideRect(3))/2
                        wheelclick = 1;
                    else
                        wheelclick = 0;
                    end
                    
                    for ind=1:length(colors)
                        Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
                    end
                        
                    %Response indication: if they didn't click on the fixation cross (radius~=0) or within the inner circle, a line appears indicating
                    %their choice
                    if ~isnan('tau')
                        if radius>abs(insideRect(1)-insideRect(3))/2
                           Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
                           Screen('FillOval',wPtr,pms.background,insideRect);
                           Screen('FillRect', wPtr, probeColorCorrect, rectOne'); 
                           Screen('Flip',wPtr);
                           WaitSecs(0.5);
                           for ind=1:length(colors)
                              Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
                           end
                           Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
                           Screen('FillArc',wPtr,[0 0 0],outsideRect,thetaCorrect-0.2,0.2);
                           Screen('FillOval',wPtr,pms.background,insideRect);
                           if abs(respDif) <=10
                              message2=sprintf('Good Job! you deviated only %d degrees.',abs(round(respDif)));
                              DrawFormattedText(wPtr, message2, 'center', 'center', [0 0 0]);
                           end
                          Screen('Flip',wPtr);   
                          WaitSecs(0.8);
                        end
                    end % if isnan 
                    break; 
                end % if buttons == 0
            end %while mousePress==1 
        end %if mousepress==1
    end %while response==0

    
    if toolate==1;
        HideCursor;
        for ind=1:length(colors)
          Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
        end       
        Screen('FillOval',wPtr,pms.background,insideRect);
        Screen('TextSize',wPtr,15);
        DrawFormattedText(wPtr, sprintf('Please move the cursor faster towards the color wheel!\n\nNow click to start the new trial.'),...
            'center', 'center',[],pms.wrapAt,[],[],pms.spacing);      
        Screen('Flip',wPtr);
        GetClicks(); 
    elseif wheelclick == 0 
        HideCursor;
        for ind=1:length(colors)
          Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
        end       
        Screen('FillOval',wPtr,pms.background,insideRect);
        Screen('TextSize',wPtr,15);
        DrawFormattedText(wPtr, sprintf('Determine your answer.\nThen press the mouse button to start moving the arrow \nas fast as possible towards the correct color.\nRelease the mouse once you reach the color wheel.\n\nNow click the mouse to start the new trial.'),...
            'center', 'center',[],pms.wrapAt,[],[],pms.spacing);      
        Screen('Flip',wPtr);
        GetClicks(); 
    end
    
    
    WaitSecs(0.001);

    colorTestData(N).respCoord=[respX respY];
    colorTestData(N).respDif=abs(respDif); 
    colorTestData(N).wheelclick=wheelclick;      
    colorTestData(N).rtDecision=rtDecision;
    colorTestData(N).rtResponse=rtResponse;
    colorTestData(N).probeColor=probeColorCorrect;
    colorTestData(N).pie=probePie;
    colorTestData(N).pieName=namePie;
    colorTestData(N).pieNumber=numberPie;
    colorTestData(N).colorPosition=colorPosition;
    colorTestData(N).tau=tau;
    colorTestData(N).thetaCorrect=thetaCorrect;
    colorTestData(N).radius=radius;
             
end  %for N=1:numTrials

filename=sprintf('ColorTest_s%d.mat',pms.subNo);

if exist (filename,'file')
    randAttach = round(rand*10000);
    filename = strcat(filename, sprintf('_%d.mat',randAttach));  
end
save(fullfile(pms.subdirICW,filename),'colorTestData');

meanScore=mean([colorTestData.respDif],'omitnan');

for ind=1:length(colors)
    Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
end
Screen('FillOval',wPtr,pms.background,insideRect);

if meanScore>passingScore
  DrawFormattedText(wPtr, 'We are sorry, but you did not pass the color acuity test. Would you like to do it again?','center','center',[],wrptx);
  Screen('Flip',wPtr);
  WaitSecs(5);
  hooray = 0;
elseif meanScore<=passingScore
  DrawFormattedText(wPtr, 'Congratulations! You passed the color acuity test. \n You can continue with the rest of the experiment.','center','center',[],wrptx);
  Screen('Flip',wPtr);
  KbWait();
  hooray = 1;
end

% clear Screen
end


