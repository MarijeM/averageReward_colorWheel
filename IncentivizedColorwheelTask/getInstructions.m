function getInstructions(level,pms,practice,rect,wPtr,money)
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
%add path to open example images
addpath(fullfile(pms.inccwdir,'Images'));

%% Text for level 1. Every cell is a different screen.


if level==1 %intro + instruction color vision 
    Instruction{1} = 'Welcome to our color wheel memory task.\n\n You can walk through the instructions by using the left and right arrow keys.\n Press the right arrow to start...';
    Instruction{2} = 'Before we start we need to check your color sensitivity. \n\n You will see a colored square in the middle of the screen.\n\n You should find the corresponding color on a color wheel around the square!'; 
    Instruction{3} = 'Responding works like this:\n\nFirst you determine the correct color on the color wheel.\nOnce you have decided on the color, you move the arrow to that color on the color wheel as fast as possible, but still try to be as accurate as possible. You don''t have to click on the wheel, you only need to move your mouse towards it. Once you reach a particular color on the wheel, that color is taken as your answer.';
    Instruction{4} = 'Please note that in order to move the mouse towards the color wheel as quickly as possible, you should first decide on the color before moving the mouse.\n\n\n First decide...                       then move.\n\n\n A line appears which indicates your response. A second line indicates the correct color.';
    Instruction{5} = 'Press space to start.';
    
elseif level==2 && practice==1 && pms.shape==0 %squares
    
    Instruction{1} = 'This task consists of multiple trials.';
    Instruction{2} = 'Every trial consists of 3 phases. First, you will have to memorize colors. Then, you see new colors that you might need to memorize. Finally you are tested on our color wheel!';
    Instruction{3} =sprintf('Phase 1: you will see colored squares and the letter "M" (memorize) on the screen.\n The squares will be shown for %.1f seconds.',pms.encDuration);
    Instruction{4} = 'You always need to memorize the colors and the locations of the squares.';
    imgEnc=imread(sprintf('encoding%d.png',pms.maxSetsize(2)));
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1: memorize (M) colors and locations.';
    Instruction{6} = 'Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n You will see other squares at the same locations.\n The new squares will also be accompanied by a letter in the middle of the screen. The letter can be I or U.';
    Instruction{7} = 'The letter is very important because it tells you what to do next.\n If the letter is I, you need to ignore the new squares\n and continue to keep in memory the ones from phase 1.';
    imgIgnore=imread(sprintf('ignore%d.png',pms.maxSetsize(2)));
    imageIgnore=Screen('MakeTexture',wPtr,imgIgnore);
    Instruction{8}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Ignore these squares.'; 
    Instruction{9} = 'But if the letter is U, you need to remember ONLY the new squares presented in phase 2.';
    imgUpdate=imread(sprintf('update%d.png',pms.maxSetsize(2)));
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{10}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Update these squares to your memory.' ;
    Instruction{11} = 'Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the center is I:\nyou IGNORE the new colors in phase 2.\n If the letter in the center is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3:\n You see a color wheel and the frame of a square without color.\n You need to indicate by moving towards the wheel, which color you needed to remember.';
    imgProbe=imread(sprintf('probe%d.png',pms.maxSetsize(2)));
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{12}='\nMove towards the correct color!\n(Not now, this is an example!)';
    Instruction{13}='Only your first response counts. Please always try to respond, even if you are not certain, and try to be as accurate and fast as possible. Keep your hand on the mouse so that you have enough time to respond.';
    Instruction{14}='Please always look at the screen while doing the task.';
    Instruction{15} ='Summary: \n\n Phase 1:\n You always MEMORIZE the colors and locations of the squares.\n\n Phase 2:\n If the letter in the center is I:\n you IGNORE the new colors in phase 2.\n If the letter in the center is U:\n you UPDATE your memory with ONLY the new squares.\n\n Phase 3: On the color wheel you indicate which color you needed to remember.';
    Instruction{16}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1';
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{17}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2';
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{18}='Of all colors you need to indicate \n only the color of the highlighted square.';
    Instruction{19}='\n\n\n\n\n\n\n\n\n\nNot now, this is still an example.';
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{20} = 'On some trials you will see 3 squares, on others only 1.';
    Instruction{21} = 'You have 4 seconds to decide on the color, but once you start moving the mouse, you only have a very short time to reach the wheel. So make sure you first decide and only then start moving the mouse.';
    Instruction{22} = 'Please take a moment to tell your experimenter what is going to happen in this task.'; 
    Instruction{23} = 'You will now do some practice trials.\n\nPlease keep your hand on the mouse.'; 

