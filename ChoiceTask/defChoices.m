function [data]=defChoices(pms)
%This function defines the trial setup of the choice task

%% 1) Define trialstructure: 
if pms.practice == 1
    pms.nCalTrials = pms.nCalTrials_prac;
    pms.Choices = pms.Choices_prac;
end
%assign value to task condition (1:3 IGN; 4:6 UPD)
trl_struct = repmat((1:length(pms.hardTask)*length(pms.Conditions))',pms.nCalTrials*length(pms.amts),1); % array of task labels for calibration trials: 1:3 IGN; 4:6 UPD

% only use 1 here
calTrlAmt = []; % unpermutted array of calibration trial amounts and absolute value of amount adjustments
for j = 1:length(pms.amts)
    tmp = repmat(j,length(pms.hardTask)*length(pms.Conditions),1);
    calTrlAmt = [calTrlAmt; tmp];
end
calTrlAmt = repmat(calTrlAmt,pms.nCalTrials,1);

% indices for random order of trials
randIndCal = randperm(pms.Choices);

trlArray = [trl_struct(randIndCal), calTrlAmt(randIndCal), ones(length(randIndCal),1)];
% add counter of condition (maximum of 12)
ctr = zeros(pms.Choices*length(pms.amts),1);
for j = 1:size(trlArray,1)
    ctr(trlArray(j,1)+length(pms.hardTask)*(trlArray(j,2)-1),1) = ctr(trlArray(j,1)+length(pms.hardTask)*(trlArray(j,2)-1),1) + 1;
    trlArray(j,4) = ctr(trlArray(j,1)+length(pms.hardTask)*(trlArray(j,2)-1),1); % count trial numbers
end

adjAmt = nan(pms.Choices,1);
adjAmt(:) = pms.amts.step;
% trlArray = [trlArray calAdjustment];

%randomize left right presentation of easy option: divide by two because should be equal for IG and UP (apply same indices to both later on)
locationEasy = randi(2,1,pms.Choices/2); %1 means left and 2 means right presentation of easy option

trlArray(trlArray(:,1)<4,5) = locationEasy; %apply index to IGNORE trials (<4)
trlArray(trlArray(:,1)>3, 5) = fliplr(locationEasy); %apply (reversed) indices to UPDATE trials (>3)
%% set up data
% prepare data structure
data.trialNumber = (1:pms.Choices)';
data.tskAmtTrlNm = trlArray(:,4); % trial number for each task-amount pair
data.choiceOnset = nan(pms.Choices,1); % onset timestamp
data.choiceRT = nan(pms.Choices,1); % choice response latency
data.choice = nan(pms.Choices,1); % participant's selection: 1 = easy, 2 = hard
data.hardTask = trlArray(:,1); % task being offered (versus the easy task)
data.adjEff = ones(pms.Choices,1); % task being discounted (set after first choice for each hardTask) 1 = easy 2 = hard
data.prox = pms.prox(trlArray(:,3))'; % proximity to indifference point
%data.amt = pms.amts(trlArray(:,2)); % base (undiscounted) offer amount
% data.adjAmtAbs = trlArray(:,5); %absolute value of change as a consequence of decision on the trial
data.adjAmt = adjAmt; % amount of offer adjustment pursuant to choice on current trial
data.sz = nan(pms.Choices,1);
data.condition = nan(pms.Choices,1);
data.locationEasy = trlArray(:,5);
% set anounts to base offer for hard tasks and half the base
% for easy tasks for first trial in each task-base offer pair

data.easyOffer = pms.amts.min.*(trlArray(:,4)==1); % offer amount for easy task first time
data.hardOffer = pms.amts.start.*(trlArray(:,4)==1); % offer amount for hard task

for i = 1:pms.Choices
    switch data.hardTask(i)
        case {1 4} %setsize 2 (versus 1)
            data.sz(i) =2;
        case {2 5} %setsize 3 (versus 1)
            data.sz(i) =3;
        case {3 6}  %setsize 4 (versus 1)
            data.sz(i) =4;
    end
        switch data.hardTask(i)
            case {1 2 3} %all IGNORE
                data.condition(i) = 0;
            case {4 5 6} %all UPDATE
                data.condition(i) = 22;
        end
end
end %function

                

 