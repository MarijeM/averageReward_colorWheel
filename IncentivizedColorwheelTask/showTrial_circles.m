function [pms,data,T,money,gazedata] = showTrial(trial,pms,practice,dataFilenamePrelim,wPtr,rect)
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
gazedata= [];

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



M_color         = [200 200 200];
U_color         = [200 200 200];
I_color         = [200 200 200];
cue_color       = [0 0 0]; %black
%circle size
circleOne          = [0 0 80 80];
circleTwo          = [0 0 120 120];
circleThree        = [0 0 160 160];
circleFour         = [0 0 200 200];
%circle positions
first       = CenterRectOnPoint(circleOne,pms.xCenter,pms.yCenter);
second      = CenterRectOnPoint(circleTwo,pms.xCenter,pms.yCenter);
third       = CenterRectOnPoint(circleThree,pms.xCenter,pms.yCenter);
fourth      = CenterRectOnPoint(circleFour,pms.xCenter,pms.yCenter);



data            = struct();



%% loop around trials and blocks for stimulus presentation

bonus       = 0; %start value of reward/bonus is 0.00
for p=1:numBlocks
    %set up eyetracking
%     pms.driftShift = [0,0]; % how much to adjust [x,y] for pupil drift, updated every trial
    if practice==0
%         EyelinkInitDefaults(wPtr);
%         pms.el = EyelinkSetup(1,wPtr);
%         Eyelink('StartRecording')
%         Screen('FillRect', wPtr, pms.background, rect);
        if pms.spaceBar==1
            DrawFormattedText(wPtr, sprintf('Good luck with the memory task!\n Please keep your hands on the mouse and the space bar.'), 'center', 'center',[0 0 0]);
        elseif pms.spaceBar==0
            DrawFormattedText(wPtr, sprintf('Good luck with the memory task!\n Please keep your hand on the mouse.'), 'center', 'center',[0 0 0]);
        end 
        Screen('Flip',wPtr);
        WaitSecs(2); 
        if p==2
            if pms.blockCB==0
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nIGNORE\n\n\n\n'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                WaitSecs(3);
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nIGNORE\n\n\n\nPress space to start'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                KbWait();
            elseif pms.blockCB==2
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nUPDATE\n\n\n\n'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                WaitSecs(3);
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nUPDATE\n\n\n\nPress space to start'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                KbWait();
            end 
        elseif p==3
           if pms.blockCB==0
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nUPDATE\n\n\n\n'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                WaitSecs(3);
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nUPDATE\n\n\n\nPress space to start'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                KbWait();
           elseif pms.blockCB==2
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nIGNORE\n\n\n\n'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                WaitSecs(3);
                DrawFormattedText(wPtr,sprintf('You will get mostly\n\nIGNORE\n\n\n\nPress space to start'),'center','center',[0 0 0]);
                Screen('Flip',wPtr);
                KbWait();
           end  
        end
    end 
    
    Screen('Flip',wPtr);
    WaitSecs(1.5);
    
    blockOnset  = GetSecs; %onset time of block. Block lasts x min. After x min, block ends automatically.
    for g=1:numTrials
        for phase = 1:9
            if phase==1 && pms.points==1 % reward on offer
%                 valid = 1;
                if practice~=1
                    offer = sprintf('%d', trial(g,p).offer);
                    Screen('Textsize', wPtr, 34);
                    Screen('Textfont', wPtr, 'Times New Roman');
                    DrawFormattedText(wPtr, offer, 'center', 'center');  
                    T.offer_on(g,p) = Screen('Flip',wPtr);
                    WaitSecs(pms.offerDuration);      
                    
                    % During my task, participants must look at a central offer for 1
                    % sec for the trial to proceed. Since the calibration for gaze location
                    % might drift over time, I've built in a drift calibration routine using
                    % while loops to ask whether Participants are looking at a specified
                    % location. They can press the left control key (coded in pms.allowedResps.drift)
                    % if they think they are and the trial isn't starting. That toggles into a
                    % second "drift correction" while loop that allows the experimenter to
                    % press 'd' for "drift correction" (pms.allowedResos.driftOK) when they
                    % are satisfied that the participant is looking at the center of the
                    % screen, and this sets a value pair called "driftShift" which subsequently
                    % adjusts all future X,Y value pairs collected from the Eyelink. note that
                    % wRect is just the monitor window rectangle, wptr, is the window ID
                    % pointer, pms.bkgd is a rectangle in which I want stimuli to be
                    % displayed.

