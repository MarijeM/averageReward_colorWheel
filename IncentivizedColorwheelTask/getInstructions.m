function getInstructions(level,pms,wPtr,bonus)
% % This function provides the instructions for the
% % color wheel memory task based on which phase of the experiment we are
% % (practice, begining, end). If level is 1 then it provides the detailed
% % instructions for the task, if level is 2 the actual task starts, level 3
% % informs about the end of practice and level 4 about the end of the
% % memory task.
% %
% SYNTAX
%
% GETINSTRUCTIONS(level,pms,wPtr)
% level:    phase of the experiment we need instructions for (1: begin practice, 2: begin task, 3: end practice, 4: end task)
% pms:      parameteres defined in main script. Here we use parameters pms.yCenter (middle of y axis of screen), pms.textColor (color of text)and pms.wrapAt (where to wrap the text).
% wPtr:     monitor (given as output in main script by PTB function  [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));)
%
%

%Hide mouse during instructions
HideCursor;

%% Text for level 1. Every cell is a different screen.


if level==1
    Instruction{1} = 'Welcome to our color wheel memory task.\n You can walk through the instructions by using the left and right arrow keys.\n Press the right arrow to start...';
    Instruction{2} = 'Before we start we need to check your color sensitivity. \n\n You will see a colored square in the middle of the screen.\n\n You should find the corresponding color on a color wheel around the square and click it!'; 
    Instruction{3} = 'Responding works like this:\n\nFirst you determine the correct color on the color wheel.\n\nOnce you know where you want to click, you move the arrow to that color on the color wheel as fast as possible, but still try to be as accurate as possible. You don''t have to click on the wheel, you only need to hover over it. Once you reach a particular color on the wheel, that color is taken as your answer.\n\n\nPlease note that to answer as quickly as possible after you have started moving the mouse, you should first decide on the color before moving the mouse.\n\n\n\n\nPress space to start.';

elseif level==2
    
    Instruction{2} = 'Every trial of this task consists of 3 phases. First, you will have to memorize colors and locations. Then, you see new colors that you might need to memorize. Finally you are tested on our color wheel!';
    Instruction{3} =sprintf('Phase 1: you will see colored squares and the letter "M" (memorize) on the screen.\n The squares will be shown for %.1f seconds.',pms.encDuration);
    Instruction{4} = 'You always need to memorize the colors and the locations of the squares.';
    imgEnc=imread('Encoding.png');
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1: memorize (M) colors and locations.';
    Instruction{6} = 'Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n You will see other squares at the same locations.\n The new squares will also be accompanied by a letter in the middle of the screen. The letter can be I or U.';
    Instruction{7} = 'The letter is very important because it tells you what to do next.\n If the letter is I, you need to ignore the new squares\n and continue to keep in memory the ones from phase 1.';
    imgIgnore=importdata('Ignore.png');
    imageIgnore=Screen('MakeTexture',wPtr,imgIgnore);
    Instruction{8}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Ignore these squares.'; 
    Instruction{9} = 'But if the letter is U, you need to remember ONLY the new squares presented in phase 2.';
    imgUpdate=importdata('Update.png');
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{10}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Update these squares to your memory.' ;
    Instruction{11} = sprintf('Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the centre is I:\nyou IGNORE the new colors in phase 2.\n If the letter in the centre is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3:\n You see a color wheel and the frame of a square without color.\n You need to indicate by hovering over the wheel, which color you needed to remember.\n You have %d seconds to respond.',pms.maxRT);
    imgProbe=importdata('Probe.png');
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{12}='Hover over the correct color!\n (Not now, this is an example!)';
    Instruction{13}='Only your first response counts. Please always try to respond, even if you are not certain, and try to be as accurate and fast as possible. Keep your hand on the mouse so that you have enough time to respond.';
    Instruction{14}='Please always look at the screen while doing the task.';
    Instruction{15} ='Summary: \n\n Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the centre is I:\n you IGNORE the new colors in phase 2.\n If the letter in the centre is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3: On the color wheel you indicate which color you needed to remember.';
    Instruction{17}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1';
    imgEnc4=importdata('Encsz4.png');
    imageEnc4=Screen('MakeTexture',wPtr,imgEnc4);
    Instruction{18}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2';
    imgUpdate4=importdata('Update4.png');
    imageUpdate4=Screen('MakeTexture',wPtr,imgUpdate4);
    Instruction{19}='Of all 4 colors you need to indicate \n only the color of the highlighted square.';
    Instruction{20}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Not now, this is still an example.';
    imgProbe4=importdata('ProbeSZ4.png');
    imageProbe4=Screen('MakeTexture',wPtr,imgProbe4);
    Instruction{21} = 'Is everything clear?\n\n It is very important that you understand this part well and we realize that it might be confusing in the beginning.\n Please contact the researchers, they will start the practice when all questions are addressed..';
    
