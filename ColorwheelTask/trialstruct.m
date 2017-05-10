function[trial]=trialstruct(pms,rect,practice,varargin)
% adapt inputs to pms. (see Beautifulcolorwheel)

% function that creates a numTrials x numBlocks struct with 
% trial number,trial type (IG, NX,UP), rect locations and colors for encoding and
% update/ignore phases if required. 
% Number of colors is included as input so we can define how big a sample of colors we need from the 640 colors of the wheel


% Screen('Preference','SkipSyncTests',1);
% Screen('Preference', 'SuppressAllWarnings', 1);
% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));

% colormatrix=hsv(pms.numWheelColors)*255;       %MF: where define numColors? Maybe as input from main script? DP:It is already an input I think. This is the function that opens the figure
% colormatrix=sampledColorMatrix(pms,step);

if practice==0
    %       trialvector = [zeros(1,(pms.numTrials/pms.numCondi)), ones(1,pms.numTrials/pms.numCondi), 2*ones(1,(pms.numTrials/pms.numCondi)/2),22*ones(1,(pms.numTrials/pms.numCondi)/2)]'; %22 is a subtype of type 2(update) which has greater delay 2
    %         trialvector = [zeros(1,pms.numTrials/pms.numCondi), 2*ones(1,(pms.numTrials/pms.numCondi)/2),22*ones(1,(pms.numTrials/pms.numCondi)/2)]'; %22 is a subtype of type 2(update) which has greater delay 2
    trialvector=[zeros(1,pms.numTrials/pms.numCondi), 22*ones(1,(pms.numTrials/pms.numCondi))];
    blockmatrix = repmat(trialvector, 1,pms.numBlocks);
    
    setsize = [1,2,3,4]';
    % setrepeats=numTrials/length(setsize);
    setsizevector = repmat(setsize,pms.numTrials/length(setsize),pms.numBlocks); %MF: the size of this matrix is not right.. should be numTrials*numBlocks; this is too big.
    %DP: it works now but numTrials have to be divided both by 3 and 4  %MF: true, I think with higher trial numbers it would work, but not all elements were used here; just keep an eye on this :)
    %         timepoints=[1.25,1.5,1.75,2,2.25]';
    %timevector=repmat(timepoints,pms.numTrials/length(timepoints),pms.numBlocks);
    %         pies=[1:12]';
    %         piematrix=repmat(pies,pms.numTrials/length(pies),pms.numBlocks);
    
    %% 1) Get randomization idx output
    RandomIdx=[];       %Get randomization idx output
    for v = 1:pms.numBlocks
        RandomIdx(:,v)= randperm(pms.numTrials);
    end
    %% 2) Apply same RandomIdx to eg Blockmatrix, (but also setsize,...)
    
    typematrixFin =[pms.numTrials,pms.numBlocks];
    setsizevectorFin =[pms.numTrials,pms.numBlocks];
    %timematrixFin=[pms.numTrials,pms.numBlocks];
    %         piematrixFin=[pms.numTrials,pms.numBlocks];
    
    for y = 1:pms.numBlocks
        for x = 1:pms.numTrials
            typematrixFin(x,y) = blockmatrix(RandomIdx(x,y));
            setsizevectorFin(x,y) = setsizevector(RandomIdx(x,y));
            %timematrixFin(x,y)=timevector(RandomIdx(x,y));
            %           piematrixFin(x,y)= piematrix(RandomIdx(x,y));
            
        end
    end
    
    %DP:in the case of practice, the trials are not randomized and we may define maximum setsize in pms
elseif practice==1
    pms.numBlocks=pms.numBlocksPr;
    pms.numTrials=pms.numTrialsPr;
    setsizevector = [ones(1,(pms.numTrials/pms.maxSetsize)), 2*ones(1,pms.numTrials/pms.maxSetsize), 3*ones(1,pms.numTrials/pms.maxSetsize),pms.maxSetsize*ones(1,pms.numTrials/pms.maxSetsize)]';
    setsizevectorFin=repmat(setsizevector,1,pms.numBlocks);
    %         trialTypes=[0 1 2]';
    trialTypes=[0 2]';
    typematrixFin=repmat(trialTypes,pms.numTrials/length(trialTypes),pms.numBlocks);
    % timematrixFin=2*ones(pms.numTrials,pms.numBlocks);
    
