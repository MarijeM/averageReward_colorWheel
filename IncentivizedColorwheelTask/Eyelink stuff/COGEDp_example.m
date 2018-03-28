function [] = COGEDp(prac)
% COGEDp
%
% This function presents the delay discounting task for eye tracking.
%
% Participants make a series of choices between tasks varying in
% delay for different amounts of money. The task starts with practice
% trials and then proceeds to a series of pairwise offers designed first to
% find indifference points, then repeat offers varying orthogonally across
% amounts, bias (toward or away from higher effort option), and delay. 
%
% This file includes the following subfunctions:
%   displayMessage
%   getSubjectInfo
%   disp_Tasks
%   showDmTrial
%   showITI
%
% Last updated by JAW on 10/19/17

try
    % initialize the random number generator
    randSeed = sum(100*clock);
    
    % set experiment parameters
    pms.tasks = {'a','e','i','u'}; % {'a','e','i','u'};
    pms.taskPairs = {{2,3,4},{3,4}}; %{{2,3,4},{3,4}}; % cell struct position corresponds to the cell array position in pms.delays
    pms.availableColors = {[0, 0, 0]; [240, 0, 0]; [0, 0, 255]; [95, 0, 115]};
    pms.txtFont = 'Arial';
    pms.txtSize = 40;
    pms.txtSpacing = 1.4; % vertical spacing between lines of text
    pms.ground = 200; % size of squares for option locations
    pms.textCol = [150*ones(1,3), 255]; % text color
    pms.driftCueCol = [10 150 10, 255]; % cue that central fix changes when drifting is indicated
    pms.selCol = [10 150 10, 255]; % selection box color
    % allowable response characters
    pms.allowedResps.left = ',1';
    pms.allowedResps.right = '.2';
    pms.allowedResps.drift = 'space';
    pms.allowedResps.driftOK = 'd';
    pms.driftShift = [0,0]; % how much to adjust [x,y] for pupil drift, updated every trial
    pms.chcDuration = 9; % max choice duration
    pms.trlDuration = 3; % max trial duration in seconds (including ITI)
    pms.fixDuration = 0.75; % required fixation duration in seconds before trials initiate
    pms.diagTol = 100; % diagonal pixels of tolerance for fixation
    
    % set bias levels (% difference between indifference point and bounds)
    pms.upprox = [.3,.5];
    pms.dnprox = [-.3,-.2];
    % set base offer amounts (in $s)
    pms.amts = [2,4]; %[2,4]
    % set the number of decision trials
    pms.nCalTrials = 5; % Number of calibration trials per task to detect indifference point
    pms.nTrials = 1; % Number of decisions, following calibration, per task, amount, and proximity point
    
    if strcmp(prac,'p') % different values for practice runs
        pms.nCalTrials = 1;
        pms.nTrials = 0;
        pms.amts = 0;
        pms.tasks = {'a','e','i','u'};
        pms.taskPairs = {{2,3,4},{3,4}}; % cell struct position corresponds to the cell array position in pms.tasks
        pms.availableColors = pms.availableColors(1); % set text colors for practice decisions
        pms.chcDuration = 12; % max choice duration
        pms.trlDuration = 3; % max trial duration in seconds (including ITI)
    elseif strcmp(prac,'c')
        pms.chcDuration = 12; % max choice duration
        pms.trlDuration = 3; % max trial duration in seconds (including ITI)
    end
    
    [pms.keyboards] = GetKeyboardIndices();
    % display parameters
    [pms.screens] = Screen('Screens');
    pms.mon = pms.screens(end); % 0 for primary monitor
    pms.bkgd = 20; % intensity level of background gray
    pms.wrptx = 25; % text wrapping position
    % bit Added to address problem with high precision timestamping related
    % to graphics card problems
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference','VisualDebugLevel',0);
    Screen('Preference', 'VBLTimestampingMode', -1);  
    Screen('Preference','TextAlphaBlending',0);
    
    % unpermutted array of all short-long delay combos for calibration
    % columns of 1) short delay, 2) long delay, 3) amount, 4) proximity
    calArray = [];
    for jj = 1:length(pms.taskPairs)
        for kk = 1:length(pms.amts)
            calArray = [calArray;repmat(jj,pms.nCalTrials*length(pms.taskPairs{jj}),1),... % easy task
            repmat(cell2mat(pms.taskPairs{jj})',pms.nCalTrials,1),... % hard tasks
            repmat(pms.amts(kk),pms.nCalTrials*length(pms.taskPairs{jj}),1),... % amounts
            ones(pms.nCalTrials*length(pms.taskPairs{jj}),1)]; % proximity (1 is a placeholder)
        end
    end
    
    % unpermutted array of all regular trials
    % columns of 1) short delay, 2) long delay, 3) amount, 4) proximity
    regArray = [];
    for jj = 1:length(pms.amts)
        amount = pms.amts(jj);
        for kk = 1:length(pms.taskPairs) % short delay indices
            tasks = cell2mat(pms.taskPairs{kk});
            for task = tasks % long delay indices
                for aboveBelow = 1:2 % 1 for sooner option below SV, 2 for above
                    if (jj==1 && aboveBelow==1) || (jj==2 && aboveBelow==2)
                        if jj==1; proxs = pms.dnprox; else proxs = pms.upprox; end
                        % 9 times short delay, long delay, amount, prox
                        regArray = [regArray; ones(9,1)*kk, ones(9,1)*task, ones(9,1)*amount, rand(9,1).*(proxs(2)-proxs(1))+proxs(1)];
                        
                        % catch trials
                        if jj==1 && ((kk==1 && task==2) || (kk==2 && task==3) || (kk==2 && task==4))
                           regArray = [regArray; ones(3,1)*kk, ones(3,1)*task, ones(3,1)*amount, ones(3,1)*-1];
                        end
                        if jj==2 && ((kk==1 && task==2) || (kk==2 && task==3) || (kk==2 && task==4))
                           regArray = [regArray; ones(3,1)*kk, ones(3,1)*task, ones(3,1)*amount, ones(3,1)*1];
                        end
                        
                    else
                        if jj==1; proxs = pms.upprox; else proxs = pms.dnprox; end
                        % 6 times short delay, long delay, amount, prox
                        regArray = [regArray; ones(6,1)*kk, ones(6,1)*task, ones(6,1)*amount, rand(6,1).*(proxs(2)-proxs(1))+proxs(1)];
                        
                        % catch trials 2 total for each task pair, each , 
