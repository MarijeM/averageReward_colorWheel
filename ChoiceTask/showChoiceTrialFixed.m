function [data] = showChoiceTrialFixed(pms, data, wPtr,rect, dataFilenamePrelim)

%%%% setup at the beginning of a trial

%% What we need
% 1) general locations on screen
xlength = rect(3); %screen length x
ylength = rect(4); %screen height y
%define left centre (LC) and right centre (RC)
LC = [xlength/4, ylength/2];
RC = [xlength*(3/4), ylength/2];
rectsizeFB = [0 0 250 250];
rectsizeC= [0 0 xlength/1.2 ylength/1.5];
FB_left = CenterRectOnPoint(rectsizeFB,LC(1)+60,LC(2));
FB_right = CenterRectOnPoint(rectsizeFB,RC(1)-40,RC(2));
rect_Center=CenterRectOnPoint(rectsizeC,xlength/2,ylength/2);

% 3) locations of squares
% give and fine tune offset of centre
offset = 100; %offset (symmetrical)
locations_left = [LC + [-offset -offset]; LC + [offset -offset]; LC + [offset offset]; LC + [-offset offset]];
locations_right = [RC + [-offset -offset]; RC + [offset -offset]; RC + [offset offset]; RC + [-offset offset]];

% 4) text on screen while choice
msgUPD = 'Update';
msgIGN = 'Ignore';


%% Stimulus presentation starts here
for trial = 1:length(data.trialNumber)
    
    save(fullfile(pms.subdirCh,dataFilenamePrelim.dataFilenamePrelim))
    
    msgHard = double(sprintf('for €%.2f',data.hardOffer(trial)));
    msgEasy = double(sprintf('for €%.2f',data.easyOffer(trial)));
    
    switch data.locationEasy(trial)
        case 1 %means easy option left, hard right
            
            switch data.typeTask(trial)
                
                case 1   % setsize 1 for Direct comparison and IGNORE 1 for No redo version
                    switch data.version(trial)
                        case 1
                            msgTypeL='No Redo';
                            msgTypeR='Ignore 1';
                        case 2
                            msgTypeL='Update 1';
                            msgTypeR='Ignore 1';
                    end
                    
                    
                case 2                % setsize 2 or Ignore 2
                    switch data.version(trial)
                        case 1
                            msgTypeL='No Redo';
                            msgTypeR='Ignore 2';
                        case 2
                            msgTypeL='Update 2';
                            msgTypeR='Ignore 2';
                    end
                case 3                % setsize 4
                    switch data.version(trial)
                        case 1
                            msgTypeL='No Redo';
                            msgTypeR='Ignore 3';
                        case 2
                            msgTypeL='Update 3';
                            msgTypeR='Ignore 3';
                    end
                    
                case 4 % set size 4 or Ignore 4
                    switch data.version(trial)
                        case 1
                            msgTypeL='No Redo';
                            msgTypeR='Ignore 4';
                        case 2
                            msgTypeL='Update 4';
                            msgTypeR='Ignore 4';
                    end
                case 5 %Update 1
                    
                    msgTypeL='No Redo';
                    msgTypeR='Update 1';
                    
                case 6 % Update 2
                    
                    msgTypeL='No Redo';
                    msgTypeR='Update 2';
                    
                    
                case 7 % Update 3
                    
                    msgTypeL='No Redo';
                    msgTypeR='Update 3';
                    
                case 8 %Update 4
                    msgTypeL='No Redo';
                    msgTypeR='Update 4';
                    
            end %switch typeTask
            
            msgRight = msgHard;
            msgLeft = msgEasy;
            
        case 2 %means easy option right, hard left
            
            switch data.typeTask(trial)
                
                case 1   % setsize 1 for Direct comparison and IGNORE 1 for No redo version
                    switch data.version(trial)
                        case 1
                            msgTypeR='No Redo';
                            msgTypeL='Ignore 1';
                        case 2
                            msgTypeR='Update 1';
                            msgTypeL='Ignore 1';
                    end
                    
                    
                case 2                % setsize 2 or Ignore 2
                    switch data.version(trial)
                        case 1
                            msgTypeR='No Redo';
                            msgTypeL='Ignore 2';
                        case 2
                            msgTypeR='Update 2';
                            msgTypeL='Ignore 2';
                    end
                case 3                % setsize 4
                    switch data.version(trial)
                        case 1
                            msgTypeR='No Redo';
                            msgTypeL='Ignore 3';
                        case 2
                            msgTypeR='Update 3';
                            msgTypeL='Ignore 3';
                    end
                    
                case 4 % set size 4 or Ignore 4
                    switch data.version(trial)
                        case 1
                            msgTypeR='No Redo';
                            msgTypeL='Ignore 4';
                        case 2
                            msgTypeR='Update 4';
                            msgTypeL='Ignore 4';
                    end
                case 5 %Update 1
                    
                    msgTypeR='No Redo';
                    msgTypeL='Update 1';
                    
                case 6 % Update 2
                    
                    msgTypeR='No Redo';
                    msgTypeL='Update 2';
                    
                    
                case 7 % Update 3
                    
                    msgTypeR='No Redo';
                    msgTypeL='Update 3';
                    
                case 8 %Update 4
                    msgTypeR='No Redo';
                    msgTypeL='Update 4';
                    
            end %switch typeTask
            
            msgRight = msgEasy;
            msgLeft = msgHard;
    end %switch location left right
    
    %present choices on screen
    drawFixationCross(wPtr, rect);
    DrawFormattedText(wPtr,msgTypeR , RC(1)-100,RC(2)-60);
    DrawFormattedText(wPtr,msgRight, RC(1)-100,RC(2));
    DrawFormattedText(wPtr,msgTypeL, LC(1),LC(2)-60);
    DrawFormattedText(wPtr, msgLeft, LC(1),LC(2));
    Screen('FrameRect',wPtr,[0 0 0],rect_Center);
    
    offerOnset = Screen('Flip',wPtr);
