function [choiceSZ, choiceCondition, bonus]=Redo(pms,data)

%% choose by amount:
% randomChoice=randsample(data.trialNumber(data.choiceAmount==pms.redoAmount),1);
% bonus=pms.redoAmount

%% choose by set size, even/odd choice between sz 3 or 4

if ~isempty(find((data.sz==4 | data.sz==3) & data.choice==2))    % participant chose set size 3/4 at least once      
    randomChoice=randsample(data.trialNumber((data.sz==4 | data.sz==3) & data.choice==2) ,1); 
elseif ~isempty(find(data.sz==2 & data.choice==2))               % participant chose set size 2 at least once           
    randomChoice=randsample(data.trialNumber(data.sz==2 & data.choice==2) ,1); 
elseif ~isempty(find(data.sz==1 & data.choice==2))               % participant chose set size 1 at least once   
    randomChoice=randsample(data.trialNumber(data.sz==1 & data.choice==2) ,1); 
else                                                             %participant always chose No Redo
    randomChoice=randsample(data.trialNumber(data.choiceAmount'<=2 & data.choiceAmount'>=1) ,1); %can give an error when trying out the task: if you only choose no redo once for less than €1 and do not respond on the other trials...
end
            
% bonus=data.choiceAmount(randomChoice);
choiceSZ=data.sz(randomChoice);

switch data.version(randomChoice)
    case 1 %no redo
        switch data.typeTask(randomChoice)
            case {1 2 3 4} %all IGNORE
                choiceCondition = 0;
            case {5 6 7 8} %all UPDATE
                choiceCondition = 2;
        end
    case 2
        if data.choice(randomChoice)==1
            choiceCondition=2;
        elseif data.choice(randomChoice)==2
            choiceCondition=0;
        end
end


if data.choice(randomChoice)==1
    bonus=data.easyOffer(randomChoice);
elseif data.choice(randomChoice)==2
    bonus=data.hardOffer(randomChoice);
end
save(fullfile(pms.subdirCh,sprintf('sub%d bonus',pms.subNo)),'bonus')

% trialvector=[zeros(1,pms.redoTrials/(2*pms.redoCondi)), 2*ones(1,(pms.redoTrials/(2*pms.redoCondi)))];
% typechoice=repmat(choiceCondition,pms.redoTrials/2,1);
% trialvector=[trialvector typechoice'];
% 
% setsize = [1,2,3,4]';
% setsizevector = repmat(setsize,pms.redoTrials/(2*length(setsize)),1);
% setsizechoice=repmat(choiceSZ,pms.redoTrials/2,1);
% setsizevector=[setsizevector ;setsizechoice];
