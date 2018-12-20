function getInstructionsChoice(level,pms,wPtr)
%%%This function provides the insturctions for the
%%%Quantifying cognitive control experiment. As inputs it receives level (1=memory, 2=discounting),
%%encTime is the time they have to memorize squares during encoding and
%%maxRT the time they have to respond using the colorwheel.

HideCursor;

%% Define which text style to use for instructions
textCol = [0 0 0];
wrptx = 60;
spacing = 2;
Screen('TextSize',wPtr,23);
Screen('TextStyle',wPtr,1);
Screen('TextFont',wPtr,'Times New Roman');

%% Show first instructions with Screen('DrawText',wPtr,text,x,y,color)
%Add text that should appear

if level == 1 
    Instruction{1} = 'Welcome to the choice task.\n You can walk through the instructions by using the left and right arrow keys.\n Press the right arrow key to start...';
    Instruction{2} = 'During this part you can win a bonus by redoing a few more blocks of the memory task. However, the difficulty of the redo and the amount of the bonus will be based on choices that you will make beforehand.'; 
    Instruction{3} = 'You will also have the opportunity to avoid doing the redo and still earn a bonus. If you choose the No Redo option, then you can use the remaining time as you please, using the computer, your phone etc.';
    Instruction{4} = 'You will make two different kinds of choices.'
    imgChoiceUI=imread('ChoiceU1U3.png'); 
    imageChoiceUI=Screen('MakeTexture',wPtr,imgChoiceUI);
    Instruction{5} = '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n You will choose between two Redo options.\n\n For example: Would you rather receive 1 euro for doing Update(U) of 1 square or 2 euros for doing Update(U) of 3 squares ?';
    imgChoiceNR=imread('ChoiceNRI1.png'); 
    imageChoiceNR=Screen('MakeTexture',wPtr,imgChoiceNR);
    Instruction{6} = '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Or you will choose between a Redo and a No Redo option.\n\n For example: Would you rather receive 1 euro for not doing a redo or 2 euros for doing Ignore(I) of 1 square?';
    Instruction{7} = sprintf('To select the left option, press 1 and for the right option press 2. You have %d seconds to respond.',pms.maxRT);
    imgChoiceMade=imread('ChosenNRI1.png');
    imageChoiceMade=Screen('MakeTexture',wPtr,imgChoiceMade);
    Instruction{8} = '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n A square is shown to indicate that your choice\n has been made.';
    Instruction{9} = 'You will make many similar choices, for various amounts and number of squares.';
    Instruction{10} = 'One of these choices will be chosen randomly. The redo of the memory task and the bonus will be based on this choice.';
    Instruction{11} = 'Please take a moment to tell your experimenter what is going to happen in this task.'; 
    Instruction{12} = 'Press any key to start the practice for these trials.\n These choices are not counting yet.';

elseif level==2 
    Instruction{1} = 'You finished the practice trials.\n\n You will make many similar choices, of which one will be selected.';
    Instruction{2} = 'If the selected choice is a Redo, you will redo one to three blocks of the memory task, and you will receive the additional bonus based on that choice. 70% of all trials of the blocks you will do will consist of that choice.\n\n If the selected choice is a No Redo, you can use the remaining time in the cubicle as you please, using the computer, your phone etc., and you will receive the additional bonus based on that choice.';
    Instruction{3} = 'The number of blocks of the redo is randomly selected by the computer.';
    Instruction{4} = 'The amount of money of the bonus represents all blocks and not a single trial and it is extra on top of the agreed amount for the experiment. You will receive it if your performance during the redo is similar to your performance in the first two blocks of the previous memory task.';
    imgChoiceMadeI3=imread('ChosenI3U3.png');
    imageChoiceMadeI3=Screen('MakeTexture',wPtr,imgChoiceMadeI3);
    Instruction{5}= '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n For example, if this choice is selected you will do a\n few blocks of mostly Ignore 3 and you will earn 2 euros.';
    imgChoiceMadeNR=imread('ChosenNRU3.png');
    imageChoiceMadeNR=Screen('MakeTexture',wPtr,imgChoiceMadeNR);
    Instruction{6} = '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n For example, if this choice is selected you will not\n have to redo the previous memory task and you will earn 1 euro.';
    Instruction{7} = sprintf('We will split the task into %d blocks.\n\n After a block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    Instruction{8} = 'Similar to the previous memory task, the background pattern of the blocks will differ.';
    Instruction{9} = 'Do not rush your answers. It is very important that you think of both the money and your experience of doing the specific trials of the task.';
    Instruction{10} = 'Please take a moment to tell your experimenter what is going to happen in this task.'; 
    Instruction{11} = 'Press any key to start the task.\n Good luck!';
    
elseif level==3
    Instruction{1} = 'You finished this block.\n\n Press the right arrow to proceed with the next block.\n\nGood luck!';
    
elseif level==4
    Instruction{1}='This was the end of the choice task! \n\n Now one of your choices will be selected for the redo.';
    
end

counter=1;

for i=1:100
      RestrictKeysForKbCheck([pms.allowedResps.left, pms.allowedResps.right,37,39,40,38,32,97,98])
    if i==1
        back=0;
    end
    if counter<length(Instruction)
        counter=counter+back;
    end
    
    if level==1 
        if counter==5
            Screen('DrawTexture',wPtr,imageChoiceUI)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==6
            Screen('DrawTexture',wPtr,imageChoiceNR)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==8
            Screen('DrawTexture',wPtr,imageChoiceMade)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing); 
        end
        
    elseif level==2 
        if counter==5
            Screen('DrawTexture',wPtr,imageChoiceMadeI3)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==6
            Screen('DrawTexture',wPtr,imageChoiceMadeNR)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        end
        
    elseif  level==3 || level==4
        DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing); 
    end
    
    Screen('flip',wPtr);
    
    if level==1 && counter==11
        responded = 0;
        GetClicks();
        responded = 1;
        Screen('flip',wPtr);
        WaitSecs(2);
        continue;
    elseif level==2 && counter==10
        responded = 0;
        GetClicks();
        responded = 1;
        Screen('flip',wPtr);
        WaitSecs(2);
        continue;
    else
        KbWait()
    end
    if counter==length(Instruction)
        break;
    end
    %         imageArray=Screen('GetImage',wPtr);
    %         r=randi(100,1);
    %         imwrite(imageArray,sprintf('InstructionsChoice%d.png',r),'png');
    
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
            
        end
    end
end
            RestrictKeysForKbCheck([])

%  clear Screen