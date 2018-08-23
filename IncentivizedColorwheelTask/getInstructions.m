function getInstructions(level,pms,wPtr,money)
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


if level==1 %intro + instruction color vision 
    Instruction{1} = 'Welcome to our color wheel memory task.\n\n You can walk through the instructions by using the left and right arrow keys.\n Press the right arrow to start...';
    Instruction{2} = 'Before we start we need to check your color sensitivity. \n\n You will see a colored square in the middle of the screen.\n\n You should find the corresponding color on a color wheel around the square!'; 
    Instruction{3} = 'Responding works like this:\n\nFirst you determine the correct color on the color wheel.\nOnce you have decided on the color, you move the arrow to that color on the color wheel as fast as possible, but still try to be as accurate as possible. You don''t have to click on the wheel, you only need to move your mouse towards it. Once you reach a particular color on the wheel, that color is taken as your answer.\nPlease note that in order to move the mouse towards the color wheel as quickly as possible, you should first decide on the color before moving the mouse.\n\n A line appears which indicates your response. A second line indicates the correct color.';
    Instruction{4} = 'Press space to start.';
    
elseif level==2
    
    Instruction{1} = 'This task consists of multiple trials.';
    Instruction{2} = 'Every trial consists of 3 phases. First, you will have to memorize colors. Then, you see new colors that you might need to memorize. Finally you are tested on our color wheel!';
    Instruction{3} =sprintf('Phase 1: you will see colored squares and the letter "M" (memorize) on the screen.\n The squares will be shown for %.1f seconds.',pms.encDuration);
    Instruction{4} = 'You always need to memorize the colors and the locations of the squares.';
    imgEnc=imread(sprintf('encoding%d.png',pms.maxSetsize));
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1: memorize (M) colors and locations.';
    Instruction{6} = 'Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n You will see other squares at the same locations.\n The new squares will also be accompanied by a letter in the middle of the screen. The letter can be I or U.';
    Instruction{7} = 'The letter is very important because it tells you what to do next.\n If the letter is I, you need to ignore the new squares\n and continue to keep in memory the ones from phase 1.';
    imgIgnore=imread(sprintf('ignore%d.png',pms.maxSetsize));
    imageIgnore=Screen('MakeTexture',wPtr,imgIgnore);
    Instruction{8}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Ignore these squares.'; 
    Instruction{9} = 'But if the letter is U, you need to remember ONLY the new squares presented in phase 2.';
    imgUpdate=imread(sprintf('update%d.png',pms.maxSetsize));
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{10}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Update these squares to your memory.' ;
    Instruction{11} = 'Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the centre is I:\nyou IGNORE the new colors in phase 2.\n If the letter in the centre is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3:\n You see a color wheel and the frame of a square without color.\n You need to indicate by moving towards the wheel, which color you needed to remember.';
    imgProbe=imread(sprintf('probe%d.png',pms.maxSetsize));
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{12}='\nMove towards the correct color!\n(Not now, this is an example!)';
    Instruction{13}='Only your first response counts. Please always try to respond, even if you are not certain, and try to be as accurate and fast as possible. Keep your hand on the mouse so that you have enough time to respond.';
    Instruction{14}='Please always look at the screen while doing the task.';
    Instruction{15} ='Summary: \n\n Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the centre is I:\n you IGNORE the new colors in phase 2.\n If the letter in the centre is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3: On the color wheel you indicate which color you needed to remember.';
    Instruction{16}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1';
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{17}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2';
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{18}='Of all colors you need to indicate \n only the color of the highlighted square.';
    Instruction{19}='\n\n\n\n\n\n\n\n\n\n\n\n Not now, this is still an example.';
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{20} = 'Is everything clear?\n\n It is very important that you understand this part well and we realize that it might be confusing in the beginning.\n You will now do some practice trials.';
    Instruction{21} = 'You have 4 seconds to decide on the color, but once you start moving the mouse, you only have a very short time to reach the wheel. So make sure you first decide and only then start moving the mouse.';
    Instruction{22} = 'Please keep your hand on the mouse.'; 
    
elseif level==3
    
    Instruction{1} = 'You finished the practice trials.\n\n Press the right arrow to continue with the instructions.';
    Instruction{2}='During the actual memory task, you will only see your response on the color wheel, you will not see the correct response anymore.';
    Instruction{3}='On each trial you can win points.';
    Instruction{4}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Before every new trial you will see how many points you can win on that trial.';
    imgReward=importdata('Rewardcue.png');
    imageReward=Screen('MakeTexture',wPtr,imgReward);