%                         if jj==1 && ((kk==1 && task==2) || (kk==2 && task==3) || (kk==2 && task==4))
%                            regArray = [regArray; ones(3,1)*kk, ones(3,1)*task, ones(3,1)*amount, ones(3,1)*-1];
%                         end
                        
                    end
                end
            end
        end
    end
        
    % indices for randomly permutted order of calibration, and other trials
    randIndCal = randperm(size(calArray,1)); 
    randIndReg = randperm(size(regArray,1));
        
    % permutted, concatenated calibration and regular trials with three
    % columns of indices of 1) short delay, 2) long delay, 3) amount, 4) proximity, 5) dlAmtTrlNm, 6) absolute value of amount adjustment
    trlArray = [calArray(randIndCal,:); regArray(randIndReg,:)];
    
    trlArray(:,5) = 0; % add trial number by short and long delays and amounts
    ctr = zeros(length(pms.taskPairs),length(pms.tasks),length(pms.amts));
    for jj = 1:size(trlArray,1)
        amtidx = find(pms.amts==trlArray(jj,3));
        ctr(trlArray(jj,1),trlArray(jj,2),amtidx) = ctr(trlArray(jj,1),trlArray(jj,2),amtidx) + 1;
        trlArray(jj,5) = ctr(trlArray(jj,1),trlArray(jj,2),amtidx);
    end
    
    trlArray(:,6) = 0; % add absolute value of amount adjustment
    trlArray(1:size(calArray,1),6) = trlArray(1:size(calArray,1),3) ./ (2.^(trlArray(1:size(calArray,1),5)+1));
    
    pms.dispTasks = 1:size(calArray,1)/3:size(calArray,1); % calibration trials before which the list of delays will be displayed briefly
    nRows = size(trlArray,1);

    if strcmp(prac,'c') || strcmp(prac,'p')
        % prepare data structure
        data.trialNumber = (1:nRows)';
        data.tskAmtTrlNm = trlArray(:,5); % trial number for each task-amount pair
        data.ssPos = nan(nRows,1); % position of the easy option 1 = left, 2 = right
        data.aaTop = nan(nRows,1); % position of amounts 1 = top, 2 = bottom
        data.choiceOnset = nan(nRows,1); % onset timestamp
        data.choiceRT = nan(nRows,1); % choice response latency
        data.choice = nan(nRows,1); % participant's selection: 1 = easy, 2 = hard
        data.easyTask = trlArray(:,1); % easy task
        data.hardTask = trlArray(:,2); % hard task
        data.adjDel = ones(nRows,1); % task being discounted (set after first choice for each hardTask) 1 = easy 2 = hard
        data.adjAmt = trlArray(:,6); % absolute value of amount adjustment pursuant to choice on current trial
        data.prox = trlArray(:,4); % proximity to indifference point
        data.amt = trlArray(:,3); % base (undiscounted) offer amount
        data.times=[];
        data.labels={};
        data.drift_shift=[]; % amount of drift correction
        
        % set amnounts to base offer for hard tasks and half the base
        % for easy tasks for first trial in each task-base offer pair
        data.ssOffer = (trlArray(:,3).*(trlArray(:,5)==1))/2; % offer amount for easy task
        data.llOffer = trlArray(:,3).*(trlArray(:,5)==1); % offer amount for hard task
    end
    
    % experiment starts
    [id, dataFileName] = getSubjectInfo(prac);
    HideCursor;
    ListenChar(2);
    Priority(1);
        
    % log general subject and session info
    dataHeader.randSeed = randSeed;
    dataHeader.sessionTime = fix(clock);
    dataHeader.subjectID = id;
    dataHeader.dataName = dataFileName;
    
    % open an onscreen window
    [pms.wid, pms.wRect] = Screen('OpenWindow',pms.mon,[pms.bkgd*ones(1,3), 255],[],[],[],[]); % 0 0 640 480
    if strcmp(prac,'g') %if in eye tracking mode
        load(dataFileName)
        EyelinkInitDefaults(pms.wid);
    elseif strcmp(prac,'p')
        EyelinkInitDefaults(pms.wid);    
    end

    % Center of offer rects from upper left -> upper right -> ll -> lr
    pms.rectCtrsx = [floor(pms.wRect(3)/4),floor(pms.wRect(3)*3/4),floor(pms.wRect(3)/4),floor(pms.wRect(3)*3/4)];
    pms.rectCtrsy = [floor(pms.wRect(4)/4),floor(pms.wRect(4)/4),floor(pms.wRect(4)*3/4),floor(pms.wRect(4)*3/4)];
    pms.ifi = Screen('GetFlipInterval', pms.wid);
    Screen('BlendFunction',pms.wid,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    
    trial_start = 1;
    trial_end = size(calArray,1);
    if strcmp(prac,'p') % practice mode
        displayMessage('Remember the a, e, i, and u memory tasks?','Press 1 or 2 to continue.','12',pms);
        displayMessage('Now you will practice making a series of decisions about these tasks.','Press the 1 or 2 to continue.','12',pms);
        %For me it worked when I turned the whole string that I added in DrawText into double. For example:
        %money=2;
        %msgHard = double(sprintf('for ?%.2f',money));
        %Screen('DrawText',wPtr, msgHard)
        displayMessage('Two options will be shown, each with Eur. 0 and a task. Please pick the more demanding task.','Press 1 or 2 to continue.','12',pms);
        displayMessage('If the more demanding task is on the left, press 1, or press 2 if it is on the right.','Press 1 or 2 to continue.','12',pms);
        displayMessage('During this practice round, we will track your gaze.','Press 1 or 2 to continue.','12',pms);
        displayMessage('At the start of each trial, a plus sign will be displayed, and you have to fixate on it for 1 second to see the options.','Press 1 or 2 to continue.','12',pms);
        displayMessage('If you stare at the plus sign for much more than 1 second and the trial does not start, press the space bar, and the plus will turn green to indicate that re-calibration is needed.','Press 1 or 2 to continue.','12',pms);
        displayMessage('If you press the space bar, keep your eyes locked on the plus until it turns white again, indicating that it has been re-calibrated.','Press 1 or 2 to continue.','12',pms);
        displayMessage('Please take a moment to tell your Experimenter what is going to happen in this part of the task.','','s',pms);
        displayMessage('Practice begins now. For each trial, fixate on the plus for 1 second, then indicate which task is more demanding.','Press 1 or 2 to continue.','12',pms);
    elseif strcmp(prac,'c') % calibration mode (indifference titration)
        % decision trial start message
        displayMessage('Now, you will be asked to choose between repeating either the a, e, i, or u memory task up to 10 more times, and paid for each time you repeat it.','Press 1 or 2 to continue.','12',pms);
        displayMessage('We will now let you choose between different tasks for different amounts of money.','Press 1 or 2 to continue.','12',pms);
        displayMessage('We will select from among all your choices at random so that every choice could determine what task you do and what you are paid.','Press 1 or 2 to continue.','12',pms);
        displayMessage('You would be paid for every time you repeat a task and maintain your effort from previous sessions. It does not matter how well you do, as long as you maintain your effort.','Press 1 or 2 to continue.','12',pms);
        displayMessage('In this round, we will not track your gaze while you decide. Decision trials will start without requiring a fixation.','Press 1 or 2 to continue.','12',pms);
        displayMessage('Also, decisions are self-paced, so take your time and decide carefully. However, trials timeout after 9 seconds.','Press 1 or 2 to continue.','12',pms);
        displayMessage('Please take a moment to tell your Experimenter what is going to happen in this part of the task.','','s',pms);
        displayMessage('Decisions begin now. Take your time and decide carefully which task you would rather do based on the amounts offered.','Press 1 or 2 to continue.','12',pms);
    elseif strcmp(prac,'g') % gaze trials after calibration
        displayMessage('Once again, one of your choices will be selected at random and you will be required to complete that task for the associated amount.','Press 1 or 2 to continue.','12',pms);
        displayMessage('As in practice, we will track your gaze in this round: a plus sign will be displayed, and you have to fixate on it for 1 second for the trial to start.','Press 1 or 2 to continue.','12',pms);
        displayMessage('Decisions begin now. For each trial, fixate on the plus for 1 second, then decide carefully which offer you prefer.','Press 1 or 2 to continue.','12',pms);
        trial_start = find(data.choice>0,1,'last') + 1;
        run_len = size(regArray,1) / 3; % total number of gaze trials / 5 (36 for 180) /3 (60 for 180)
        trial_end = find(data.choice>0,1,'last') + run_len;
    end
    
    % baseline for event onset timestamps
    exptOnset = GetSecs;
    
    % run begins
    WaitSecs(1); % initial interval (blank screen)
    data.times(end+1)=GetSecs-exptOnset; 
    data.labels{end+1}='Run Start';
    
    if (strcmp(prac,'g') || strcmp(prac,'p')) % set up Eyelink at start of block
        pms.el = EyelinkSetup(1,pms);
        Eyelink('StartRecording')
    end
    
    for trial = trial_start:trial_end
        easyTask = trlArray(trial,1); % set sooner delay
        hardTask = trlArray(trial,2); % set later delay
        adjDel = 1;%.adjDel(trial); % set task being discounted (in task-amount pair)
        amt = trlArray(trial,3); % set base offer amount
        decNum = trlArray(trial,5); % set decision number (for task-amount pair)
        if adjDel == 1
            offerAmt = data.ssOffer(trial);
        else
            offerAmt = data.llOffer(trial);
        end
        
          % display all task labels in order of difficulty
        if any(pms.dispTasks==trial) || (trial_start==trial)
            data.times(end+1)=GetSecs-exptOnset;
            data.labels{end+1}='Display Delays';
            dispTasks(pms)
        end
        
        % show the offers and collect a response (1=easy, 2=hard, 9=too slow)
        [resp, onLeft, onset, RT, onTop, eyetrack] = showDmTrial(trial,adjDel,offerAmt,exptOnset,pms,data,prac);
        
        if decNum <= pms.nCalTrials % if a calibration trial
            
            while resp == 9 % too slow
                % show the offers again
                [resp, onLeft, onset, RT, onTop, eyetrack] = showDmTrial(trial,adjDel,offerAmt,exptOnset,pms,data,prac);
            end
            
            % set amount adjustment depending on response
            if adjDel == resp % if the task being discounted is selected
                data.adjAmt(trial) = -1*data.adjAmt(trial); % -1*calAdj(decNum,amt);
%             else % if not
%                 data.adjAmt(trial) = calAdj(decNum,amt);
            end
            
            % set next offer amount (search next calibration row in
            % trlArray matching on task, base amount, and next trial number)
            offerIdx = find(((trlArray(:,1)==easyTask) + (trlArray(:,2)==hardTask) + (trlArray(:,3)==amt) + (trlArray(:,5)==decNum+1))==4);
            if adjDel == 1 && decNum < pms.nCalTrials
                data.ssOffer(offerIdx) = data.adjAmt(trial) + offerAmt;
                data.llOffer(offerIdx) = amt;
            elseif adjDel == 2 && decNum < pms.nCalTrials
                data.ssOffer(offerIdx) = amt;
                data.llOffer(offerIdx) = data.adjAmt(trial) + offerAmt;
            elseif decNum == pms.nCalTrials % if on the final calibration trial
                % set the indifference SV and assign to subsequent trials
                % based on proximity
                indiff = data.adjAmt(trial) + offerAmt;
                trlmax = max(trlArray(trlArray(:,1)==easyTask & trlArray(:,2)==hardTask & trlArray(:,3)==amt,5));
                % set subsequent offer amounts
                for kk = (pms.nCalTrials+1):trlmax % for all non-calibration trials tskAmtTrlNm
                    offerIdx = find(((trlArray(:,1)==easyTask) + (trlArray(:,2)==hardTask) + (trlArray(:,3)==amt) + (trlArray(:,5)==kk))==4);
                    % for task-amount pair: smallOffer = (amount - indifference SV) * proximity + indifference SV
                    if trlArray(offerIdx,4) > 0
                        smallOffer = (amt - indiff) * trlArray(offerIdx,4) + indiff;
                    else
                        smallOffer = indiff * trlArray(offerIdx,4) + indiff;
                    end
                    
                    if adjDel == 1
                        data.ssOffer(offerIdx) = smallOffer;
                        data.llOffer(offerIdx) = amt;
                    else
                        data.ssOffer(offerIdx) = amt;
                        data.llOffer(offerIdx) = smallOffer;
                    end
                end
            end
        end
        gazedata(trial) = eyetrack; % save all eyetracker data here
        pms.driftShift = eyetrack.driftShift; % update for next trial
        data.ssPos(trial) = onLeft; % 1 for left, 2 for right
        data.aaTop(trial) = onTop; % 1 for top, 2 for bottom
        data.choiceOnset(trial) = onset;
        data.choiceRT(trial) = RT;
        data.choice(trial) = resp;
        
    end %trials in a run
         
    %save the data so far
    save(dataFileName,'data','gazedata','dataHeader','pms');
    
    % show a blank screen briefly at the end of the run
    Screen('FillRect',pms.wid,[pms.bkgd*ones(1,3),255]); % clear screen
    Screen(pms.wid,'Flip');
    if strcmp(prac,'p') || strcmp(prac,'g')
        Eyelink('Stoprecording')
        pms.el = EyelinkSetup(0,pms);
    end
    WaitSecs(1);
    
    % experimenter can press 's' to exit the final screen
    if nargin > 0 && strcmp(prac,'g') && trial == size(data.choice,1)
        trlidx = randi(trial_end);
        selChc = data.choice(trlidx);
        
        if selChc == 2
            task = pms.tasks{data.hardTask(trlidx)};
            amount = data.llOffer(trlidx);
        else
            task = pms.tasks{data.easyTask(trlidx)};
            amount = data.ssOffer(trlidx);
        end
        msg = sprintf('Based on your choices, you will redo the %s task for ?%2.2f.',task,amount)
        displayMessage(msg,'','s',pms)
        displayMessage('Task complete.','','s',pms)
    end
    
    % close-out tasks
    Screen('CloseAll');
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
catch ME
    disp(getReport(ME));
sca
keyboard
    
    % save data
    save(dataFileName,'data','dataHeader');
    
    % close-out tasks
    Screen('CloseAll'); % close screen
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
end %try-catch loop
end % main function



%%%%
% function to place a prompt or other message on the screen and wait until
% a response is made
function [resp, rt] = displayMessage(msg,submsg,keyresp,param)
% wid is the onscreen window
% msg is displayed in white at the center of the screen
% submsg is shown in smaller text below it (unless empty)a
% clears and returns upon receiving an acceptable response
%   keyresp is a string with acceptable keyboard responses
%   either may be set to 'any' if any response is acceptable
% this function does not write anything directly to the data record,
% but it returns the response given and the RT.

Screen('FillRect',param.wid,[param.bkgd*ones(1,3), 255]); %clear window

% main message
Screen('TextSize',param.wid,param.txtSize);
Screen('TextStyle',param.wid,0);
Screen('TextFont',param.wid,param.txtFont);
[~,ny] = DrawFormattedText(param.wid,msg,'center','center',param.textCol,param.wrptx,[],[],param.txtSpacing);

% sub message
if ~isempty(submsg)
    Screen('TextSize',param.wid,24);
    DrawFormattedText(param.wid,submsg,'center',ny+80,param.textCol,param.wrptx,[],[],param.txtSpacing);
end

% display
onset_stamp = Screen(param.wid,'Flip');

% mandatory delay
WaitSecs(1);

% collect response, checking keyboard
responded = 0;
while responded==0
    if ~isempty(keyresp) % check keyboard
        [keyIsDown, secs, keyCode] = KbCheck([param.keyboards]);
        if keyIsDown==1
            responseMatches = any(ismember(KbName(keyCode),keyresp));
            if strcmp(keyresp,'any') || responseMatches % if the response is allowable
                responded = 1;
                resp = KbName(keyCode);
                resp = str2num(resp(ismember(resp,keyresp)));
                rt = secs - onset_stamp;
            end
        end
    end
    WaitSecs(.001);
end

% clear the screen
Screen('FillRect',param.wid,[param.bkgd*ones(1,3), 255]);
Screen('Flip',param.wid);

end



%%%%
% function to obtain subject identifying info
function [id, dataFileName] = getSubjectInfo(prac)
id = [];
if strcmp(prac,'c') || strcmp(prac,'g')
    while isempty(id)
        id = input('Subject ID:  ','s');
    end
    session = [];
    while isempty(session)
        session = input('Session number:  ');
    end
    dataFileName = sprintf('COGED_s%s_%d.mat',id,session);
    % load existing file if in fMRI segment, create new file for
    % calibration
    % increase the session number if finding previous data for the same subject
    while exist(dataFileName,'file')==2 && strcmp(prac,'c')
        session = 1 + session;
        dataFileName = sprintf('COGED_s%s_%d.mat',id,session);
    end
    input(['Data will be saved in ', dataFileName, ' (ENTER to continue)  ']);
else
    % in practice mode use dummy values
    dataFileName = 'pracData';
end
end



%%%%
% function to display all the tasks on which the subject is deciding
function [] = dispTasks(param)
Screen('FillRect',param.wid,[param.bkgd*ones(1,3), 255]); %clear window

allTasks = param.tasks;
numtasks = length(allTasks);
% fractions evenly dividing the screen rectangle (plus 6 for 3 blank rows at
% top and bottom)
frac = param.wRect(4)/(numtasks+6); 

Screen('TextSize',param.wid,param.txtSize);
DrawFormattedText(param.wid,'All memory tasks:','center',frac*2,param.textCol)
for i = 1:numtasks
    DrawFormattedText(param.wid,allTasks{i},'center',frac*(i+3),param.textCol)
end
Screen('Flip',param.wid);
%display automatically expires after some time
WaitSecs(5);
end


%%%%
% function to show paired offers and collect a response
% this is used both in the practice session and the main experiment
% digit responses are self-paced
% accuracy feedback will be shown iff fbackLoc is provided
function [resp,onLeft,choiceOnset,choiceRT,onTop,itrack] = showDmTrial(trial,adjDel,offerAmt,exptOnset,param,datum,prac)

%%%% setup at the beginning of a trial
Screen('TextSize',param.wid,param.txtSize);
Screen('TextFont',param.wid,param.txtFont);
Screen('TextStyle',param.wid,0);
driftShift = param.driftShift;

% Ensure central fixation before showing trial
if strcmp(prac,'g') || strcmp(prac,'p')
    Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
    DrawFormattedText(param.wid,'+','center','center',param.textCol);
    vbl = Screen('Flip',param.wid); % Flip and get timestamp
    waitframes = 1;
    
    fixOn = 0; % continuous amount of time spent fixating on cross
    doDrift = 0; % to break out of both loops
    fixrect = CenterRectOnPointd([-1, -1, 1, 1]*param.ground/2,param.wRect(3)/2,param.wRect(4)/2);
    
    while fixOn < param.fixDuration
        sample = getEyelinkData();
        
        while doDrift % drift correction
            [~, ~, keyCode] = KbCheck([param.keyboards]);
            if strcmp(param.allowedResps.driftOK,KbName(keyCode));
                sample = getEyelinkData();
                driftShift = [(param.wRect(3)/2)-sample(1),(param.wRect(4)/2)-sample(2)]; %[x,y]
                %report = '***** Drift adjusted! *****';
                %report = sprintf('x = %0.2f, y = %0.2f',driftShift(1),driftShift(2));
                doDrift = 0;
                Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
                DrawFormattedText(param.wid,'+','center','center',param.textCol); % change its color back to background text color
                Screen('Flip',param.wid);
            end
        end
        
        time1 = GetSecs();
        while ((sample(1)+driftShift(1))-param.wRect(3)/2)^2+((sample(2)+driftShift(2))-param.wRect(4)/2)^2 < param.diagTol^2 && fixOn < param.fixDuration %IsInRect(sample(1),sample(2),fixrect)
            sample = getEyelinkData();
            time2 = GetSecs();
            fixOn = time2 - time1;
        end
        
        % if not yet met the timelimit and gaze outside target circle
        [~, ~, keyCode] = KbCheck([param.keyboards]);
        if strcmp(param.allowedResps.drift,KbName(keyCode));
            %report = '***** The participant indicates drift! *****'
            doDrift = 1;
            Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
            DrawFormattedText(param.wid,'+','center','center',param.driftCueCol); % change its color
            Screen('Flip',param.wid);
        end
    end
end

for j = 1:4 % make rectangles for each stimulus
    rects(j,:) = CenterRectOnPointd([-1, -1, 1, 1]*param.ground/2, param.rectCtrsx(j),param.rectCtrsy(j));
end

easyTask = datum.easyTask(trial);
hardTask = datum.hardTask(trial);

% draw each offer onto its texture
ssT = sprintf('%s',param.tasks{easyTask});
llT = sprintf('%s',param.tasks{hardTask});
if adjDel == 1 % determine which task is being discounting
    ssA = sprintf('?%.2f',offerAmt);
    llA = sprintf('?%.2f',datum.amt(trial));
else
    ssA = sprintf('?%.2f',datum.amt(trial));
    llA = sprintf('?%.2f',offerAmt);
end

whichOrder = randi([1,4],1); % Positioning matrix
rectMat = [1,3,2,4; 2,4,1,3; 3,1,4,2; 4,2,3,1];
ordMat = [1,1; 1,2; 2,1; 2,2];
onTop = ordMat(whichOrder,1); % 1 for amounts and 2 for tasks on top
onLeft = ordMat(whichOrder,2); % 1 for ss and 2 for ll

Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
DrawFormattedText(param.wid,ssA,'center','center',param.textCol,[],[],[],[],[],rects(rectMat(whichOrder,1),:));
DrawFormattedText(param.wid,ssT,'center','center',param.textCol,[],[],[],[],[],rects(rectMat(whichOrder,2),:));
DrawFormattedText(param.wid,llA,'center','center',param.textCol,[],[],[],[],[],rects(rectMat(whichOrder,3),:));
DrawFormattedText(param.wid,llT,'center','center',param.textCol,[],[],[],[],[],rects(rectMat(whichOrder,4),:));
% add line to separate left and right halves of the screen
Screen('DrawLine',param.wid,param.textCol,param.wRect(3)/2,param.wRect(4)/3,param.wRect(3)/2,param.wRect(4)*2/3,1);

% display the offers
offerOnset = Screen('Flip',param.wid,[],1);
choiceOnset = offerOnset-exptOnset;
%WaitSecs(.1);

responded = [];
itrack.driftShift = driftShift;
itrack.X = [];
itrack.Y = [];
itrack.Xdrift = [];
itrack.Ydrift = [];
itrack.pSize = [];
itrack.sampleTimes = [];
sampleTime = offerOnset;
while isempty(responded) && (GetSecs() - offerOnset) < param.chcDuration
    if (strcmp(prac,'g') || strcmp(prac,'p')) && (GetSecs() - sampleTime) >= 0.002
        sample = getEyelinkData();
        x = sample(1); y = sample(2); %get the x and y coordinates of the current eye trace
        p = sample(3); st = sample(4);
        sampleTime = GetSecs();
        itrack.X=[itrack.X;x]; itrack.Y=[itrack.Y;y]; itrack.Xdrift=[itrack.Xdrift;x+driftShift(1)]; itrack.Ydrift=[itrack.Ydrift;y+driftShift(2)]; itrack.pSize=[itrack.pSize;p]; itrack.sampleTimes=[itrack.sampleTimes;st,sampleTime-offerOnset];
    end
    
    % check keyboard and CMU box
    [keyIsDown, ~, keyCode] = KbCheck([param.keyboards]);
 
    if keyIsDown==1
        % a response has just occurred
        key = KbName(keyCode);
        if any(ismember(key,[param.allowedResps.left, param.allowedResps.right]))
            % response was allowable
            responded = 1;
            respTimeStamp = GetSecs;
            choiceRT = respTimeStamp-offerOnset;
            if any(ismember(key,[param.allowedResps.left])) && onLeft==1;
                % left key was pressed and easy choice was on left
                resp = 1;
                respRect = [rects(1,1:2),rects(3,3:4)]+[-param.ground/5,0,param.ground/5,0];
            elseif any(ismember(key,[param.allowedResps.left])) && onLeft==2;
                % left key was pressed and easy choice was on right
                resp = 2;
                respRect = [rects(1,1:2),rects(3,3:4)]+[-param.ground/5,0,param.ground/5,0];
            elseif any(ismember(key,[param.allowedResps.right])) && onLeft==1;
                resp = 2;
                respRect = [rects(2,1:2),rects(4,3:4)]+[-param.ground/5,0,param.ground/5,0];
            else
                resp = 1;
                respRect = [rects(2,1:2),rects(4,3:4)]+[-param.ground/5,0,param.ground/5,0];
            end
        end
    end
    buffer = param.trlDuration - (GetSecs - offerOnset) - .75;
    WaitSecs(.001);
end

% check to see if participant is too slow
if isempty(responded);
    resp = 9;
    choiceRT = 0;
    Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
    DrawFormattedText(param.wid,'Too slow!','center','center',param.textCol);
    buffer = param.trlDuration - param.chcDuration - .75;
% feedback verifying participant's response
else
    Screen('FrameRect',param.wid,param.selCol,respRect,4);
end
Screen('Flip',param.wid);
WaitSecs(0.5);

% clear the screen
Screen('FillRect',param.wid,[param.bkgd*ones(1,3),255]);
Screen('Flip',param.wid);

showITI(buffer,param);

end



%%%%
% function for the inter-trial interval
function [] = showITI(buffer,param) 

WaitSecs(buffer);

keyIsDown = 1;
while keyIsDown;
    keyIsDown= KbCheck([param.keyboards]);
    WaitSecs(.001);
end
            
end


