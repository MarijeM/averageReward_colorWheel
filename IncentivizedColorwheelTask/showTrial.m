function [data,T,bonus] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect,varargin)
%this function shows the stimuli and collects the responses for the  INCENTIVIZED colorwheel
%memory task.
% data:     struct with fields:respCoord (where the ppt clicked), rt, probeLocation (square that was probed)
%           probeColorCorrect, respDif (deviance between click and correct color), thetaCorrect (correct angle),
%           tau (response angle),setsize,type(Ignore or Update),locations (square locations),colors
% T:        struct with timepoints for all phases of the task
%
% trial:    struct that provides details for all stimuli, output of [trial]=defstruct(pms,rect)
% pms:      task parameteres defined in main script BeautifulColorwheel.m
% practice: status of task, output of [subNo,dataFilename,dataFilenamePrelim,practice,manipulation]=getInfo
% dataFilenamePrelim: name for log file between blogs provided by getInfo.m


cd IncentivizedColorwheelTask; %back to incentivized colorwheel directory

%trials for practice session
if practice==1
    pms.numTrials   = pms.numTrialsPr;
    pms.numBlocks   = pms.numBlocksPr;
end

Screen('TextSize',wPtr,16);
Screen('TextStyle',wPtr,1);
Screen('TextFont',wPtr,'Courier New');

EncSymbol       = 'M';
UpdSymbol       = 'U';
IgnSymbol       = 'I';
% rewardLow       = 0.01;
% rewardHigh      = 0.10;
RewardText      = double(sprintf('for %f ct', reward));

M_color         = [0 0 0];
U_color         = [0 0 0];
I_color         = [0 0 0];
Reward_color    = [0 0 0];
%rect size
rectOne         = [0 0 100 100];
rectTwo         = [0 0 25 25];
data            = struct();
ovalRect        = CenterRectOnPoint(rectTwo,pms.xCenter,pms.yCenter);

%% loop around trials and blocks for stimulus presentation
if practice == 0               % dit toegevoegd omdat numBlocks 1 is voordat je trial verdubbelt. na het verdubbelen van 64X1 naar 128X1, en reshapen naar 64X2; numblocks=2.
    pms.numBlocks = 2;
end