%     Instruction{x}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n At the same time, we will track your gaze.';
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n You are then asked to press the space bar to start the trial.';
%     Instruction{x}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n If you stare at the points for much more than 1 second and you are not asked to press space, press the left Ctrl key, and the points will turn green to indicate that re-calibration is needed.';
%     Instruction{x}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n If you press the left Ctrl key, keep your eyes locked on the points until it turns black again, indicating that it has been re-calibrated.';
%     Instruction{x}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n You are then asked to press the space bar to start the trial as usual.';
    Instruction{6}='If you are close enough to the correct color, you win the points. At the end, you will receive a bonus proportional to the total number of points you won during the experiment.';
    Instruction{7}='Please look at the screen while doing the task.';
    Instruction{8}=sprintf('We will split the task in %d blocks. \n\n After each block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    Instruction{9}=sprintf('Each block lasts %d minutes, and you will complete as many trials as you can within those %d minutes.', pms.blockDuration/60, pms.blockDuration/60);
    Instruction{10}='Note that the faster you are, the more trials you can do, and the more money you can earn.';
    Instruction{11}='Please take a moment to tell your experimenter what is going to happen in this task.';
    Instruction{12} = 'You will now get a few examples to practice.\nPlease keep your hand on the mouse.';
    
elseif level==31 % when no space bar press after reward cue
    Instruction{1} = 'You finished the practice trials.\n\n Press the right arrow to continue with the instructions.';
    Instruction{2}='During the actual memory task, you will only see your response on the color wheel, you will not see the correct response anymore.';
    Instruction{3}='On each trial you can win points.';
    Instruction{4}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Before every new trial you will see how many points you can win on that trial.';
    imgReward=importdata('Rewardcue.png');
    imageReward=Screen('MakeTexture',wPtr,imgReward);
    Instruction{5}= 'If you are close enough to the correct color, you win the points. At the end, you will receive a bonus proportional to the total number of points you won during the experiment.';
    Instruction{6}= 'Please look at the screen while doing the task.';
    Instruction{7}=sprintf('We will split the task in %d blocks. \n\n After each block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    Instruction{8}=sprintf('Each block lasts %d minutes, and you will complete as many trials as you can within those %d minutes.', pms.blockDuration/60, pms.blockDuration/60);
    Instruction{9}= 'Note that the faster you are, the more trials you can do, and the more money you can earn.';
    Instruction{10}= 'Please take a moment to tell your experimenter what is going to happen in this task.';
    Instruction{11} = 'You will now start the task.';
    
elseif level==32 % when no rewards
    Instruction{1} = 'You finished the practice trials.\n\n Press the right arrow to continue with the instructions.';
    Instruction{2}='During the actual memory task, you will only see your response on the color wheel, you will not see the correct response anymore.';
    Instruction{3}= 'Please look at the screen while doing the task.';
    Instruction{4}=sprintf('We will split the task in %d blocks. \n\n After each block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    Instruction{5}=sprintf('Each block lasts %d minutes, and you will complete as many trials as you can within those %d minutes.', pms.blockDuration/60, pms.blockDuration/60);
    Instruction{6}= 'Please take a moment to tell your experimenter what is going to happen in this task.';
    Instruction{7} = 'You will now start the task.';    
    
elseif level==4
    Instruction{1} = 'You finished practicing.\n\n You will now start the task.\n\nPress the right arrow.';
    Instruction{2} = 'Good luck!';
    
elseif level==5
    
    Instruction{1} = 'You finished the first block of the task!\n\n Press the right arrow to continue with the next blocks.';
    if pms.blockCB==0
        Instruction{2}='During the coming block you will mostly get Ignore trials.\n\nDuring the block after you will mostly get Update trials.\n\nPress the right arrow.';
    elseif pms.blockCB==2
        Instruction{2}='During the coming block you will mostly get Update trials.\n\nDuring the block after you will mostly get Ignore trials.\n\nPress the right arrow.';
    end
    Instruction{3}='Everything else is the same as during the first block of the task.\n\nPress the right arrow.';
    Instruction{4} = 'Good luck!';
    
elseif level==6 && pms.points==1
    Instruction{1}=double(sprintf('This is the end of the color wheel memory task!\n Your total reward is %.2f euro.\n\n Please contact the researcher.', money));
elseif level==6 && pms.points==0
    Instruction{1}='This is the end of the color wheel memory task!\n\n Please contact the researcher.';
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
    
    if level==2
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
            case 16
                Screen('DrawTexture', wPtr, imageEnc);
            case 17
                Screen('DrawTexture', wPtr, imageUpdate);
            case 19
                Screen('DrawTexture',wPtr,imageProbe);
        end
        if counter==12
            DrawFormattedText(wPtr,Instruction{counter},'center',pms.yCenter-90,pms.textColor,pms.wrapAt,[],[],pms.spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
        end
    else   
         if (level==3 || level==31) && (counter==4)
             Screen('Textsize', wPtr, 34);
             Screen('Textfont', wPtr, 'Times New Roman');
             DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); %black reward cue
         elseif level==3 && (counter==5)
             Screen('Textsize', wPtr, 34);
             Screen('Textfont', wPtr, 'Times New Roman');
             DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); %black reward cue
             DrawFormattedText(wPtr, '[Press Space]', 'center', pms.yCenter+100, [0 0 0]);
%          elseif level==3 && counter==7
%              Screen('Textsize', wPtr, 34);
%              Screen('Textfont', wPtr, 'Times New Roman');
%              DrawFormattedText(wPtr, '50', 'center', 'center', [10 150 10]);%green reward cue
         end 
    Screen('TextSize',wPtr,pms.textSize); %change back to normal
    Screen('TextStyle',wPtr,pms.textStyle);
    Screen('TextFont',wPtr,pms.textFont);   
    DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
    end %level
    Screen('flip',wPtr);

  
    responded = 0;   
    if level==2 && counter==length(Instruction)
        WaitSecs(2);
        Screen('flip',wPtr);
        WaitSecs(1);
        break;
    elseif (level==3 || level==31 || level==32) && counter==length(Instruction)-1
        GetClicks();
        responded = 1;
        Screen('flip',wPtr);
        WaitSecs(2);
        continue;
    elseif (level==3 || level==31) && counter==length(Instruction)
        WaitSecs(2);
        Screen('flip',wPtr);
        WaitSecs(2);
        break;  
    elseif level==4 && counter==length(Instruction)
        WaitSecs(2);
        break; 
    elseif level==5 && counter==length(Instruction)
        WaitSecs(2);
        break;    
    elseif counter==length(Instruction)
        KbWait();
        Screen('flip',wPtr);
        WaitSecs(1);
        break;    
    else 
        KbWait();  
    end
    
%record the keyboard click
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




