function [data] = MChoiceTrial(pms, data, wPtr,rect, dataFilenamePrelim) 
    
%% setup
% make rectangles for each stimulus
for j = 1:4 
    rects(j,:) = CenterRectOnPointd([-1, -1, 1, 1]*pms.ground/2, pms.rectCtrsx(j),pms.rectCtrsy(j));
end
    
trlArray = pms.trlArray;
  
%% loop over blocks
for b = 1:pms.numBlocks
    
    data.block{b}.times(end+1)=GetSecs-pms.exptOnset; 
    data.block{b}.labels{end+1}= sprintf('Run Start block %d',b);
    
    trial_start = 1;
    trial_end = size(trlArray.block{b},1);
    
%% loop over trials    
for trial = trial_start:trial_end
     easyTask = trlArray.block{b}(trial,1); % set sooner delay
     hardTask = trlArray.block{b}(trial,2); % set later delay
     adjDel = 1;%.adjDel(trial); % set task being discounted (in task-amount pair)
     amt = trlArray.block{b}(trial,3); % set base offer amount
     decNum = trlArray.block{b}(trial,5); % set decision number (for task-amount pair)
     if adjDel == 1
         offerAmt = data.block{b}.ssOffer(trial);
     else
         offerAmt = data.block{b}.llOffer(trial);
     end

%% show the offers and collect a response (1=easy, 2=hard, 9=too slow)  

    [resp, onLeft, onset, RT, onTop] = MshowChoiceTrial(wPtr,rect,rects,trial,adjDel,offerAmt,pms,data.block{b});
   
%% show offers again when response was too slow

          while resp == 9 % too slow
              [resp, onLeft, onset, RT, onTop] = MshowChoiceTrial(wPtr,rect,rects,trial,adjDel,offerAmt,pms,data.block{b}); % show the offers again
          end
  
%% calibration

          % set amount adjustment depending on response
          if adjDel == resp % if the task being discounted is selected
              data.block{b}.adjAmt(trial) = -1*data.block{b}.adjAmt(trial); % -1*calAdj(decNum,amt);
          end
            
          % set next offer amount (search next calibration row in trlArray matching on task, base amount, and next trial number)
           offerIdx = find(((trlArray.block{b}(:,1)==easyTask) + (trlArray.block{b}(:,2)==hardTask) + (trlArray.block{b}(:,3)==amt) + (trlArray.block{b}(:,5)==decNum+1))==4);
           if adjDel == 1 
               data.block{b}.ssOffer(offerIdx) = data.block{b}.adjAmt(trial) + offerAmt;
               data.block{b}.llOffer(offerIdx) = amt;
           elseif adjDel == 2 
               data.block{b}.ssOffer(offerIdx) = amt;
               data.block{b}.llOffer(offerIdx) = data.block{b}.adjAmt(trial) + offerAmt;
           elseif decNum == pms.nCalTrials % if on the final calibration trial 
              % set the indifference SV and assign to subsequent trials based on proximity
               indiff = data.block{b}.adjAmt(trial) + offerAmt;
               trlmax = max(trlArray.block{b}(trlArray.block{b}(:,1)==easyTask & trlArray.block{b}(:,2)==hardTask & trlArray.block{b}(:,3)==amt,5));
              % set subsequent offer amounts
               for kk = (pms.nCalTrials+1):trlmax % for all non-calibration trials tskAmtTrlNm
                   offerIdx = find(((trlArray.block{b}(:,1)==easyTask) + (trlArray.block{b}(:,2)==hardTask) + (trlArray.block{b}(:,3)==amt) + (trlArray.block{b}(:,5)==kk))==4);
                   % for task-amount pair: smallOffer = (amount - indifference SV) * proximity + indifference SV
                   if trlArray.block{b}(offerIdx,4) > 0
                       smallOffer = (amt - indiff) * trlArray.block{b}(offerIdx,4) + indiff; %M: CHECK!!!!!
                   else
                       smallOffer = indiff * trlArray.block{b}(offerIdx,4) + indiff;
                   end
                    
                   if adjDel == 1
                       data.block{b}.ssOffer(offerIdx) = smallOffer;
                       data.block{b}.llOffer(offerIdx) = amt;
                   else
                       data.block{b}.ssOffer(offerIdx) = amt;
                       data.block{b}.llOffer(offerIdx) = smallOffer;
                   end
               end % for kk
           end % if adjDel
     
     data.block{b}.ssPos(trial) = onLeft; % 1 for left, 2 for right
     data.block{b}.aaTop(trial) = onTop; % 1 for top, 2 for bottom
     data.block{b}.choiceOnset(trial) = onset;
     data.block{b}.choiceRT(trial) = RT;
     data.block{b}.choice(trial) = resp;
     
   % break after each block  
     if pms.practice==0
         if trial==trial_end
             if b~=pms.numBlocks
                 WaitSecs(2);
                 getInstructionsChoice(3,pms,wPtr);
             end
             break; %end trial loop and go to next block
         end
     end
        
end % trial = trial_start:trial_end

end % for b = 1:pms.numBlocks
            
end % function
    