elseif level==2 && practice==1 && pms.shape==1 %concentric circles
    Instruction{1} = 'This task consists of multiple trials.';
    Instruction{2} = 'Every trial consists of 3 phases. First, you will have to memorize colors. Then, you see new colors that you might need to memorize. Finally you are tested on our color wheel!';
    Instruction{3} =sprintf('Phase 1: you will see colored circles and the letter "M" (memorize) on the screen.\n The circles will be shown for %.1f seconds.',pms.encDuration);
    Instruction{4} = 'You always need to memorize the colors and the positions of the circles.';
    imgEnc=imread(sprintf('encoding%d.png',pms.maxSetsize(2)));
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1: memorize (M) colors and positions.';
    Instruction{6} = 'Phase 1:\n You always MEMORIZE the colors and positions of the circles.\n\n Phase 2:\n You will see other circles at the same positions.\n The new squares will also be accompanied by a letter in the middle of the screen. The letter can be I or U.';
    Instruction{7} = 'The letter is very important because it tells you what to do next.\n If the letter is I, you need to ignore the new circles\n and continue to keep in memory the ones from phase 1.';
    imgIgnore=imread(sprintf('ignore%d.png',pms.maxSetsize(2)));
    imageIgnore=Screen('MakeTexture',wPtr,imgIgnore);
    Instruction{8}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Ignore these circles.'; 
    Instruction{9} = 'But if the letter is U, you need to remember ONLY the new circles presented in phase 2.';
    imgUpdate=imread(sprintf('update%d.png',pms.maxSetsize(2)));
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{10}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Update these circles to your memory.' ;
    Instruction{11} = 'Phase 1:\n You always MEMORIZE the colors and positions of the circles.\n\n Phase 2:\n If the letter in the center is I:\nyou IGNORE the new circles in phase 2.\n If the letter in the center is U:\n you UPDATE your memory with ONLY the new circles.\n\n Phase 3:\n You see a color wheel and the frame of a circle without color.\n You need to indicate by moving towards the wheel, which color you needed to remember.';
    imgProbe=imread(sprintf('probe%d.png',pms.maxSetsize(2)));
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{12}='\nMove towards the correct color!\n(Not now, this is an example!)';
    Instruction{13}='Only your first response counts. Please always try to respond, even if you are not certain, and try to be as accurate and fast as possible. Keep your hand on the mouse so that you have enough time to respond.';
    Instruction{14}='Please always look at the screen while doing the task.';
    Instruction{15} ='Summary: \n\n Phase 1:\n You always MEMORIZE the colors and positions of the circles.\n\n Phase 2:\n If the letter in the center is I:\n you IGNORE the new circles in phase 2.\n If the letter in the center is U:\n you UPDATE your memory with ONLY the new circles.\n\n Phase 3: On the color wheel you indicate which color you needed to remember.';
    Instruction{16}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1';
    imageEnc=Screen('MakeTexture',wPtr,imgEnc);
    Instruction{17}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2';
    imageUpdate=Screen('MakeTexture',wPtr,imgUpdate);
    Instruction{18}='Of all colors you need to indicate \n only the color of the highlighted circle.';
    Instruction{19}='\n\n\n\n\n\n\n\n\n\n\n\n Not now, this is still an example.';
    imageProbe=Screen('MakeTexture',wPtr,imgProbe);
    Instruction{20} = 'On some trials you will see 3 circles, on others only 1.';
    Instruction{21} = 'You have 4 seconds to decide on the color, but once you start moving the mouse, you only have a very short time to reach the wheel. So make sure you first decide and only then start moving the mouse.';
    Instruction{22} = 'Please take a moment to tell your experimenter what is going to happen in this task.'; 
    Instruction{23} = 'You will now do some practice trials.\n\nPlease keep your hand on the mouse.'; 

elseif level==2 && practice==2
    Instruction{1} = 'You finished the first round of practice trials.\n\n Press the right arrow to continue with the instructions.';
    Instruction{2}= 'In the actual task, you receive points on every trial.\n\n On some trials you will receive more points and on other trials fewer points.\n\nYou can not influence how many points you receive on a trial. The number of points is independent of performance.';
    Instruction{3}= 'In the next practice round, you will practice a few trials with points.';
    if pms.patternCB==1
     Instruction{4}='\n\n\n\n\n\n\n\n\n\n\n Before every trial you will see how many points you receive.\n\n If you see a checkerboard background, you will receive 50 points per trial.';
     Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n If you see a dotted background, you will receive 10 points per trial.';
    elseif pms.patternCB==2
     Instruction{4}='\n\n\n\n\n\n\n\n\n\n\n Before every trial you will see how many points you receive.\n\n If you see a checkerboard background, you will receive 10 points per trial.';
     Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n If you see a dotted background, you will receive 50 points per trial.';
    end
    Instruction{6} = 'Please take a moment to tell your experimenter what is going to happen in this task.';
    Instruction{7} = 'You will now do some practice trials.\n\nPlease keep your hand on the mouse.';
    