%        imageArray=Screen('GetImage',wPtr);
%         imwrite(imageArray,sprintf('newChoice%d.png',trial),'png');
    choiceOnset = offerOnset - pms.exptOnset;
    %    WaitSecs(pms.maxRT);
    WaitSecs(0.001);
    key=[];
    responded = [];
    choiceRTAll=[];
    while (GetSecs - offerOnset) < pms.maxRT
        % check keyboard
        RestrictKeysForKbCheck([pms.allowedResps.left, pms.allowedResps.right,37,39,32,97,98])
        [keyIsDown, secs, keyCode] = KbCheck;
        WaitSecs(0.1);
        if keyIsDown==1
            % a response has just occurred
            %key = [KbName(keyCode),num2str(evt.state)];
            if any(ismember(KbName(keyCode),[pms.allowedResps.left, pms.allowedResps.right]))
                % response was allowable
                responded = 1;
                key=[key KbName(keyCode)];
                respTimeStamp = GetSecs;
                choiceRTAll =[choiceRTAll; secs - offerOnset];
                choiceRT = choiceRTAll(1); %first response counts
                
                if any(ismember(key(1),[pms.allowedResps.left])) && data.locationEasy(trial)==1;
                    % left key was pressed and easy choice was on left
                    resp =1;
                    % feedback verifying participant's response
                    Screen('FrameRect',wPtr, 0, FB_left, 2);
                elseif any(ismember(key(1),[pms.allowedResps.left])) && data.locationEasy(trial)==2;
                    % left key was pressed and easy choice was on right
                    resp =2;
                    % feedback verifying participant's response
                    Screen('FrameRect',wPtr, 0, FB_left, 2);
                elseif any(ismember(key(1),[pms.allowedResps.right])) && data.locationEasy(trial)==1;
                    % right key was pressed and easy choice was on left
                    resp = 2;
                    % feedback verifying participant's response
                    Screen('FrameRect',wPtr, 0, FB_right, 2);
                elseif any(ismember(key(1),[pms.allowedResps.right])) && data.locationEasy(trial)==2;
                    %right key was pressed and easy choice was on right
                    resp =1;
                    Screen('FrameRect',wPtr, 0, FB_right, 2);
                end
                
            end
            RestrictKeysForKbCheck([])
        end %key is down
        %         WaitSecs(.001);
        %% present feedback
        DrawFormattedText(wPtr,msgTypeR , RC(1)-100,RC(2)-60);
        DrawFormattedText(wPtr,msgRight, RC(1)-100,RC(2));
        DrawFormattedText(wPtr,msgTypeL, LC(1),LC(2)-60);
        DrawFormattedText(wPtr, msgLeft, LC(1),LC(2));
        Screen('FrameRect',wPtr,[0 0 0],rect_Center);
        drawFixationCross(wPtr, rect);
        Screen('Flip',wPtr,[],1);
%                 imageArray=Screen('GetImage',wPtr);
%                 imwrite(imageArray,sprintf('ChoiceMade%d.png',trial),'png');
        %     WaitSecs(0.5)
        
        
        
    end %while is empty responded
    
    %check to see if participant is too slow
    if isempty(responded);
        resp = 9;
        choiceRT = 0;
        DrawFormattedText(wPtr,'Too slow!','center',ylength*(1/4));
        Screen('Flip',wPtr)
        WaitSecs(pms.iti);
        
    end
    
    data.choice(trial) = resp;
    data.choiceRT(trial) = choiceRT;
    data.choiceOnset(trial) = choiceOnset;
    data.key(trial,1:length(key))=key; %all responses are recorded as keypresses here, not choices
    % money they accepted
    switch resp
        case 1
            data.choiceAmount(trial)=data.easyOffer(trial);
        case 2
            data.choiceAmount(trial)=data.hardOffer(trial);
        case 9
            data.choiceAmount(trial)=NaN;
    end
    
    
    %clear screen
    Screen('FillRect',wPtr, pms.background, rect);
    drawFixationCross(wPtr, rect);
    Screen('FrameRect',wPtr,[0 0 0],rect_Center);
    
    Screen('Flip',wPtr);
    %          imageArray=Screen('GetImage',wPtr);
    %         r=randi(100,1);
    %         imwrite(imageArray,sprintf('choiceMade%d',r),'bmp');
    WaitSecs(pms.iti);
    
    
    %Break after every block
    if trial~=length(data.block)
        if data.block(trial)-data.block(trial+1)~=0
            if pms.practice==0
                DrawFormattedText(wPtr,sprintf('End of block %d, press space to continue.',data.block(trial) ),'center','center',[0 0 0]);
                Screen('Flip',wPtr)
                RestrictKeysForKbCheck(32)
                KbWait();
                RestrictKeysForKbCheck([])
                WaitSecs(2)
            elseif pms.practice==1
                getInstructionsChoice(2,pms,wPtr)
            end
            
        end
    end
end %trial loop
save(fullfile(pms.subdirCh,dataFilenamePrelim.dataFilenamePrelim)) % save after every trial in prelim file

end
