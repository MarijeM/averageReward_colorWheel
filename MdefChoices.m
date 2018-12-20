function [data,pms]=MdefChoices(pms)
%This function defines the trial setup of the choice task
    
%% define trialstructure

if pms.practice==0
  % unpermutted low reward context array and high reward contect array of all task combination pairs with columns 1) easy task, 2) hard task, 3) amount
    UIArray = []; %update/ignore array
    NRArray = []; %redo/noRedo array
    UIArray = [repmat(cell2mat(pms.EasyTaskPairs{1})',pms.nCalTrials,1),... % easy task
               repmat(cell2mat(pms.HardTaskPairs{1})',pms.nCalTrials,1),... % hard task
               repmat(repmat(pms.amts,length(pms.HardTaskPairs{1}),1),pms.nCalTrials,1),...; % amount
               ones(length(pms.HardTaskPairs{1})*pms.nCalTrials,1)]; % proximity
    NRArray = [repmat(cell2mat(pms.EasyTaskPairs{2})',length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % easy task
               repmat(cell2mat(pms.HardTaskPairs{2})',pms.nCalTrials,1),... % hard task
               repmat(repmat(pms.amts,length(pms.HardTaskPairs{2}),1),pms.nCalTrials,1),... % amount
               ones(length(pms.HardTaskPairs{2})*pms.nCalTrials,1)]; % proximity
           
%    UIArray = [repmat(cell2mat(pms.taskPairs{1})',pms.nCalTrials,1),... % easy task
%                repmat(cell2mat(pms.taskPairs{2})',pms.nCalTrials,1),... % hard task
%                repmat(repmat(pms.amts,length(pms.taskPairs{1}),1),pms.nCalTrials,1)]; % amount
%    NRArray = [repmat(cell2mat(pms.taskPairsNR{1})',length(pms.taskPairsNR{2})*pms.nCalTrials,1),... % easy task
%                repmat(cell2mat(pms.taskPairsNR{2})',pms.nCalTrials,1),... % hard task
%                repmat(repmat(pms.amts,length(pms.taskPairsNR{2}),1),pms.nCalTrials,1)]; % amount

  % combine and randomise update/ignore trials with redo/noRedo trials        
    combinedArray = [UIArray;NRArray];
     
  % randimise trials over 4 blocks
  trlArray = struct();
  for i = 1:pms.numBlocks
    trlArray.block{i} = combinedArray(randperm(size(combinedArray,1)),:);
  end
  
 %   trlArray{1} = combinedArray(randperm(size(trlArray,1)),:);
 %   trlArray{2} = combinedArray(randperm(size(trlArray,1)),:);
 %   trlArray{3} = combinedArray(randperm(size(trlArray,1)),:);
 %   trlArray{4} = combinedArray(randperm(size(trlArray,1)),:);
    
  % add trial number by short and long delays and amounts
  for i = 1:pms.numBlocks
     trlArray.block{i}(:,5)=0;
     ctr = zeros((length(pms.EasyTaskPairs{1})+length(pms.EasyTaskPairs{2})),length(pms.HardTaskPairs{1}),length(pms.amts));
     for jj = 1:size(trlArray.block{i},1)
         amtidx = find(pms.amts==trlArray.block{i}(jj,3));
         ctr(trlArray.block{i}(jj,1),trlArray.block{i}(jj,2),amtidx) = ctr(trlArray.block{i}(jj,1),trlArray.block{i}(jj,2),amtidx) + 1;
         trlArray.block{i}(jj,5) = ctr(trlArray.block{i}(jj,1),trlArray.block{i}(jj,2),amtidx);
     end  
  
 %   trlArray(:,5) = 0;
 %   trlArray(:,5) = 0;
 %   ctr = zeros(length(pms.taskPairs{1}),length(pms.taskPairs{2}),length(pms.amts));
 %   for jj = 1:size(trlArray,1)
 %       amtidx = find(pms.amts==trlArray(jj,3));
 %       ctr(trlArray(jj,1),trlArray(jj,2),amtidx) = ctr(trlArray(jj,1),trlArray(jj,2),amtidx) + 1;
 %       trlArray(jj,5) = ctr(trlArray(jj,1),trlArray(jj,2),amtidx);
 %   end  

  % compute indices for randomly permutted order of trials for every block
    %randInd1 = randperm(size(trlArray,1));  
    %randInd2 = randperm(size(trlArray,1));
    %randInd3 = randperm(size(trlArray,1));
    %randInd4 = randperm(size(trlArray,1)); 
   
  % creating randomised blocks
    %trlArray = [trlArray(randInd1,:);trlArray(randInd2,:);trlArray(randInd3,:);trlArray(randInd4,:)];
 
  % add absolute value of amount adjustment
    trlArray.block{i}(:,6) = 0; 
    trlArray.block{i}(1:size(trlArray.block{i},1),6) = trlArray.block{i}(1:size(trlArray.block{i},1),3) ./ (2.^(trlArray.block{i}(1:size(trlArray.block{i},1),5)+1));
       
  % add block number
    trlArray.block{i}(:,7) = 0;            
    trlArray.block{i}(:,7) = [ones(size(trlArray.block{i},1),1)*i];

  % add context, 0=Low 1=High
    trlArray.block{i}(:,8) = 0;
    if pms.blockCB==0 %low context first
        if i==1 || i==4
            trlArray.block{i}(:,8) = 0;  %low context
        elseif i==2 || i==3
            trlArray.block{i}(:,8) = 1;  %high context
        end
    elseif pms.blockCB==1 %high context first
        if i==1 || i==4
            trlArray.block{i}(:,8) = 1;  %high context
        elseif i==2 || i==3
            trlArray.block{i}(:,8) = 0;  %low context
        end
    end
    
%    for i=1:size(trlArray,1)
%         if trlArray(i,7)==1 || trlArray(i,7)==4
%             if pms.blockCB==0
%                 trlArray(i,8) = 0; %low context
%             elseif pms.blockCB==1 
%                 trlArray(i,8) = 1; %high context
%             end
%         elseif trlArray(i,7)==2 || trlArray(i,7)==3
%             if pms.blockCB==0
%                 trlArray(i,8) = 1; %high context
%             elseif pms.blockCB==1 
%                 trlArray(i,8) = 0; %low context
%             end
%         end
%    end


  % add task condition: 1=update/ignore, 2=redo/noRedo
    trlArray.block{i}(:,9) = 0;
    for j = 1:size(trlArray.block{i},1)
        if trlArray.block{i}(j,1)==5
            trlArray.block{i}(j,9) = 2; %redo/noRedo trial
        else
            trlArray.block{i}(j,9) = 1; %update/ignore trial
        end
    end

 
  end % first for i = 1:pms.numBlocks
                 
% practice trials
elseif pms.practice==1  %if pms.practice==0  M: CHECK last columns!!!!!
    trlArray = struct();
    UIArray = [];
    NRArray = [];
    contextVec = [1;2];
    UIArray = [repmat(cell2mat(pms.EasyTaskPairs{1})',length(pms.amts)*pms.nCalTrials,1),... % easy task
                repmat(cell2mat(pms.HardTaskPairs{1})',length(pms.amts)*pms.nCalTrials,1),... % hard task
                repmat(pms.amts,length(pms.EasyTaskPairs{1})*pms.nCalTrials,1),... % amounts
                ones(length(pms.EasyTaskPairs{1})*pms.nCalTrials,1),... % proximity
                ones(length(pms.EasyTaskPairs{1})*pms.nCalTrials,1),... % trial number
                rand(length(pms.EasyTaskPairs{1})*pms.nCalTrials,1),... % amount adjustment
                ones(length(pms.EasyTaskPairs{1})*pms.nCalTrials,1),... % block number
                repmat(contextVec,2*pms.nCalTrials,1),...               % context
                repmat(1,length(pms.EasyTaskPairs{1})*pms.nCalTrials,1)]; % task condition
    NRArray = [repmat(cell2mat(pms.EasyTaskPairs{2})',length(pms.amts)*pms.nCalTrials*length(pms.HardTaskPairs{2}),1),... % easy task
                repmat(cell2mat(pms.HardTaskPairs{2})',length(pms.amts)*pms.nCalTrials,1),... % hard task
                repmat(pms.amts,length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % amounts
                ones(length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % proximity
                ones(length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % trial number
                rand(length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % amount adjustment
                ones(length(pms.HardTaskPairs{2})*pms.nCalTrials,1),... % block number
                repmat(contextVec,2*pms.nCalTrials,1),...               % context
                repmat(2,length(pms.EasyTaskPairs{1})*pms.nCalTrials,1)]; % task condition
   
   % combine and randomise update/ignore trials with redo/noRedo trials        
     combinedArray = [UIArray;NRArray];
     
   % randimise trials over 4 blocks
     trlArray = struct();
     for i = 1:pms.numBlocks
       trlArray.block{i} = combinedArray(randperm(size(combinedArray,1)),:);
     end    
    
end  %if pms.practice==0

pms.trlArray = trlArray;
nRows = size(trlArray.block{1},1);
    
%% set up data
% prepare data structure
data = struct();
for i = 1:pms.numBlocks
data.block{i}.trialNumber = (1:nRows)';
data.block{i}.tskAmtTrlNm = trlArray.block{i}(:,5); % trial number for each task-amount pair
data.block{i}.ssPos = nan(nRows,1); % position of the easy option 1 = left, 2 = right
data.block{i}.aaTop = nan(nRows,1); % position of amounts 1 = top, 2 = bottom
data.block{i}.choiceOnset = nan(nRows,1); % onset timestamp
data.block{i}.choiceRT = nan(nRows,1); % choice response latency
data.block{i}.choice = nan(nRows,1); % participant's selection: 1 = easy, 2 = hard
data.block{i}.easyTask = trlArray.block{i}(:,1); % easy task
data.block{i}.hardTask = trlArray.block{i}(:,2); % hard task
data.block{i}.adjDel = ones(nRows,1); % task being discounted (set after first choice for each hardTask) 1 = easy 2 = hard
data.block{i}.adjAmt = trlArray.block{i}(:,6); % absolute value of amount adjustment pursuant to choice on current trial
data.block{i}.amt = trlArray.block{i}(:,3); % base (undiscounted) offer amount
data.block{i}.times=[];
data.block{i}.labels={};
% set amnounts to base offer for hard tasks and half the base
% for easy tasks for first trial in each task-base offer pair
if pms.practice==1
    data.block{i}.ssOffer = (trlArray.block{i}(:,3).*(trlArray.block{i}(:,5)==1))/2; % offer amount for easy task
elseif pms.practice==0
    data.block{i}.ssOffer = (trlArray.block{i}(:,3).*(trlArray.block{i}(:,5)==1)); % offer amount for easy task
end
data.block{i}.llOffer = trlArray.block{i}(:,3).*(trlArray.block{i}(:,5)==1); % offer amount for hard task
data.block{i}.easyOffer = data.block{i}.ssOffer;
data.block{i}.hardOffer = data.block{i}.llOffer;
data.block{i}.block = trlArray.block{i}(:,7);
data.block{i}.context = trlArray.block{i}(:,8);
data.block{i}.taskCondition = trlArray.block{i}(:,9);

for j = 1:nRows
    switch data.block{i}.easyTask(j)
        case {1 3} %setsize 1
            data.block{i}.setsizeEasy(j) = 1;
        case {2 4}  %setsize 3 
            data.block{i}.setsizeEasy(j) = 3;
    end
    switch data.block{i}.easyTask(j)
        case {1 2} %all UPDATE
            data.block{i}.conditionEasy(j) = 2;
        case {3 4} %all IGNORE
            data.block{i}.conditionEasy(j) = 0;
    end
end

for j = 1:nRows
    switch data.block{i}.hardTask(j)
        case {1 3} %setsize 1
            data.block{i}.setsizeHard(j) = 1;
        case {2 4}  %setsize 3 
            data.block{i}.setsizeHard(j) = 3;
    end
    switch data.block{i}.hardTask(j)
        case {1 2} %all UPDATE
            data.block{i}.conditionHard(j) = 2;
        case {3 4} %all IGNORE
            data.block{i}.conditionHard(j) = 0;
    end
end

end % second for i = 1:pms.numBlocks

end %function




