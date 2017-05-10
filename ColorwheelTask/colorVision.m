function [colorTestData]=colorVision(pms,wPtr,rect)

%%%function that shows randomly selected colors and checks for color
%%%perception

% Screen('Preference', 'VisualDebugLevel',0);
% Screen('Preference','SkipSyncTests',1); 
% Screen('Preference', 'SuppressAllWarnings', 1);

% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));


% Screen('TextSize',wPtr,24);
% Screen('TextStyle',wPtr,1);
% Screen('TextFont',wPtr,'Times New Roman');

numTrials=pms.colorTrials;
rectOne=[0 0 100 100];
centerX=rect(3)/2;
centerY=rect(4)/2;
ShowCursor('Arrow'); %we can change the shape of the mouse and then type ShowCursor(newcursor) %MF: wow, that's cool!!
SetMouse(rect(3)/2,rect(4)/2,wPtr);
testOnset=GetSecs();
wrptx=rect(3)/4;
message='Welcome to our memory task!\n\n\n Before we start we need to check your color sensitivity. \n\n You will see a colored square in the middle of the screen.\n\n You should find the corresponding color on the colorwheel and click it!\n\n Try to be as fast and accurate as possible!\n\n\n  Press space to start.';
passingScore=15;

DrawFormattedText(wPtr, message,'center','center',[],wrptx)
Screen('Flip',wPtr)
KbWait()

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


                      load starts.mat
                      wheelStart=starts(N);
                      startangle=wheelStart:colorangle:360+wheelStart;  
                      
                      for ind=1:length(colors)
                          Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
                      end

                      Screen('FillOval',wPtr,pms.background,insideRect);
                      Screen('FillRect', wPtr, probeColorCorrect, rectOne'); 

                      Screen('Flip',wPtr)
%                           r=randi(100);
%                             imageArray=Screen('GetImage',wPtr);
%                             imwrite(imageArray,sprintf('ColTest%d.png',r),'png');
                     probeOnset=GetSecs();

                         [~, secs] = KbCheck;
                         %waits for a click and records
                         [clicks,x,y]=GetClicks(wPtr);
                         if any(clicks)
                            respX=x;
                            respY=y;
                            rt=secs-probeOnset;
                         end


                         WaitSecs(0.001);

% clear Screen

%theta represents the angle for every color
 theta=zeros(length(colors),1);
       for ind=1:length(colors)   
           theta(ind)=(360*ind)/length(colors);
       end

       % colortheta is a structure with number of Colors fields linking "color" to "angle" of presentation
 
colortheta=struct; 

for n=1:length(colors)
   colortheta(n).color=colors(n,:); %pick color n from all colors
   colortheta(n).theta=theta(n)+wheelStart;    %pick angle n from all angles and add initial shift (wheelStart)
end
       
                lureColor=probePie(2,:); %don't need it here
               [respDif,tau,thetaCorrect,radius]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect);
               
    for ind=1:length(colors)
        Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
    end

      if ~isnan('tau')
             if radius>abs(insideRect(1)-insideRect(3))/2
      Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
%           Screen('FillArc',wPtr,[0 0 0],outsideRect,thetaCorrect-0.2,0.2);
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
         else
      %otherwise no feedback
      end
         Screen('Flip',wPtr)
%                                 r=randi(1000);
%                             imageArray=Screen('GetImage',wPtr);
%                             imwrite(imageArray,sprintf('ColTest%dFeedback.png',r),'png');   
         WaitSecs(0.8);
             end
      end

%             Screen('TextSize',wPtr,20);
%             DrawFormattedText(wPtr, 'How would you name the color you just saw?\n\n red,orange,yellow,light green, green, blue green, turquoise, cyan, blue, purple, pink or magenda?','center', centerY-100, [0 0 0])
%             reply=Ask(wPtr,'Please type your response and press enter',[],[],'GetString','center','center',15);
%             DrawFormattedText(wPtr, reply, 'center', centerY+100, [0 0 0])
%             Screen('Flip',wPtr)
%             WaitSecs(2)

         colorTestData(N).respDif=abs(respDif);  
         colorTestData(N).respDifDirection=respDif;           
         colorTestData(N).rt=rt;
         colorTestData(N).probeColor=probeColorCorrect;
%              colorTestData(N).colorName=reply;
         colorTestData(N).pie=probePie;
         colorTestData(N).pieName=namePie;
         colorTestData(N).pieNumber=numberPie;
         colorTestData(N).colorPosition=colorPosition;

                      end  %for N=1:numTrials
                      %for index=randperm(numTrials)
                      filename=sprintf('ColorTest_s%d_ses%d.mat',pms.subNo,pms.session);

                      if exist (filename,'file')
                            randAttach = round(rand*10000);
                            filename = strcat(filename, sprintf('_%d.mat',randAttach));  
                      end
                       save(fullfile(pms.colordir,filename),'colorTestData')

meanScore=mean([colorTestData.respDif]);

for ind=1:length(colors)
    Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
end
    Screen('FillOval',wPtr,pms.background,insideRect);

if meanScore>passingScore
  DrawFormattedText(wPtr, 'We are sorry, but you did not pass the color acuity test. Would you like to do it again?','center','center',[],wrptx)
  Screen('Flip',wPtr)
  WaitSecs(5)
  clear Screen
elseif meanScore<=passingScore
  DrawFormattedText(wPtr, 'Congratulations! You passed the color acuity test. \n You can continue with the rest of the experiment.','center','center',[],wrptx)
  Screen('Flip',wPtr)
  KbWait()
end

% clear Screen
end


