function[trial]=trialstruct_circles(pms,rect,practice,cues, rewards)

   
% in the case of practice, the trials are not randomized and we may define maximum setsize in pms
pms.numBlocks=pms.numBlocksPr;
pms.numTrials=pms.numTrialsPr;
setsizevector = [pms.maxSetsize*ones(1,pms.numTrials)]';
setsizevectorFin=repmat(setsizevector,1,pms.numBlocks);
trialTypes=[0 2]';
typematrixFin=repmat(trialTypes,pms.numTrials/length(trialTypes),pms.numBlocks);

%% add cue and cue validity 
if cues==1;     
    valid_cues = repmat([0 2], 1, pms.numTrials*0.75/2); 
    invalid_cues = repmat([2 0], 1, pms.numTrials*0.25/2); 
    cue = [valid_cues, invalid_cues]'; 

    valid = [repmat(1, pms.numTrials*0.75,1); repmat(0, pms.numTrials*0.25,1)];
end

%% add reward on offer
if rewards == 1
    offer = round(50 + randn(pms.numTrials,1)*10+0);
    if any(offer < 35)
        reset = find(offer < 35);
        offer(reset) = 35;
    end
    if any(offer > 65)
        reset = find(offer > 65);
        offer(reset) = 65;
    end
end 

%% 3)make location matrix
locationmatrix = [rect(3)*0.5, rect(4)*0.5]; % circles will be centered in middle of screen
locationmatrix = repmat(locationmatrix,4,1);

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
        if cues==1
            trial(t,i).cue=cue(t,i); 
            trial(t,i).valid=valid(t,i); 
        end
        if rewards==1
            trial(t,i).offer=offer(t,i); 
        end 
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

%% 6) shuffle order
    trialRandomizing = trial;
    rows = size(trial,1); 
    r = 1;
    for i = randperm(rows)
        trial(r,1) = trialRandomizing(i,1);
        r = r+1;
    end

end
