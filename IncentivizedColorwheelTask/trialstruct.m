function[trial]=trialstruct(pms,rect,practice,varargin)

if practice==0
    trialvector=[zeros(1,pms.numTrials/pms.numCondi), 22*ones(1,(pms.numTrials/pms.numCondi))];
    blockmatrix = repmat(trialvector, 1,pms.numBlocks);
    
    setsize = [1,2,3,4]';
    setsizevector = repmat(setsize,pms.numTrials/length(setsize),pms.numBlocks); %MF: the size of this matrix is not right.. should be numTrials*numBlocks; this is too big.

    
    %% 1) Get randomization idx output
    RandomIdx=[];       %Get randomization idx output
    for v = 1:pms.numBlocks
        RandomIdx(:,v)= randperm(pms.numTrials);
    end
    %% 2) Apply same RandomIdx to eg Blockmatrix, (but also setsize,...)
    
    typematrixFin =[pms.numTrials,pms.numBlocks];
    setsizevectorFin =[pms.numTrials,pms.numBlocks];
    
    for y = 1:pms.numBlocks
        for x = 1:pms.numTrials
            typematrixFin(x,y) = blockmatrix(RandomIdx(x,y));
            setsizevectorFin(x,y) = setsizevector(RandomIdx(x,y));            
        end
    end
    
    %DP:in the case of practice, the trials are not randomized and we may define maximum setsize in pms
elseif practice==1
    pms.numBlocks=pms.numBlocksPr;
    pms.numTrials=pms.numTrialsPr;
    setsizevector = [ones(1,(pms.numTrials/pms.maxSetsize)), 2*ones(1,pms.numTrials/pms.maxSetsize), 3*ones(1,pms.numTrials/pms.maxSetsize),pms.maxSetsize*ones(1,pms.numTrials/pms.maxSetsize)]';
    setsizevectorFin=repmat(setsizevector,1,pms.numBlocks);
    trialTypes=[0 2]';
    typematrixFin=repmat(trialTypes,pms.numTrials/length(trialTypes),pms.numBlocks);
    
%% shuffle    
    randomIdx=randperm(pms.numTrials);
    typematrixFin=typematrixFin(randomIdx);setsizevectorFin=setsizevectorFin(randomIdx);
    
end

%% 3)make location matrix
rectsize=[0 0 100 100];
numrects=4;
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