elseif practice==2
    pms.numBlocks=pms.redoBlocks;
    pms.numTrials=pms.redoTrials;
   
    
%% for redo based on amount    
%     trialvector=[zeros(1,pms.redoTrials/(2*pms.redoCondi)), 2*ones(1,(pms.redoTrials/(2*pms.redoCondi)))];
%     typechoice=repmat(choiceCondition,pms.redoTrials/2,1);
%     typematrixFin=[trialvector typechoice'];
%     setsize = [1,2,3,4]';
%    setsizevector = repmat(setsize,pms.redoTrials/(2*length(setsize)),1);
%     setsizechoice=repmat(choiceSZ,pms.redoTrials/2,1);
%     setsizevectorFin=[setsizevector ;setsizechoice];     

%% for redo based on set size
    setsizevectorFin=repmat(pms.choiceSZ,pms.numTrials,1);
    switch pms.choiceCondition
        case 0
            otherCondition=2;
        case 2
            otherCondition=0;
    end
    typematrixFin=[repmat(pms.choiceCondition,2*pms.numTrials/3,1); repmat(otherCondition,pms.numTrials/3,1)];
    typematrixFin=[repmat(pms.choiceCondition,2*pms.numTrials/3,1); repmat(otherCondition,pms.numTrials/3,1)]; %e.g. [000000222]'

%% shuffle    
    randomIdx=randperm(pms.numTrials);
    typematrixFin=typematrixFin(randomIdx);setsizevectorFin=setsizevectorFin(randomIdx);
    setsizevectorFin=setsizevectorFin(randomIdx);
end

%% 3)make location matrix

rectsize=[0 0 100 100];
numrects=4;
%  xyindex=[0.4 0.6 0.6 0.41;0.35 0.37 0.6 0.6]';
xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]';

locationmatrix=zeros(size(xyindex,1),size(xyindex,2));
for r=1:length(locationmatrix)
    locationmatrix(r,1)=(rect(3)*xyindex(r,1));
    locationmatrix(r,2)=(rect(4)*xyindex(r,2));
end

%% 4)color matrix
%%%  Put into structure (for easy output of function)
trialsvector=(1:pms.numTrials)';
trialsmatrix=repmat(trialsvector,1,pms.numBlocks);

trial=struct();
for i=1:pms.numBlocks
    for t=1:pms.numTrials
        trial(t,i).number=trialsmatrix(t,i);
        trial(t,i).type = typematrixFin(t,i);
        trial(t,i).setSize=setsizevectorFin(t,i); 
        %trial(t,i).interTime=timematrixFin(t,i);
        % trial(t,i).probePie=piematrixFin(t,i);
    end                                  
end
%% 5) add locations and colors to trial
for v=1:pms.numBlocks
    for w=1:pms.numTrials
        colormatrix=sampledColorMatrix(pms);
        switch trial(w,v).setSize       %get random colors and locations from predefined matrices
            case 1  %setsize 1
                trial(w,v).colors=datasample(colormatrix,2,'Replace',false);    %2 colors: 1 for ENC, 1 for intervening
                trial(w,v).locations=datasample(locationmatrix,1,'Replace',false);%chooses n rows from matrix without replacement
            case 2  %setsize 2
                trial(w,v).colors=datasample(colormatrix,4,'Replace',false);    %4 colors: 2 ENC, 2 intervening
                trial(w,v).locations=datasample(locationmatrix,2,'Replace',false);  %2 locations
            case 3  %setsize 3
                trial(w,v).colors=datasample(colormatrix,6,'Replace',false);    %6 colors: 3 ENG, 3 interv
                trial(w,v).locations=datasample(locationmatrix,3,'Replace',false);  %3 locations
            case 4  %setsize 4
                trial(w,v).colors=datasample(colormatrix,8,'Replace',false);    %8 colors: 4 for ENG, 4 for interv
                trial(w,v).locations=locationmatrix;                                %all 4 locations
        end
    end
end
end