elseif level==3
    
    Instruction{1} = 'You finished the practice.\n\n You may now proceed with the actual task by pressing the right arrow.';
    Instruction{2}='During the actual memory task, you will only see where you clicked on the color wheel, you will not see the correct response.';
    Instruction{3}=sprintf('We split the task in %d blocks. \n\n After every block you can take a break or continue with the task.',pms.numBlocks*2);
    Instruction{4}='Every blocks lasts 7 minutes, and you will complete as many trials as you can within those 7 minutes.';
    Instruction{5}='On each trial you can win money.';
    Instruction{6}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Before every new trial you will see how many cents you can win on that trial.';
    imgReward=importdata('Rewardcue.png');
    imageReward=Screen('MakeTexture',wPtr,imgReward);
    Instruction{7} = 'After the reward, the trial begins.';
    Instruction{8}='If you are close enough to the correct color, you win the money.\n\n At the end, the amount you won on all the trials will be summed up.\n and you will receive a bonus proportional to this amount.';
    Instruction{9}='Now please contact the researcher before continuing with the task.';
    Instruction{10}='Good luck with the memory task!';
    
elseif level==4
    Instruction{1}=double(sprintf('This is the end of the color wheel memory task!\n Your total reward is ?%.2f.\n\n Please contact the researcher.', bonus/1000));

end %level

counter=1;

for i=1:100 
           RestrictKeysForKbCheck([37,39,40,38,32,97,98]);
    if i==1
        back=0;
    end
    if counter<length(Instruction)
        counter=counter+back;
    end
    
    if level==1
        % Exceptions for figures;
        switch counter
            case 5
                Screen('DrawTexture', wPtr, imageEnc);
            case 8
                Screen('DrawTexture', wPtr, imageIgnore);
            case 10
                Screen('DrawTexture', wPtr, imageUpdate);
            case 12
                Screen('DrawTexture', wPtr, imageProbe);
            case 17
                Screen('DrawTexture', wPtr, imageEnc4);
            case 18
                Screen('DrawTexture', wPtr, imageUpdate4);
            case 20
                Screen('DrawTexture',wPtr,imageProbe4);
        end
        if counter==12
            DrawFormattedText(wPtr,Instruction{counter},'center',pms.yCenter-90,pms.textColor,pms.wrapAt,[],[],pms.spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
        end
    end %level
    
    if level==2 && counter==6
        Screen('DrawTexture',wPtr,imageReward);
    end

    if level==2 
        DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
    elseif level==3
        DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,[],[],[],pms.spacing);
    end
    
    Screen('flip',wPtr);
  
    if level==1 && counter==length(Instruction)
        GetClicks();
        Screen('flip',wPtr);
        WaitSecs(2);
        break   
    elseif level==2 && counter==length(Instruction)-1
        GetClicks();
        Screen('flip',wPtr);
        WaitSecs(1);
        break;
    elseif level==2 && counter==length(Instruction)
        KbWait();
        Screen('flip',wPtr);
        WaitSecs(2);
        break
    elseif counter==length(Instruction)
        KbWait();
        break;
    else 
        KbWait();  
    end
    
%record the keyboard click
    responded = 0;
    while responded == 0
        [keyIsDown,~,KeyCode] = KbCheck;
        if keyIsDown==1
            WaitSecs(1);
            responded = 1;
            if find(KeyCode)==37 && counter~=1
                back=-1;
            else
                back=1;
            end
        end %level
    end %while responded==0
end 
RestrictKeysForKbCheck([]);

end 