%                     % Ensure central fixation before showing trial
%                     driftShift = pms.driftShift;
%                     fixOn = 0; % continuous amount of time spent fixating on cross
%                     doDrift = 0; % to break out of both loops
% 
%                     while fixOn < pms.fixDuration
%                         sample = getEyelinkData();
%                         while doDrift % drift correction
%                             [~, ~, keyCode] = KbCheck();
%                             if strcmp(pms.allowedResps.driftOK,KbName(keyCode));
%                                 sample = getEyelinkData();
%                                 driftShift = [(rect(3)/2)-sample(1),(rect(4)/2)-sample(2)]; %[x,y]
%                                 %report = '***** Drift adjusted! *****';
%                                 %report = sprintf('x = %0.2f, y = %0.2f',driftShift(1),driftShift(2));
%                                 doDrift = 0;
%                                 DrawFormattedText(wPtr, offer, 'center', 'center', cue_color);   % change its color back to background text color
%                                 Screen('Flip',wPtr);
%                             end
%                         end
% 
%                         time1 = GetSecs();
%                         while ((sample(1)+driftShift(1))-rect(3)/2)^2+((sample(2)+driftShift(2))-rect(4)/2)^2 < pms.diagTol^2 && fixOn < pms.fixDuration %euclidean norm to calculate radius of gaze
%                             sample = getEyelinkData();
%                             time2 = GetSecs();
%                             fixOn = time2 - time1;
%                         end
% 
%                         % if not yet met the timelimit and gaze outside target circle
%                         [~, ~, keyCode] = KbCheck();
%                         if strcmp(pms.allowedResps.drift,KbName(keyCode));
%                             %report = '***** The participant indicates drift! *****'
%                             doDrift = 1;
%                             DrawFormattedText(wPtr, offer, 'center', 'center', pms.driftCueCol); % change its color
%                             DrawFormattedText(wPtr, 'Please look at the center of the screen.', 'center', 'center', pms.driftCueCol);
%                             Screen('Flip',wPtr);
%                         end
%                     end 
                    if pms.spaceBar==1
                        %let them press space to continue (as manipulation check to hopefully see effect of average reward on vigor)
                        WaitSecs(randn(1)*0.1); %extra jittered waiting time during which reward is shown 
                        Screen('Textsize', wPtr, 34);
                        Screen('Textfont', wPtr, 'Times New Roman');
                        DrawFormattedText(wPtr, offer, 'center', 'center', cue_color);
                        DrawFormattedText(wPtr, '[Press Space]', 'center', pms.yCenter+100, cue_color);
                        T.space_on(g,p) = Screen('Flip',wPtr);
                        T.space_off(g,p) = KbWait();
                        T.offer_off(g,p) = Screen('Flip',wPtr);
                        rtSpace = T.space_off(g,p) - T.space_on(g,p); 
                        WaitSecs(pms.offerdelay); 
                    elseif pms.spaceBar==0
                        WaitSecs(randn(1)*0.1); %extra jittered waiting time during which reward is shown 
                        T.space_on(g,p) = NaN;
                        T.space_off(g,p) = NaN;
                        T.offer_off(g,p) = Screen('Flip',wPtr);
                        rtSpace = NaN; 
                        WaitSecs(pms.offerdelay); 
                    end 
                end 
%                 valid = valid +1;
            elseif phase==1 && pms.points==0
                if practice~=1
                    T.offer_on(g,p) = NaN;
                    T.space_on(g,p) = NaN;
                    T.space_off(g,p) = NaN;
                    T.offer_off(g,p) = NaN;
                    rtSpace = NaN; 
                end
            elseif phase==2 %cue update or ignore