bonus = 0; %start value of reward/bonus is €0.00
for p=1:pms.numBlocks
    for g=1:pms.numTrials
        for phase = 1:7 
           if phase==1
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                DrawFormattedText(wPtr, RewardText, 'center', 'center', Reward_color);  
                Screen('Flip',wPtr);
                %imageArray=Screen('GetImage',wPtr);
                %imwrite(imageArray,sprintf('RewardcueL%d%d.png',g,p),'png');
                WaitSecs(pms.rewardduration)      
                Screen('Flip',wPtr);
                WaitSecs(pms.rewarddelay);         
        
            elseif phase==2    % encoding phase
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                switch trial(g,p).type
                    case {0 2}
                        switch trial(g,p).setSize  %switch between set sizes
                            case 1                 % setsize 1
                                rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                colorEnc    = trial(g,p).colors(1,:);
                                allRects    = rectOne;
                            case 2                 % setsize 2
                                rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                allRects    = [rectOne',rectTwo'];
                                colorEnc    = (trial(g,p).colors((1:2),:))';
                            case 3                 % setsize 3
                                rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                allRects    = [rectOne',rectTwo',rectThree'];
                                colorEnc    = (trial(g,p).colors((1:3),:))';
                            case 4                 % setsize 4
                                rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                rectFour    = CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                allRects    = [rectOne',rectTwo',rectThree',rectFour'];
                                colorEnc    = (trial(g,p).colors((1:4),:))';
                        end
                        trial(g,p).colorEnc = colorEnc;
                                
                        Screen('FillRect',wPtr,colorEnc,allRects);
                        DrawFormattedText(wPtr, EncSymbol, 'center', 'center', M_color);
                        T.encoding_on(g,p) = GetSecs;
                        Screen('Flip',wPtr);           
                        switch trial(g,p).type
                            case 0
                                WaitSecs(pms.encDurationIgn);
                            case 2
                                WaitSecs(pms.encDurationUpd);
                        end    
                        T.encoding_off(g,p) = GetSecs;                        
                end
                
            elseif phase==3      %delay 1 phase
                
                drawFixationCross(wPtr,rect)
                Screen('Flip',wPtr);
                T.delay1_on(g,p) = GetSecs;
                
                if practice==1 
                    WaitSecs(pms.delay1DurationPr)
                else
                    switch nargin   %number of arguments
                        case 6      % 6 arguments in showTrial function: 
                            switch trial(g,p).type
                                case 0
                                    WaitSecs(pms.delay1DurationIgn);
                                case 2
                                    WaitSecs(pms.delay1DurationUpd);
                            end
                        case 7      % 7 arguments in showTrial function:
                            if varargin{1}==1   %and variable argument is 1 (manipulation)
                                WaitSecs(trial(g,p).delay1)     %use predefined delays in trial.mat
                            end
                    end
                end
                T.delay1_off(g,p) = GetSecs;
                
            elseif phase==4 %interference phase
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');              
                    switch trial(g,p).type
                        case 0 %interference Ignore
                            switch trial(g,p).setSize
                                case 1
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    colorInt    = trial(g,p).colors(2,:);
                                    allRects    = rectOne;
                                case 2
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    allRects    = [rectOne',rectTwo'];
                                    colorInt    = (trial(g,p).colors((3:4),:))';
                                case 3
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                    allRects    = [rectOne',rectTwo',rectThree'];
                                    colorInt    = (trial(g,p).colors((4:6),:))';      
                                case 4
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                    rectFour    = CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                    allRects    = [rectOne',rectTwo',rectThree',rectFour'];
                                    colorInt    = (trial(g,p).colors((5:8),:))';
                            end
                        
                            Screen('FillRect',wPtr,colorInt,allRects);
                            DrawFormattedText(wPtr, IgnSymbol, 'center', 'center', I_color);
                            T.I_ignore_on(g,p) = GetSecs;
                            Screen('Flip',wPtr);
                            WaitSecs(pms.interfDurationIgn);
                            T.I_ignore_off(g,p) = GetSecs;
                        
                        case 2 %Inteference Update
                        
                            switch trial(g,p).setSize
                                case 1
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    colorInt    = trial(g,p).colors(2,:);
                                    allRects    = rectOne;
                                case 2
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    allRects    = [rectOne',rectTwo'];
                                    colorInt    = (trial(g,p).colors((3:4),:))';
                                case 3
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                    allRects    = [rectOne',rectTwo',rectThree'];
                                    colorInt    = (trial(g,p).colors((4:6),:))'; 
                                case 4
                                    rectOne     = CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                    rectTwo     = CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                    rectThree   = CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                    rectFour    = CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                    allRects    = [rectOne',rectTwo',rectThree',rectFour'];
                                    colorInt    = (trial(g,p).colors((5:8),:))';
                            end
                            trial(g,p).colorInt = colorInt;
                                                                
                            Screen('FillRect',wPtr,colorInt,allRects);
                            DrawFormattedText(wPtr, UpdSymbol, 'center', 'center', U_color);
                            T.I_update_on(g,p) = GetSecs;
                            Screen('Flip',wPtr);
                            WaitSecs(pms.interfDurationUpd);
                            T.I_update_off(g,p) = GetSecs;       
                    end % trial.type
                
            elseif phase==5 %phase delay 2
                
                T.delay2_on(g,p) = GetSecs;
                drawFixationCross(wPtr,rect)
                Screen('Flip',wPtr);
                
                if practice==1         
                    switch trial(g,p).type
                        case 0
                            WaitSecs(pms.delay2DurationIgnPr)
                        case 2
                            WaitSecs(pms.delay2DurationUpdPr)
                    end
                    
                elseif practice==0
                    switch nargin
                        case 6
                            switch trial(g,p).type
                                case 0
                                    WaitSecs(pms.delay2DurationIgn)
                                case 2
                                    WaitSecs(pms.delay2DurationUpd)
                            end
                        case 7
                            if varargin{1}==1
                                WaitSecs(trial(g,p).delay2)
                            end
                    end
                end
                
                T.delay2_off(g,p) = GetSecs;
                
                
            elseif phase==6  %probe phase
                
                if practice==1 
                    locationsrect=trial(g,p).locations;
                    %for practice we randomly select a square for probe. Index2 
                    %selects randomly 1 of the encoding phase squares.
                    index2=randi(trial(g,p).setSize,1);
                    %index for same square during interference phase
                    index3=index2+trial(g,p).setSize;
                    probeRectXY=locationsrect(index2,:);
                    probeRectX=probeRectXY(1,1);
                    probeRectY=probeRectXY(1,2);
   
                    switch trial(g,p).type
                        case {0}   %for Ignore
                            %correct is the color during encoding 
                            trial(g,p).probeColorCorrect=trial(g,p).colors(index2,:);
                            %lure is the color in the same location during Interference
                            trial(g,p).lureColor=trial(g,p).colors(index3,:);                          
                        case {2}      
                            %reverse for Update
                            trial(g,p).probeColorCorrect=trial(g,p).colors(index3,:);
                            trial(g,p).lureColor=trial(g,p).colors(index2,:);
                    end
                    
                elseif practice==0
                    %for the defined stimuli probe is always the first
                    %location/square
                    probeRectX=trial(g,p).locations(1,1);
                    probeRectY=trial(g,p).locations(1,2);                 
                end %if practice==1
                
                if practice==1 
                    [respX,respY,rt,colortheta,respXAll,respYAll,rtAll]=probecolorwheelNew(pms,allRects,probeRectX,probeRectY,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p);
                elseif practice==0
                    [respX,respY,rt,colortheta,respXAll,respYAll,rtAll]=probecolorwheelNew(pms,allRects,probeRectX,probeRectY,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p,trial);
                end
                
                [respDif,tau,thetaCorrect,radius,lureDif]=respDev(colortheta,trial(g,p).probeColorCorrect,trial(g,p).lureColor,respX,respY,rect);
                save(fullfile(pms.subdirICW,dataFilenamePrelim));
                
                %Break after every block
                if practice==0
                    if g==pms.numTrials && p<pms.numBlocks
                        DrawFormattedText(wPtr,sprintf('End of block %d, press space to continue.',p ),'center','center',[0 0 0]);
                        Screen('Flip',wPtr)
                        save(fullfile(pms.subdirICW,dataFilenamePrelim));
                        RestrictKeysForKbCheck(32)
                        KbWait();
                        RestrictKeysForKbCheck([])
                    end
                end
                %save responses and data into a struct.
                data(g,p).respCoord=[respX respY]; %saving response coordinates in struct where 1,1 is x and 1,2 y
                data(g,p).rt=rt;
                data(g,p).respCoordAll=[respXAll respYAll];
                data(g,p).rtAll=rtAll;
                data(g,p).probeLocation=[probeRectX probeRectY];
                data(g,p).probeColorCorrect=trial(g,p).probeColorCorrect;
                data(g,p).lureColor=trial(g,p).lureColor;
                data(g,p).respDif=respDif;
                data(g,p).lureDif=lureDif;
                data(g,p).radius=radius;
                data(g,p).thetaCorrect=thetaCorrect;
                data(g,p).tau=tau;
                data(g,p).rect=rect;
                data(g,p).setsize = trial(g,p).setSize;
                data(g,p).type=trial(g,p).type;
                data(g,p).location =trial(g,p).locations;
                data(g,p).colors = trial(g,p).colors;
                data(g,p).reward=trial(g,p).reward;        
                switch trial(g,p).type %if they performed better or equal to their average performance of session 1, they receive a bonus, else, they do not. 
                    case 0                                         %for update trials
                        if respDif <= medDev(1,trial(g,p).setSize) %if they did better than their average
                            data(g,p).bonus=trial(g,p).reward;
                            bonus = bonus + trial(g,p).reward;
                        else                                       %if they did not better than their average
                            data(g,p).bonus=0;
                        end 
                    case 2
                        if respDif <= medDev(2,trial(g,p).setSize) 
                            data(g,p).bonus=trial(g,p).reward;
                            bonus = bonus + trial(g,p).reward;
                        else 
                            data(g,p).bonus=0;
                        end 
                end 
                if practice==0
                    data(g,p).encColLoc1=trial(g,p).encColLoc1;
                    data(g,p).encColLoc2=trial(g,p).encColLoc2;
                    data(g,p).encColLoc3=trial(g,p).encColLoc3;
                    data(g,p).encColLoc4=trial(g,p).encColLoc4;
                    data(g,p).interColLoc1=trial(g,p).interColLoc1;
                    data(g,p).interColLoc2=trial(g,p).interColLoc2;
                    data(g,p).interColLoc3=trial(g,p).interColLoc3;
                    data(g,p).interColLoc4=trial(g,p).interColLoc4;
                end
            elseif phase==7 % feedback about their reward
               Screen('Textsize', wPtr, 28);
               Screen('Textfont', wPtr, 'Times New Roman');
               if respDif <= pms.minAcc % if they were accurate enough
                   DrawFormattedText(wPtr,double(sprintf('You win %f ct',reward)),'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                   Screen('Flip',wPtr);  
                   WaitSecs(pms.bonusduration);
               else 
                   DrawFormattedText(wPtr,'You win nothing', 'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                   Screen('Flip',wPtr);  
                   WaitSecs(pms.bonusduration);
               end 
            end %if phase ==1
        end % for phase 1:6
    end% for p=1:numBlocks
end  % for g=1:numTrials
end

