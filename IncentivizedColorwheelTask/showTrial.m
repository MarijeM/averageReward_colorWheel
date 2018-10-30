function [pms,data,T,money] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect)
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

data    = [];
T       = [];
money   = [];

% make sure there is a maximum time for moving the mouse
if ~isfield(pms,'median_rtMovement')
    pms.median_rtMovement = 0.8;
end 

%trials for practice session
if practice~=0
    numTrials   = pms.numTrialsPr;
    numBlocks   = pms.numBlocksPr;
elseif practice == 0
    numTrials   = pms.numTrials;
    numBlocks   = pms.numBlocks; 
end

Screen('TextSize',wPtr,pms.textSize);
Screen('TextStyle',wPtr,pms.textStyle);
Screen('TextFont',wPtr,pms.textFont);


EncSymbol       = 'M';
UpdSymbol       = 'U';
IgnSymbol       = 'I';



M_color         = [0 0 0];
U_color         = [0 0 0];
I_color         = [0 0 0];
%rect size
rectOne         = [0 0 100 100];
data            = struct();

%% create position matrix for dotted background pattern

% get the size of the on screen window in pixels
[screenXpixels,screenYpixels]=Screen('WindowSize', wPtr); 
% create base dot coordinates
dim = 10;
[x, y] = meshgrid(-dim:1:dim, -dim:1:dim);
% scale grid by screen size(into pixel coordinates) 
pixelScale = screenYpixels / (dim);
    x = x .* pixelScale;
    y = y .* pixelScale;
% calculate the number of dots
numDots = numel(x);
% create matrix of positions for dots 
dotPositionMatrix = [reshape(x, 1, numDots); reshape(y, 1, numDots)];


%% loop around trials and blocks for stimulus presentation

