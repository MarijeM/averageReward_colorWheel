function getInstructionsChoice(level,pms,wPtr)
%%%This function provides the insturctions for the
%%%Quantifying cognitive control experiment. As inputs it receives level (1=memory, 2=discounting),
%%encTime is the time they have to memorize squares during encoding and
%%maxRT the time they have to respond using the colorwheel.


% % Priority(1); %Give matlab/PTB processes high priority
HideCursor;
% level=1;
% encTime=2;
% maxRT=4;
% open an onscreen window
% Screen('Preference','SkipSyncTests',1);
% Screen('Preference', 'SuppressAllWarnings', 1);
% [wPtr]=Screen('Openwindow',max(Screen('Screens')));

%% Centering

%screenWidth = rect(3);
%screenHeight = rect(4);
%screenCenterX = screenWidth/2;
%screenCenterY = screenHeight/2;

%% Define which text style to use for instructions

%         Screen('TextSize',wPtr, 32);            %determine size of text
%         Screen('TextFont',wPtr, 'Helvetica');   %Which font has the text
%         Screen('TextStyle',wPtr, 1);
% wid = 10;
textCol = [0 0 0];
wrptx = 75;
spacing = 2.5;
Screen('TextSize',wPtr,23);
Screen('TextStyle',wPtr,1);
Screen('TextFont',wPtr,'Times New Roman');

%% Show first instructions with Screen('DrawText',wPtr,text,x,y,color)
%Add text that should appear

if level == 2
    Instruction{1} = 'Welcome to the choice task!\n You can walk through the instructions by using the left and right arrow keys.\n Press the right arrow to start...';
    Instruction{2} = 'During this part you can win a bonus by redoing the color wheel task. However, the difficulty of the redo and the amount of the bonus will be based on choices that you will make now.';
    Instruction{3}='You also have the opportunity to avoid doing the redo completely. The No Redo option means that you can use the remaining time as you please in this room, using the computer, your phone etc.';
    imgIgnore4=imread('ChoiceIgnore4.png');
    imageIgnore4=Screen('MakeTexture',wPtr,imgIgnore4);
    Instruction{4}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Example: Would you rather receive 2 euros to redo Ignore(I) trials of 4 squares OR 60 cents for not doing a redo?';
    imgUpdate1=imread('ChoiceUpdate1.png');
    imageUpdate1=Screen('MakeTexture',wPtr,imgUpdate1);
    Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Example 2: Would you rather receive 2 euros to redo Update(U) trials of 1 square OR 1 euro for not doing a redo?';
    Instruction{6} = sprintf('To select the left option, press 1 and for the right option press 2. You will have %d seconds to respond.',pms.maxRT);
    imgChoiceMade=imread('ChoiceMade.png');
    imageChoiceMade=Screen('MakeTexture',wPtr,imgChoiceMade);
    Instruction{7}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n A square is shown to indicate that your choice has been made';
    Instruction{8}='Press any key to start practice for these trials';

elseif level==3
    Instruction{1}= 'You will make many similar choices. One of them will be selected and you will redo the colorwheel task based on that choice. 70% of all the trials you will do will consist of that choice and 30% will be random.';
    Instruction{2}= 'You will receive the bonus if your performance during the redo is similar to your performance the first time you did the colorwheel task. That means that to earn the bonus you need to put effort in doing the task, but not that you always have to be accurate.';
     imgChoiceMadeExample1=imread('ChoiceMadeExample1.png');
     imageChoiceMadeEx1=Screen('MakeTexture',wPtr,imgChoiceMadeExample1);
    Instruction{3}= '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n For example, if this choice will be selected you will redo mostly Update 1 and you will earn 2 euros.';
   imgChoiceExample2=imread('ChoiceMadeExample2.png');
    imageChoiceMadeEx2=Screen('MakeTexture',wPtr,imgChoiceExample2);
    Instruction{4}= '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n If this choice will be selected you will not have to redo the colorwheel task and you will earn 1.40 euros.';
    Instruction{5}= 'Do not rush your answers. It is very important that you think of both the money and your experience of doing the specific trials of the task (i.e. number of squares and Ignore (I) / Update (U) condition).';
    Instruction{6}= 'We would like you to answer according to your true preference, there is no correct or wrong answer.';    
    Instruction{7}= 'Please contact the researchers, they will start the task when all questions are addressed.';
    
elseif level==4
    Instruction{1} = 'You finished the instructions.\n\n You may now proceed with the actual task.';
    Instruction{2}=sprintf('We split the task in %d blocks. \n\n After every block you can take a break or continue with the task.', pms.numBlocks);
    Instruction{3}= 'Good luck!';
    
elseif level==5
    Instruction{1}='This was the end of the choice task!';
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
        
        % Exceptions for figures;
        
        if counter==3
            Screen('DrawTexture',wPtr,imageChoice)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        elseif counter==3
            Screen('DrawTexture',wPtr,imageChoiceMade)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        end
        
    elseif level==2
        if counter==4
            Screen('DrawTexture',wPtr,imageIgnore4)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==5
            Screen('DrawTexture',wPtr,imageUpdate1)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==7
            Screen('DrawTexture',wPtr,imageChoiceMade)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        end
        
    elseif level==3
        if counter==3 
             Screen('DrawTexture',wPtr,imageChoiceMadeEx1)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        elseif counter==4
 
            Screen('DrawTexture',wPtr,imageChoiceMadeEx2)
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        else
            DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
            
        end
        
    elseif  level==4 || level==5
        
        DrawFormattedText(wPtr,Instruction{counter},'center','center',textCol,wrptx,[],[],spacing);
        
    end
    Screen('flip',wPtr);
    
    
    if level==3 && counter==length(Instruction)
        GetClicks()
        break
    elseif counter==length(Instruction)
        KbWait();
        break
    else 
        KbWait();    
    end
    
      

    
    
%     KbWait()
%     if counter==length(Instruction)
%         break
%     end
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




