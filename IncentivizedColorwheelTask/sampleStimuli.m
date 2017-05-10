function [trial]=sampleStimuli
% function that samples and shuffles the defined stimuli for the colorwheel task.
%more information about the defined stimuli in readinStimuli.m.

numTrials=64;
numBlocks=2;
%stimuli are counterbalanced by sets of 8
counterN=8;
setSize=1:4;
%how many trials we need per set size
numPerSZ=(numTrials*numBlocks)/length(setSize);
%matrix created in readingStimuli.m
load stimuli.mat

%to sample for different amounts of trials/blocks and not lose
%the counterbalancing,the stimuli are split in counterbalanced columns of 8
sz1=reshape(sz1,counterN,length(sz1)/counterN);
sz2=reshape(sz2,counterN,length(sz2)/counterN);
sz3=reshape(sz3,counterN,length(sz3)/counterN);
sz4=reshape(sz4,counterN,length(sz4)/counterN);

%Indices to sample from as many split columns as required 
index1=randsample(size(sz1,2),numPerSZ/counterN);
index2=randsample(size(sz2,2),numPerSZ/counterN);
index3=randsample(size(sz3,2),numPerSZ/counterN);
index4=randsample(size(sz4,2),numPerSZ/counterN);

%Sample
sz1S=sz1(:,index1);
sz2S=sz2(:,index2);
sz3S=sz3(:,index3);
sz4S=sz4(:,index4);

allSZ=[sz1S;sz2S;sz3S;sz4S];
trial=reshape(allSZ,numTrials,numBlocks);

%indices to shuffle stimuli in each block. We need as many as blocks.
indb1=randperm(length(trial));
indb2=randperm(length(trial));

trial(:,1)=trial(indb1); trial(:,2)=trial(indb2);

%removing update short from trial, if not required
for y=1:size(trial,2)
    for x=1:length(trial)
        if trial(x,y).type==22
            trial(x,y).type=2;
        end 
    end
end

%Save matrix, so that same stimuli appear for all participants
%save('trial','trial')

%previous version
% Usz1=[];
% Usz2=[];
% Usz3=[];
% Usz4=[];
% 
% 
% for ind=1:length(sz1)
%     if sz1(ind).type==22 || sz1(ind).type==2
%     Usz1=[Usz1 sz1(ind)];
%     end
% end
% 
% for ind=1:length(sz2)
%     if sz2(ind).type==22 || sz2(ind).type==2
%     Usz2=[Usz2 sz2(ind)];
%     end
% end
% 
% for ind=1:length(sz3)
%     if sz3(ind).type==22 || sz3(ind).type==2
%     Usz3=[Usz3 sz3(ind)];
%     end
% end
% 
% for ind=1:length(sz4)
%     if sz4(ind).type==22 || sz4(ind).type==2
%     Usz4=[Usz4 sz4(ind)];
%     end
% end
%     
% 
% Isz1=[];
% Isz2=[];
% Isz3=[];
% Isz4=[];
% 
% for ind=1:length(sz1)
%     if sz1(ind).type==0
%     Isz1=[Isz1 sz1(ind)];
%     end
% end
% 
% 
% for ind=1:length(sz2)
%     if sz2(ind).type==0
%     Isz2=[Isz2 sz2(ind)];
%     end
% end
% 
% 
% for ind=1:length(sz3)
%     if sz3(ind).type==0
%     Isz3=[Isz3 sz3(ind)];
%     end
% end
% 
% 
% for ind=1:length(sz4)
%     if sz4(ind).type==0
%     Isz4=[Isz4 sz4(ind)];
%     end
% end
% 
% %we shuffle each type/sz
% Usz1=Usz1(randperm(length(Usz1)));
% Usz2=Usz2(randperm(length(Usz2)));
% Usz3=Usz3(randperm(length(Usz3)));
% Usz4=Usz4(randperm(length(Usz4)));
% 
% Isz1=Isz1(randperm(length(Isz1)));
% Isz2=Isz2(randperm(length(Isz2)));
% Isz3=Isz3(randperm(length(Isz3)));
% Isz4=Isz4(randperm(length(Isz4)));
% 
% %the trials now are half per type, so we devide by 2 since we are going to
% %sample with the same indices between I and U.
% index=randperm(numTrials/2);
% %this creates a matrix of indices that will sample 1/8 per sz and type, so
% %we have eventualy 1/4 per sz
% indices=reshape(index',numBlocks,numTrials/8); 
% indices=indices';
% 
% b1sz1=[Isz1(indices(:,1)) Usz1(indices(:,1))];   
% b1sz2=[Isz2(indices(:,1)) Usz2(indices(:,1))];    
% b1sz3=[Isz3(indices(:,1)) Usz3(indices(:,1))];   
% b1sz4=[Isz4(indices(:,1)) Usz4(indices(:,1))];   
% b1=[b1sz1 b1sz2 b1sz3 b1sz4];
% 
% b2sz1=[Isz1(indices(:,2)) Usz1(indices(:,2))];  
% b2sz2=[Isz2(indices(:,2)) Usz2(indices(:,2))];  
% b2sz3=[Isz3(indices(:,2)) Usz3(indices(:,2))]; 
% b2sz4=[Isz4(indices(:,2)) Usz4(indices(:,2))]; 
% b2=[b2sz1 b2sz2 b2sz3 b2sz4];
% 
% b3sz1=[Isz1(indices(:,3)) Usz1(indices(:,3))]; 
% b3sz2=[Isz2(indices(:,3)) Usz2(indices(:,3))]; 
% b3sz3=[Isz3(indices(:,3)) Usz3(indices(:,3))]; 
% b3sz4=[Isz4(indices(:,3)) Usz4(indices(:,3))]; 
% b3=[b3sz1 b3sz2 b3sz3 b3sz4];
% 
% b4sz1=[Isz1(indices(:,4)) Usz1(indices(:,4))];
% b4sz2=[Isz2(indices(:,4)) Usz2(indices(:,4))]; 
% b4sz3=[Isz3(indices(:,4)) Usz3(indices(:,4))];
% b4sz4=[Isz4(indices(:,4)) Usz4(indices(:,4))]; %%%mistake was here!
% 
% b4=[b4sz1 b4sz2 b4sz3 b4sz4];
% 
% trial(:,1)=b1(randperm(length(b1)));
% trial(:,2)=b2(randperm(length(b2)));
% trial(:,3)=b3(randperm(length(b3)));
% trial(:,4)=b4(randperm(length(b4)));
% 


%save('trial','trial')
end