elseif level==3 %&& pms.blockCB==0
    Instruction{1} = 'You finished the practice trials.\n\n Press the right arrow to continue with the instructions.';
    Instruction{2}='During the actual task, you will only see your response on the color wheel, you will not see the correct response anymore.';
    Instruction{3}=sprintf('We will split the task into %d blocks. \n\n After a block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    Instruction{4}='During the actual task, on every trial you receive points, similar to the practice trials.\n\n However, the number of points you receive per trial now depends on the block. On some blocks you will receive more points and on other blocks fewer points on a trial. \n\n You can not influence how many points you receive. The number of points is independent of performance.';
    Instruction{5}= 'After each block, you will answer a few questions about the block.';
    Instruction{6}= 'At the end of the experiment, your monetary payoff will be increased proportionally to the number of points that were accumulated.';
    Instruction{7} = 'You will now start the task.\n\nPlease look at the screen while doing the task.'; 
        
    
%elseif level==3 && pms.blockCB==1 
    %Instruction{1} = 'You finished the practice trials.\n\n Press the right arrow to continue with the instructions.';
    %Instruction{2}='During the actual memory task, you will only see your response on the color wheel, you will not see the correct response anymore.';
    %Instruction{3}=sprintf('We will split the task in %d blocks. \n\n After a block you can take a break and continue with the task when you are ready.',pms.numBlocks);
    %Instruction{4}='On most trials you can win points.';
    %Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Before every new trial you will see how many points you can win on that trial.';
    %imgReward=importdata('Rewardcue.png');
    %imageReward=Screen('MakeTexture',wPtr,imgReward);
    %Instruction{6}= 'If you are close enough to the correct color, you win the points. At the end, you will receive a bonus proportional to the total number of points you won during the experiment.';   
    %Instruction{7}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n On some trials you cannot win points.\n\nYou will then see a cross instead of a number';
    %Instruction{8} = 'You will now start the task.\n\nPlease look at the screen while doing the task.';   
    
    
elseif level==4 %&& pms.blockCB==0
    Instruction{1} = sprintf('You finished this block of the task.\n\n You received %d points on this block! \n\n\n Press the right arrow to continue with the next block.', pms.blockPoints);
    Instruction{2}= 'Before every trial of the next block, you will see how many points you receive per trial.';
    Instruction{3}= 'Good luck!';
    %Instruction{2}='On most trials in this block you can win points.';
    %Instruction{3}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Before every new trial you will see how many points you can win on that trial.';
    %imgReward=importdata('Rewardcue.png');
    %imageReward=Screen('MakeTexture',wPtr,imgReward);
    %Instruction{4}= 'If you are close enough to the correct color, you win the points. At the end, you will receive a bonus proportional to the total number of points you won during the experiment.';   
    %Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n One some trials you cannot win points.\n\nYou will then see a cross instead of a number';
    %Instruction{6}='Everything else is the same as during the first block of the task.';
    %Instruction{7} = 'Good luck!';
    
%elseif level==4 && pms.blockCB==1
    %Instruction{1} = 'You finished the first block of the task!\n\n Press the right arrow to continue with the next block.';
    %Instruction{2}='During this block you cannot win points, but everything else is the same as during the first block of the task.';
    %Instruction{3} = 'Good luck!';
   
elseif level==5 
    Instruction{1}= sprintf('This is the end of the color wheel memory task!\n Your reward for this task is %.2f euro.\n\n Please contact the researcher.', money);

elseif level==6
    if pms.taskRedo==5
        Instruction{1} = sprintf('Based on your choices, you will not redo the memory task, but you will receive %2.2f euros. \n\nPlease contact your experimentor!',pms.bonusRedo);
    else
        Instruction{1} = sprintf('Based on your choices, you will redo one round of the %s task for %2.2f euros.\n\nPlease contact your experimentor!',pms.taskNameRedo,pms.bonusRedo);
        Instruction{2} = 'Press the right arrow to start...';
    end

elseif level==7
    Instruction{1}= sprintf('This is the end of the experiment!\n Your total reward is %.2f euro.\n\n Please contact the researcher.',money);
    
end %level


% create parameters dotted background pattern
     [screenXpixels,screenYpixels]=Screen('WindowSize', wPtr); 
     %create base dot coordinates
     dim = 10;
     [x, y] = meshgrid(-dim:1:dim, -dim:1:dim); 
     %scale grid by screen size
     pixelScale = screenYpixels / (dim);
         x = x .* pixelScale;
         y = y .* pixelScale; 
     %create matrix of positions for dots 
     numDots = numel(x);
     dotPositionMatrix = [reshape(x, 1, numDots); reshape(y, 1, numDots)];

% create parameters checkerboard background pattern
     [xCenter, yCenter] = RectCenter(rect);
     %creat base rectangle
     dim = 101;
     baseRect = [0 0 dim dim]; 
     %make coordinates for grid of squares
     npatches = 9;
     [xPos, yPos] = meshgrid(-npatches:1:npatches, -npatches:1:npatches); 
     %reshape matrices of coordinates into vector
     [s1, s2] = size(xPos);
     numSquares = s1 * s2;
       xPos = reshape(xPos, 1, numSquares); 
       yPos = reshape(yPos, 1, numSquares); 
     %scale grid spacing to size of squares and centre
     xPosCenter = xPos .* dim + xCenter;
     yPosCenter = yPos .* dim + yCenter; 
     %set colors of squares
     squareColors = [255 200; 200 255];
     bwColors = repmat(squareColors, (npatches+1), (npatches+1));
     bwColors = bwColors(1:end-1, 1:end-1);
     bwColors = reshape(bwColors, 1, numSquares);
     bwColors = repmat(bwColors, 3, 1); 
     %make rectangle coordinates
     rectCenter = nan(4, 3); 
     for i = 1:numSquares 
        rectCenter(:, i) = CenterRectOnPointd(baseRect,...
            xPosCenter(i), yPosCenter(i));
     end



counter=1;

for i=1:100 
           RestrictKeysForKbCheck([37,39,40,38,32,97,98]);
    if i==1
        back=0;
    end
    if counter<length(Instruction)
        counter=counter+back;
    end
    
   if level==2 && practice==1
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
            DrawFormattedText(wPtr,Instruction{counter},'center',rect(4)*0.4,pms.textColor,pms.wrapAt,[],[],pms.spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',pms.textColor,pms.wrapAt,[],[],pms.spacing);
        end
   else
       if level==2 && practice==2 && counter==4
            Screen('FillRect', wPtr, bwColors, rectCenter);
            Screen('Textsize', wPtr, 80);
            Screen('Textfont', wPtr, 'Times New Roman');
            if pms.patternCB==1
               DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); %black reward cue
            elseif pms.patternCB==2
               DrawFormattedText(wPtr, '10', 'center', 'center', [0 0 0]); 
            end
       elseif level==2 && practice==2 && counter==5
            Screen('Drawdots', wPtr, dotPositionMatrix, pms.patternSize, WhiteIndex(max(Screen('Screens'))), [pms.xCenter pms.yCenter],2);
            Screen('Textsize', wPtr, 80);
            Screen('Textfont', wPtr, 'Times New Roman');
            if pms.patternCB==1
               DrawFormattedText(wPtr, '10', 'center', 'center', [0 0 0]); %black reward cue
            elseif pms.patternCB==2
               DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); 
            end
       end
        %if level==3 && pms.blockCB==1 && counter==5 
             %Screen('Textsize', wPtr, 34);
             %Screen('Textfont', wPtr, 'Times New Roman');
             %DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); %black reward cue
         %elseif level==3 && pms.blockCB==1 && counter==7
             %drawFixationCross(wPtr,rect);
         %elseif level==4 && pms.blockCB==0 && counter==3
             %Screen('Textsize', wPtr, 34);
             %Screen('Textfont', wPtr, 'Times New Roman');
             %DrawFormattedText(wPtr, '50', 'center', 'center', [0 0 0]); %black reward cue
         %elseif level==4 && pms.blockCB==0 && counter==5
             %drawFixationCross(wPtr,rect);    
         %end 
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
    elseif level==2 && practice==1 && counter==22
        GetClicks();
        responded = 1;
        Screen('flip',wPtr);
        WaitSecs(2);
        continue;
    elseif level==2 && practice==2 && counter==6
        responded = 0;
        GetClicks();
        responded = 1;
        Screen('flip',wPtr);
        WaitSecs(2);
        continue;
    elseif level==3 && counter==length(Instruction)
        WaitSecs(2);
        Screen('flip',wPtr);
        WaitSecs(2);
        break;  
    elseif level==4 && counter==length(Instruction)
        WaitSecs(2);
        break; 
    elseif level==5 && counter==length(Instruction)
        GetClicks();
        WaitSecs(2);
        break;   
    elseif level==7 && counter==length(Instruction)
        GetClicks();
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
end %for i=1:100
RestrictKeysForKbCheck([]);

end 




