function[trial]=trialstruct(pms,rect,practice,cues, rewards)

   
% in the case of practice, the trials are not randomized and we may define maximum setsize in pms
pms.numBlocks=pms.numBlocksPr; % has to be 1 to work here
pms.numTrials=pms.numTrialsPr;
setsizevector = [];
for ss = pms.maxSetsize
    setsizevector = [setsizevector; ss*ones(1,pms.numTrials/length(pms.maxSetsize))'];
end 
setsizevectorFin=repmat(setsizevector,1,pms.numBlocks);
trialTypes=[0 2]';
typematrixFin=repmat(trialTypes,pms.numTrials/length(trialTypes),pms.numBlocks);


%% 3)make location matrix
if pms.shape==0 %squares

    rectsize=[0 0 100 100];
    numrects=4;
    xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]';

    locationmatrix=zeros(size(xyindex,1),size(xyindex,2));
    for r=1:length(locationmatrix)
        locationmatrix(r,1)=(rect(3)*xyindex(r,1));
        locationmatrix(r,2)=(rect(4)*xyindex(r,2));
    end
    
elseif pms.shape==1 %concentric circles
    
    locationmatrix = [0 0 rect(3)*0.04 rect(3)*0.04; 0 0 rect(3)*0.08 rect(3)*0.08; 0 0 rect(3)*0.12 rect(3)*0.12; 0 0 rect(3)*0.16 rect(3)*0.16]; % circles will be centered in middle of screen

end

%% 4)append columns
%%%  Put into structure (for easy output of function)
trialsvector=(1:pms.numTrials)';
trialsmatrix=repmat(trialsvector,1,pms.numBlocks);

trial=struct();
for i=1:pms.numBlocks
    for t=1:pms.numTrials
        trial(t,i).number  = trialsmatrix(t,i);
        trial(t,i).type    = typematrixFin(t,i);
        trial(t,i).setSize = setsizevectorFin(t,i); 
    end                                  
end

%% 5) add locations and colors to trial

if pms.shape==0 %squares
    
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
      
elseif pms.shape==1 %concentric circles
   
    for v=1:pms.numBlocks
        for w=1:pms.numTrials
            colormatrix=sampledColorMatrix(pms);
            switch trial(w,v).setSize       %get random colors and sizes from predefined matrices
                case 1  %setsize 1
                    trial(w,v).colors=datasample(colormatrix,2,'Replace',false);    %2 colors: 1 for ENC, 1 for intervening
                    trial(w,v).locations=locationmatrix(1,:);                               %only smallest circle
                case 2  %setsize 2
                    trial(w,v).colors=datasample(colormatrix,4,'Replace',false);    %4 colors: 2 ENC, 2 intervening
                    trial(w,v).locations=datasample(locationmatrix(1:2,:),2,'Replace',false);  %2 sizes, in random order
                case 3  %setsize 3
                    trial(w,v).colors=datasample(colormatrix,6,'Replace',false);    %6 colors: 3 ENG, 3 interv
                    trial(w,v).locations=datasample(locationmatrix(1:3,:),3,'Replace',false);  %3 sizes
                case 4  %setsize 4
                    trial(w,v).colors=datasample(colormatrix,8,'Replace',false);    %8 colors: 4 for ENG, 4 for interv
                    trial(w,v).locations=datasample(locationmatrix(1:4,:),4,'Replace',false);                     %all 4 sizes
            end
        end
    end

end

%% 6) add reward cues to trial
if cues==1  
    offer = [ones(1,(pms.numTrials/2))*10,ones(1,(pms.numTrials/2))*50];
   for a=1:pms.numBlocks
        for b=1:pms.numTrials
            trial(b,a).offer = offer(b);
        end
   end
end

%% 7) shuffle order
    trialRandomizing = trial;
    rows = size(trial,1); 
    r = 1;
    for i = randperm(rows)
        trial(r,1) = trialRandomizing(i,1);
        r = r+1;
    end

end
