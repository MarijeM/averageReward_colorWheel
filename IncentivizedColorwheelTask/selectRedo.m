function[task,taskName,amount]= selectRedo(dataChoice,pms)

% choose random block
 b = randi(pms.numBlocks);
 
% select random choice
 trlidx = randi(length(dataChoice.block{b}.trialNumber)); %randomisation index
 selChc = dataChoice.block{b}.choice(trlidx); %select random choice from choices
 if selChc == 2 %selected choice = hard task
     task = dataChoice.block{b}.hardTask(trlidx);
     taskName = pms.tasks{task};
     amount = dataChoice.block{b}.llOffer(trlidx);
 elseif selChc == 1 %selected choice = easy task
     task = dataChoice.block{b}.easyTask(trlidx);
     taskName = pms.tasks{task};
     amount = dataChoice.block{b}.ssOffer(trlidx);
 end


end