bonus       = 0; %start value of reward/bonus is 0.00
for p=1:numBlocks
    if (pms.blockCB==0 && p==1 | p==4) | (pms.blockCB==1 && p==2 | p==3)
        rewardContext = 0; %low
        pattern = 2; %dots
    elseif (pms.blockCB==0 && p==2 | p==3) | (pms.blockCB==1 && p==1 | p==4)
        rewardContext = 1; %high
        pattern = 0; %squares
    end
    
    if practice==0
        DrawFormattedText(wPtr, sprintf('Good luck with the memory task!\n\nPlease keep your hand on the mouse.'), 'center', 'center',[0 0 0]);
        Screen('Flip',wPtr);
        WaitSecs(2);
     % determine reward cue
        if rewardContext == 0
            blockOffer = '10';
        elseif rewardContext == 1
            blockOffer = '40';
        end
        Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern: Screen('DrawDots', windowPtr, xy [,size] [,color] [,center] [,dot_type])
        Screen('Textsize', wPtr, 34);
        Screen('Textfont', wPtr, 'Times New Roman');
        DrawFormattedText(wPtr, blockOffer, 'center', 'center');  %draw reward cue
        T.offer_on(p,1) = Screen('Flip',wPtr);
        WaitSecs(pms.offerDuration);      
        WaitSecs(randn(1)*0.1); %extra jittered waiting time during which reward is shown 
        Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
        T.offer_off(p,1) = Screen('Flip',wPtr);
        WaitSecs(pms.offerdelay); 
    end
    
    if practice==0
        Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
    end
    Screen('Flip',wPtr);
    WaitSecs(1.5);
    
    blockOnset  = GetSecs; %onset time of block. Block lasts x min. After x min, block ends automatically.
    for g=1:numTrials
        for phase = 1:7
            if phase==1 % reward on offer or fixationcross              
                %if practice==0 && trial(g,p).offer > 0      
                    %offer = sprintf('%d', trial(g,p).offer);
                    %Screen('Textsize', wPtr, 34);
                    %Screen('Textfont', wPtr, 'Times New Roman');
                    %DrawFormattedText(wPtr, offer, 'center', 'center');  
                    %T.offer_on(g,p) = Screen('Flip',wPtr);
                    %WaitSecs(pms.offerDuration);      
                    %WaitSecs(randn(1)*0.1); %extra jittered waiting time during which reward is shown 
                    %T.offer_off(g,p) = Screen('Flip',wPtr);
                    %WaitSecs(pms.offerdelay); 
                    %pms.points=1; % used later on in this function. If points is 1, then ppn gets feedback about how many points he wins.
                %else
                    if practice==0
                        Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                    end
                    drawFixationCross(wPtr,rect);
                    T.offer_on(g,p) = Screen('Flip',wPtr);
                    WaitSecs(pms.offerDuration);      
                    WaitSecs(randn(1)*0.1); %extra jittered waiting time during which reward is shown 
                    if practice==0
                        Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                    end
                    T.offer_off(g,p) = Screen('Flip',wPtr);
                    WaitSecs(pms.offerdelay); 
                    %pms.points=0;
                %end 
         
            elseif phase==2    % encoding phase
                if practice==0
                    Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                end
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                switch pms.shape
                    case 0 % squares
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
                                
                        Screen('FillRect',wPtr,colorEnc,allRects);
                        DrawFormattedText(wPtr, EncSymbol, 'center', 'center', M_color);
                        T.encoding_on(g,p) = Screen('Flip',wPtr); 
                    case 1 %circles
                                                switch trial(g,p).setSize  %switch between set sizes
                            case 1                 % setsize 1
                                circle(1,:)     = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                % make sure that you start drawing the
                                % largest circle, otherwise the smallest
                                % won't be visible anymore
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorEnc            = trial(g,p).colors(idx',:);
                            case 2                 % setsize 2
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorEnc            = (trial(g,p).colors(idx',:))';
                            case 3                 % setsize 3
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                circle(3,:)         = CenterRectOnPoint(trial(g,p).locations(3,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorEnc            = (trial(g,p).colors(idx',:))';
                            case 4                 % setsize 4
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                circle(3,:)         = CenterRectOnPoint(trial(g,p).locations(3,:),pms.xCenter,pms.yCenter);
                                circle(4,:)         = CenterRectOnPoint(trial(g,p).locations(4,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorEnc            = (trial(g,p).colors(idx',:))';
                        end
                                                             
                        Screen('FillOval',wPtr,colorEnc,allCircles);
                        Screen('FrameOval',wPtr,M_color,allCircles);
                        DrawFormattedText(wPtr, EncSymbol, 'center', pms.yCenter-35, M_color);
                        T.encoding_on(g,p) = Screen('Flip',wPtr); 
                end

%                         imageArray=Screen('GetImage',wPtr);                     
%                         imwrite(imageArray,sprintf('encoding2%d%d.png',g,p),'png');  

                        WaitSecs(pms.encDuration);
                        T.encoding_off(g,p) = GetSecs;
            
            elseif phase==3      %delay 1 phase
                if practice==0
                    Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                end
                drawFixationCross(wPtr,rect);
                T.delay1_on(g,p) = Screen('Flip',wPtr);
                
                if practice==1 
                    WaitSecs(pms.delay1DurationPr);
                else
                    switch nargin   %number of arguments
                        case 6      % 6 arguments in showTrial function: 
                            WaitSecs(pms.delay1Duration);
                        case 7      % 7 arguments in showTrial function:
                            if varargin{1}==1   %and variable argument is 1 (manipulation)
                                WaitSecs(trial(g,p).delay1)     %use predefined delays in trial.mat
                            end
                    end
                end
                T.delay1_off(g,p) = GetSecs;
                
            elseif phase==4 %interference phase
                if practice==0
                    Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                end
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                    switch pms.shape
                        case 0 %squares
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
                                                        
                            if trial(g,p).type==0 %ignore
                                DrawFormattedText(wPtr, IgnSymbol, 'center', 'center', I_color);
                            elseif trial(g,p).type==2 %update
                                DrawFormattedText(wPtr, UpdSymbol, 'center', 'center', U_color);
                            end 
                            T.interference_on(g,p) = Screen('Flip',wPtr); 
                            WaitSecs(pms.interfDuration); 
                            T.interference_off(g,p) = GetSecs;
                        
                        case 1 %concentric circles
                        
                         switch trial(g,p).setSize  %switch between set sizes
                            case 1                 % setsize 1
                                circle(1,:)     = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                % make sure that you start drawing the
                                % largest circle, otherwise the smallest
                                % won't be visible anymore
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorInt            = trial(g,p).colors((idx+1)',:);
                            case 2                 % setsize 2
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorInt            = (trial(g,p).colors((idx+2)',:))';
                            case 3                 % setsize 3
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                circle(3,:)         = CenterRectOnPoint(trial(g,p).locations(3,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorInt            = (trial(g,p).colors((idx+3)',:))';
                            case 4                 % setsize 4
                                circle(1,:)         = CenterRectOnPoint(trial(g,p).locations(1,:),pms.xCenter,pms.yCenter);
                                circle(2,:)         = CenterRectOnPoint(trial(g,p).locations(2,:),pms.xCenter,pms.yCenter);
                                circle(3,:)         = CenterRectOnPoint(trial(g,p).locations(3,:),pms.xCenter,pms.yCenter);
                                circle(4,:)         = CenterRectOnPoint(trial(g,p).locations(4,:),pms.xCenter,pms.yCenter);
                                [~,idx]             = sort(trial(g,p).locations(:,3), 'descend');
                                allCircles          = circle(idx',:)';
                                colorInt            = (trial(g,p).colors((idx+4)',:))';
                         end

                        Screen('FillOval',wPtr,colorInt,allCircles);
                        Screen('FrameOval',wPtr,M_color,allCircles);

                        if trial(g,p).type==0 %ignore
                            DrawFormattedText(wPtr, IgnSymbol, 'center', pms.yCenter-35, I_color);
                        elseif trial(g,p).type==2 %update
                            DrawFormattedText(wPtr, UpdSymbol, 'center', pms.yCenter-35, U_color);
                        end 
                        T.interference_on(g,p) = Screen('Flip',wPtr); 
                        WaitSecs(pms.interfDuration);
                        T.interference_off(g,p) = GetSecs;
                              
                    end % switch shape

            elseif phase==5 %phase delay 2
                if practice==0
                    Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
                end
                drawFixationCross(wPtr,rect);
                T.delay2_on(g,p) = Screen('Flip',wPtr);
                
                if practice~=0         
                    switch trial(g,p).type
                        case 0
                            WaitSecs(pms.delay2DurationIgnPr);
                        case 2
                            WaitSecs(pms.delay2DurationUpdPr);
                    end
                    
                elseif practice==0
                    switch nargin
                        case 6
                            switch trial(g,p).type
                                case 0
                                    WaitSecs(pms.delay2DurationIgn);
                                case 2
                                    WaitSecs(pms.delay2DurationUpd);
                            end
                        case 7
                            if varargin{1}==1
                                WaitSecs(trial(g,p).delay2);
                            end
                    end
                end
                
                T.delay2_off(g,p) = GetSecs;
   
            elseif phase==6  %probe phase
                if pms.shape==0
                    probeRectX=trial(g,p).locations(1,1);
                    probeRectY=trial(g,p).locations(1,2); 
                elseif pms.shape==1
                    probeCircle=trial(g,p).locations(1,:);
                end
                switch trial(g,p).type
                    case {0}   %for Ignore
                        %correct is the color during encoding 
                        trial(g,p).probeColorCorrect=trial(g,p).colors(1,:);
                        %lure is the color in the same location during Interference
                        trial(g,p).lureColor=trial(g,p).colors(1+trial(g,p).setSize,:);                          
                    case {2}      
                        %reverse for Update
                        trial(g,p).probeColorCorrect=trial(g,p).colors(1+trial(g,p).setSize,:);
                        trial(g,p).lureColor=trial(g,p).colors(1,:);
                end

                
                T.probe_on(g,p) = GetSecs;
                 if pms.shape==0   
                    [respX,respY,rtDecision, rtMovement, rtTotal, colortheta,correct]=probecolorwheel(pms,allRects,probeRectX,probeRectY,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p, trial, pattern);
                 elseif pms.shape==1
                    [respX,respY,rtDecision, rtMovement, rtTotal, colortheta,correct]=probecolorwheel_circles(pms,allCircles,probeCircle,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p, trial); 
                 end
                T.probe_off(g,p) = GetSecs;
                [respDif,tau,thetaCorrect,radius,lureDif]=respDev(colortheta,trial(g,p).probeColorCorrect,trial(g,p).lureColor,respX,respY,rect);
               
            elseif phase==7 % feedback about their reward or won reward after trial
               if practice==0
                   Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % draw background pattern
               end
               Screen('Flip',wPtr);  
               if practice~=1 %&& pms.points==1 
                   Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % Drawing dotted background pattern
                   Screen('Textsize', wPtr, 28);
                   Screen('Textfont', wPtr, 'Times New Roman');                  
                   %if correct==1 % if they were accurate enough
                       DrawFormattedText(wPtr,sprintf('You win %s points',blockOffer),'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                       Screen('Flip',wPtr);  
                       T.feedback_on(g,p) = GetSecs;
                       WaitSecs(pms.rewardduration);
                   %else 
                       %DrawFormattedText(wPtr,'You win 0 points', 'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                       %Screen('Flip',wPtr);  
                       %T.feedback_on(g,p) = GetSecs;
                       %WaitSecs(pms.rewardduration);
                   %end
                   Screen('Drawdots', wPtr, dotPositionMatrix, 20, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],pattern); % Drawing dotted background pattern
                   Screen('Flip',wPtr); 
                   T.feedback_off(g,p) = GetSecs;
               %elseif practice~=1 && pms.points==0
                   %drawFixationCross(wPtr,rect);
                   %Screen('Flip',wPtr); 
                   %T.feedback_on(g,p) = GetSecs;
                   %WaitSecs(pms.rewardduration);
                   %T.feedback_off(g,p) = GetSecs;
               end 
                              
       
                %save responses and data into a struct.
                data(g,p).respCoord=[respX respY]; %saving response coordinates in struct where 1,1 is x and 1,2 y
                data(g,p).correct=correct;
                data(g,p).rtDecision=rtDecision;
                data(g,p).rtMovement=rtMovement;
                data(g,p).rt=rtTotal;
                if pms.shape==0
                    data(g,p).probeLocation=[trial(g,p).locations(1,1) trial(g,p).locations(1,2)];
                elseif pms.shape==1
                    data(g,p).probeLocation=trial(g,p).locations(1,:);
                end
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
                save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                if practice==0
                    data(g,p).offer=trial(g,p).offer;
                    %if correct==1 && pms.points==1 %if they did better than a maximum deviance
                        data(g,p).reward=trial(g,p).offer;
                    %else                                      
                        %data(g,p).reward=0;
                    %end   
                    bonus = bonus + data(g,p).reward;
                    data(g,p).bonus = bonus;
                    money = bonus / pms.bonusCalculation;
                    if pms.shape==0                       
                        data(g,p).encColLoc1=trial(g,p).encColLoc1;
                        data(g,p).encColLoc2=trial(g,p).encColLoc2;
                        data(g,p).encColLoc3=trial(g,p).encColLoc3;
                        data(g,p).encColLoc4=trial(g,p).encColLoc4;
                        data(g,p).interColLoc1=trial(g,p).interColLoc1;
                        data(g,p).interColLoc2=trial(g,p).interColLoc2;
                        data(g,p).interColLoc3=trial(g,p).interColLoc3;
                        data(g,p).interColLoc4=trial(g,p).interColLoc4;
                    elseif pms.shape==1
                        data(g,p).encColLoc1=trial(g,p).encColLoc1;
                        data(g,p).interColLoc1=trial(g,p).interColLoc1;
                        if trial(g,p).setSize>1
                            data(g,p).encColLoc2=trial(g,p).encColLoc2;
                            data(g,p).interColLoc2=trial(g,p).interColLoc2;
                            if trial(g,p).setSize>2
                                data(g,p).encColLoc3=trial(g,p).encColLoc3;
                                data(g,p).interColLoc3=trial(g,p).interColLoc3;
                                if trial(g,p).setSize>3
                                    data(g,p).encColLoc4=trial(g,p).encColLoc4;
                                    data(g,p).interColLoc4=trial(g,p).interColLoc4;
                                end
                            end
                        end 
                    end
                    save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                elseif practice~=0
                    save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                end                               
            end %if phase == 1
        end % for phase 1:7
        
        % break after each block 
        if practice==0           
            if g==pms.numTrials % last trial of block
                if p==numBlocks
                    DrawFormattedText(wPtr,sprintf('End of the experiment. Please press space.'),'center','center',[0 0 0]);
                else 
                    getInstructions(4,pms,rect,wPtr);
                end
                Screen('Flip',wPtr);
                RestrictKeysForKbCheck([])
                WaitSecs(1);
                break; %end numTrials loop and go to next block
            end 
        end          
    end  % for g=1:numTrials 
end % for p=1:numBlocks

end 