%                 if practice~=1
%                    Screen('Textsize', wPtr, 34);
%                    Screen('Textfont', wPtr, 'Times New Roman');
%                    if trial(g,p).cue==0
%                        cueText     = 'ignore';
%                    elseif trial(g,p).cue==2
%                        cueText     = 'update';
%                    end 
%                    DrawFormattedText(wPtr, cueText, 'center', 'center', cue_color);  
%                    T.cue_on(g,p) = Screen('Flip',wPtr);               
%                    WaitSecs(pms.cueduration);
%                    T.cue_off(g,p) = Screen('Flip',wPtr);
%                    WaitSecs(pms.cuedelay);
%                 end
%                 valid = valid +1;
            elseif phase==3    % encoding phase
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                        switch trial(g,p).setSize  %switch between set sizes
                            case 1                 % setsize 1
                                allCircles  = [first'];
                                colorEnc    = (trial(g,p).colors((1),:))';
                            case 2                 % setsize 2
                                allCircles  = [second', first'];
                                colorEnc    = (trial(g,p).colors((2,1),:))';
                            case 3                 % setsize 3
                                allCircles  = [third',second', first'];
                                colorEnc    = (trial(g,p).colors((3,2,1),:))';
                            case 4                 % setsize 4
                                allCircles  = [fourth', third',second', first'];
                                colorEnc    = (trial(g,p).colors((4,3,2,1),:))';
                        end
                        trial(g,p).colorEnc = colorEnc;
                                
                        Screen('FillOval',wPtr,colorEnc,allCircles);
                        DrawFormattedText(wPtr, EncSymbol, 'center', 'center', M_color);
                        T.encoding_on(g,p) = Screen('Flip',wPtr);     

%                         imageArray=Screen('GetImage',wPtr);                     
%                         imwrite(imageArray,sprintf('encoding2%d%d.png',g,p),'png');  
%                         if practice == 0
% %                             [itrack_encoding] = sampleGaze(driftShift,T.encoding_on(g,p),pms.encDuration); 
%                         else
                            WaitSecs(pms.encDuration);
%                         end 
                        T.encoding_off(g,p) = GetSecs;
%                  if practice==0 && (sum(itrack_encoding.X < 0.4*rect(3)-100 | itrack_encoding.X > 0.6*rect(3)+100 | itrack_encoding.Y < 0.4*rect(4)-100 | itrack_encoding.Y > 0.6*rect(4)+100) > 80) % if eyes were closed for too long (negative x and y values) or gaze was not directed at the squares or the center of the screen during approx 40% of encoding, trial will be marked as invalid.
%                      respX = [];
%                      respY = [];
%                      rtDecision = [];
%                      rtMovement = [];
%                      rtTotal = [];
%                      respDif = [];
%                      lureDif = [];
%                      radius = [];
%                      tau = [];
%                      thetaCorrect = []; 
%                      itrack_interference = [];
%                      itrack_probe = [];
%                      continue;
%                  end 
%                  valid = valid +1;
            elseif phase==4      %delay 1 phase
%                 if valid ~= phase
%                     DrawFormattedText(wPtr, 'Please try to look at the screen while doing the task.\nThe next trial will start shortly.', 'center', 'center', U_color);
%                     Screen('Flip',wPtr);
%                     WaitSecs(pms.delay1Duration);
%                     continue; 
%                 end 
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
%                 valid = valid +1;
            elseif phase==5 %interference phase
%                 if valid ~= phase
%                     DrawFormattedText(wPtr, 'Please try to look at the screen while doing the task.\nThe next trial will start shortly.', 'center', 'center', U_color);
%                     Screen('Flip',wPtr);
%                     WaitSecs(pms.interfDuration);
%                     continue; 
%                 end 
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');              
                    switch trial(g,p).type
                        case 0 %interference Ignore
                            switch trial(g,p).setSize
                                case 1
                                    allCircles  = [first'];
                                    colorInt    = trial(g,p).colors(2,:);
                                case 2
                                    allCircles  = [second', first'];
                                    colorInt    = (trial(g,p).colors((4,3),:))';
                                case 3
                                    allCircles  = [third',second', first'];
                                    colorInt    = (trial(g,p).colors((6,5,4),:))';      
                                case 4
                                    allCircles  = [fourth', third',second', first'];
                                    colorInt    = (trial(g,p).colors((8,7,6,5),:))';
                            end
                        
                            Screen('FillOval',wPtr,colorInt,allCircles);
                            DrawFormattedText(wPtr, IgnSymbol, 'center', 'center', I_color);
                            T.interference_on(g,p) = Screen('Flip',wPtr); 
%                             if practice == 0
%                                 [itrack_interference] = sampleGaze(driftShift,T.interference_on(g,p),pms.interfDuration);                        
%                             else
                                WaitSecs(pms.interfDuration);
%                             end 
                            T.interference_off(g,p) = GetSecs;
                        
                        case 2 %Interference Update
                        
                            switch trial(g,p).setSize
                                case 1
                                    allCircles  = [first'];
                                    allRects    = rectOne;
                                case 2
                                    allCircles  = [second', first'];
                                    colorInt    = (trial(g,p).colors((4,3),:))';
                                case 3
                                    allCircles  = [third',second', first'];
                                    colorInt    = (trial(g,p).colors((6,5,4),:))'; 
                                case 4
                                    allCircles  = [fourth', third',second', first'];
                                    colorInt    = (trial(g,p).colors((8,7,6,5),:))';
                            end
                            trial(g,p).colorInt = colorInt;
                                                                
                            Screen('FillOval',wPtr,colorInt,allCircles);
                            DrawFormattedText(wPtr, UpdSymbol, 'center', 'center', U_color);
                            T.interference_on(g,p) = Screen('Flip',wPtr);                     
%                             if practice == 0
%                                 [itrack_interference] = sampleGaze(driftShift,T.interference_on(g,p),pms.interfDuration);                        
%                             else
                                WaitSecs(pms.interfDuration);
%                             end 
                            T.interference_off(g,p) = GetSecs;       
                    end % trial.type
%                  if practice == 0 && (sum(itrack_interference.X < 0.4*rect(3)-100 | itrack_interference.X > 0.6*rect(3)+100 | itrack_interference.Y < 0.4*rect(4)-100 | itrack_interference.Y > 0.6*rect(4)+100) > 80) % if eyes were closed for too long (negative x and y values) or gaze was not directed at the squares or the center of the screen during approx 40% of encoding, trial will be marked as invalid.
%                      respX = [];
%                      respY = [];
%                      rtDecision = [];
%                      rtMovement = [];
%                      rtTotal = [];
%                      respDif = [];
%                      lureDif = [];
%                      radius = [];
%                      tau = [];
%                      thetaCorrect = []; 
%                      itrack_interference = [];
%                      itrack_probe = [];
%                      continue;
%                  end 
%                  valid = valid +1;
            elseif phase==6 %phase delay 2
%                 if valid ~= phase
%                     DrawFormattedText(wPtr, 'Please try to look at the screen while doing the task.\nThe next trial will start shortly.', 'center', 'center', U_color);
%                     Screen('Flip',wPtr);    
%                     switch trial(g,p).type
%                         case 0
%                             WaitSecs(pms.delay2DurationIgn);
%                         case 2
%                             WaitSecs(pms.delay2DurationUpd);
%                     end
%                     continue; 
%                 end 
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
%                 valid = valid +1;
                
            elseif phase==7  %probe phase
%                 if valid ~= phase
%                     DrawFormattedText(wPtr, 'Please try to look at the screen while doing the task.\nThe next trial will start shortly.', 'center', 'center', U_color);
%                     Screen('Flip',wPtr);
%                     correct = 0;
%                     WaitSecs(pms.maxRT + pms.median_rtMovement);
%                     continue; 
%                 end 
                if practice~=0 
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
                    %location/circle
                    probeRectX=trial(g,p).locations(1,1);
                    probeRectY=trial(g,p).locations(1,2);                 
                end %if practice==0
                
                T.probe_on(g,p) = GetSecs;
%                 if practice == 0
%                      [respX,respY,rtDecision, rtMovement, rtTotal, colortheta,correct,itrack_probe]=probecolorwheel(pms,allRects,probeRectX,probeRectY,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p,driftShift, trial);
%                 else 
                     [respX,respY,rtDecision, rtMovement, rtTotal, colortheta,correct]=probecolorwheel(pms,allRects,probeRectX,probeRectY,practice,trial(g,p).probeColorCorrect,trial(g,p).lureColor,rect,wPtr,g,p,trial(g,p).type, trial);
%                 end
                T.probe_off(g,p) = GetSecs;
                [respDif,tau,thetaCorrect,radius,lureDif]=respDev(colortheta,trial(g,p).probeColorCorrect,trial(g,p).lureColor,respX,respY,rect);
               
            elseif phase==8 % feedback about their reward
               Screen('Flip',wPtr);  
               if practice~=1 && pms.points==1 
                   Screen('Textsize', wPtr, 28);
                   Screen('Textfont', wPtr, 'Times New Roman');
                   if correct==1 % if they were accurate enough
                       DrawFormattedText(wPtr,sprintf('You win %d points',trial(g,p).offer),'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                       Screen('Flip',wPtr);  
                       T.feedback_on(g,p) = GetSecs;
                       WaitSecs(pms.rewardduration);
                   else 
                       DrawFormattedText(wPtr,'You win 0 points', 'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
                       Screen('Flip',wPtr);  
                       T.feedback_on(g,p) = GetSecs;
                       WaitSecs(pms.rewardduration);
                   end
                   drawFixationCross(wPtr,rect);
                   Screen('Flip',wPtr); 
                   T.feedback_off(g,p) = GetSecs;
               elseif practice~=1 && pms.points==0
                   drawFixationCross(wPtr,rect);
                   Screen('Flip',wPtr); 
                   T.feedback_on(g,p) = GetSecs;
                   WaitSecs(pms.rewardduration);
                   T.feedback_off(g,p) = GetSecs;
               end 
                              
       
                %save responses and data into a struct.
                data(g,p).respCoord=[respX respY]; %saving response coordinates in struct where 1,1 is x and 1,2 y
                data(g,p).correct=correct;
                data(g,p).rtDecision=rtDecision;
                data(g,p).rtMovement=rtMovement;
                data(g,p).rt=rtTotal;
                if exist('rtSpace', 'var')
                    data(g,p).rtSpace=rtSpace;
                elseif ~exist('rtSpace', 'var')
                    data(g,p).rtSpace=NaN;
                end
                data(g,p).probeLocation=[trial(g,p).locations(1,1) trial(g,p).locations(1,2)];
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
                if practice~=1
                    data(g,p).offer=trial(g,p).offer;
                elseif practice==1
                    data(g,p).offer= NaN;
                end 
                if practice~=1
%                     data(g,p).cue = trial(g,p).cue;
%                     data(g,p).valid = trial(g,p).valid;
                end
                save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                if practice==0
                    if correct==1 %if they did better than a maximum deviance
                        data(g,p).reward=trial(g,p).offer;
                    else                                      
                        data(g,p).reward=0;
                    end
                    bonus = bonus + data(g,p).reward;
                    data(g,p).bonus = bonus;
                    money = bonus / 2500;
                    data(g,p).encColLoc1=trial(g,p).encColLoc1;
                    data(g,p).encColLoc2=trial(g,p).encColLoc2;
                    data(g,p).encColLoc3=trial(g,p).encColLoc3;
                    data(g,p).encColLoc4=trial(g,p).encColLoc4;
                    data(g,p).interColLoc1=trial(g,p).interColLoc1;
                    data(g,p).interColLoc2=trial(g,p).interColLoc2;
                    data(g,p).interColLoc3=trial(g,p).interColLoc3;
                    data(g,p).interColLoc4=trial(g,p).interColLoc4;
%                     gazedata(g,p).encoding = itrack_encoding; % save all eyetracker data here
%                     gazedata(g,p).interference = itrack_interference; % save all eyetracker data here
%                     gazedata(g,p).probe = itrack_probe; % save all eyetracker data here
%                     pms.driftShift = driftShift; % update for next trial
                    save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                elseif practice~=0
                    save(fullfile(pms.subdirICW,dataFilenamePrelim),'data', 'T');
                end
                
            elseif phase==9 % extra time for I trials
                if trial(g,p).type == 0                    
                    WaitSecs(pms.makeUpDurationI);
                end 
                
            end %if phase ==1
        end % for phase 1:9
        % break after each block (after 20 min)
        if practice==0           
            if GetSecs-blockOnset > pms.blockDuration
                if p==1
                    getInstructions(5,pms,wPtr);
%                   Eyelink('Stoprecording')
%                   pms.el = EyelinkSetup(0,pms);
                    break; %end numTrials loop and go to next block
                elseif p==numBlocks
                    DrawFormattedText(wPtr,sprintf('End of the experiment. Please press space.'),'center','center',[0 0 0]);
                else 
                    DrawFormattedText(wPtr,sprintf('End of this block. You can now have a break.\nPress space when you are ready to start the new block.'),'center','center',[0 0 0]);
                end
                Screen('Flip',wPtr);
                RestrictKeysForKbCheck(32);
                KbWait();
                RestrictKeysForKbCheck([])
%                 Eyelink('Stoprecording')
%                 pms.el = EyelinkSetup(0,pms);
                break; %end numTrials loop and go to next block
            end 
        end          
    end  % for g=1:numTrials 
end % for p=1:numBlocks

end 

