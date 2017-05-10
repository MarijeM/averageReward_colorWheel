function [data]=defChoicesFixed(pms)
%This function defines the trial setup of the choice task
%%version 1: all vs no redo
% version 2: direct comparison
% random=1 all blocks differ per participant
% random=0 blocks have same pairs per participant but in different order
%% 1) Define trialstructure:

if pms.practice == 1
    pms.numPairs1 = pms.numPairs1Prac;
    pms.numChoices1=pms.numChoices1Prac;
    pms.easyOffer1=pms.easyOffer1Prac;
    pms.reps=pms.repsPrac;
    pms.numChoices=pms.numChoicesPrac;
    pms.numBlocks=pms.numBlocksPrac;
end

    version1=ones(pms.numChoices1/pms.numBlocks,1); %no redo
    if pms.practice == 0
        typeVector1=repmat(pms.typeTask1,pms.numPairs1*pms.reps/pms.numBlocks,1);typeVector1=typeVector1(:);
    elseif pms.practice ==1 %adjusted vector for practice, since we only want 4 practice trials.
        typeVector1=[1 8 3 6]';
    end 
    easyOffer1=repmat(pms.easyOffer1', pms.numChoices1/(pms.numBlocks*pms.numPairs1),1);
    hardOffer1=repmat(2, pms.numChoices1/pms.numBlocks,1);
    locationEasy1=repmat([1,2]',length(easyOffer1)/2,1);
    trlArray1=[version1 typeVector1 easyOffer1 hardOffer1 locationEasy1]; 
            
%% this is when we want to counterbalance cells per block, not per repetition,         
% for n=1:length(pms.typeTask1)
%     block1(n,:)=Shuffle(repmat(1:pms.numBlocks,1,pms.numChoices1/(pms.numBlocks*length(pms.typeTask1))));
% end
% 
% for n=1:length(pms.typeTask2)
%     block2(n,:)=Shuffle(repmat(1:pms.numBlocks,1,pms.numChoices2/(pms.numBlocks*length(pms.typeTask2))));
% end
% 
% block1=block1';block1=block1(:); block2=block2';block2=block2(:);
%     
%     trlArray=[trlArray1 block1;trlArray2 block2];
%     trlArray=sortrows(trlArray,6);
%% blocking per repetition
       
    trlArray=trlArray1;   
 %% this is when we want to counterbalance cells per block, not per repetition,         
   
%     b1=trlArray(trlArray(:,6)==1,:);b1=b1(randperm(length(b1))',:);
%     b2=trlArray(trlArray(:,6)==2,:);b2=b2(randperm(length(b2))',:);
%     b3=trlArray(trlArray(:,6)==3,:);b3=b3(randperm(length(b3))',:);
%     trlArray=[b1;b2;b3];
%% blocking per repetition if we have 3 blocks
if pms.practice==0
    b1=[trlArray ones(length(trlArray),1)];b1=b1(randperm(length(b1))',:);
    b2=[trlArray 2*ones(length(trlArray),1)];b2=b2(randperm(length(b2))',:);
    b3=[trlArray 3*ones(length(trlArray),1)];b3=b3(randperm(length(b3))',:);
    trlArray=[b1;b2;b3];
elseif pms.practice==1
    trlArray(:,6)=trlArray(:,1); %2 blocks based on versions. version 1 one block, version 2 another
    trlArray=sortrows(trlArray,-6);
end
%% set up data
% prepare data structure
data.trialNumber = (1:pms.numChoices)';
data.block = trlArray(:,6);
data.version = trlArray(:,1); % trial number for each task-amount pair
data.choiceOnset = nan(pms.numChoices,1); % onset timestamp
data.choiceRT = nan(pms.numChoices,1); % choice response latency
data.choice = nan(pms.numChoices,1); % participant's selection: 1 = easy, 2 = hard
data.typeTask = trlArray(:,2); % task being offered (versus the easy task)
data.easyOffer = trlArray(:,3); % proximity to indifference point
data.sz = nan(pms.numChoices,1);
data.condition = nan(pms.numChoices,1);
data.locationEasy = trlArray(:,5);
data.hardOffer = trlArray(:,4);
data.key=zeros(pms.numChoices,100);

for i = 1:pms.numChoices
    switch data.typeTask(i)
        case {1 5} %setsize 1 (versus No redo)
            data.sz(i) =1;
        case {2 6} %setsize 2(versus No redo)
            data.sz(i) =2;
        case {3 7}  %setsize 3 (versus No redo)
            data.sz(i) =3;
        case {4 8}  %setsize 4 (versus No redo)
            data.sz(i)=4;
    end
    if data.version(i)==1
        switch data.typeTask(i)
            case {1 2 3 4} %all IGNORE
                data.condition(i) = 0;
            case {5 6 7 8} %all UPDATE
                data.condition(i) = 2;
        end
    end
end
end %function




