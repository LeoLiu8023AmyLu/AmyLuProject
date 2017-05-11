clc;close all;clear all;
Screen('Preference','TextEncodingLocale','UTF-8');
Screen('Preference', 'SkipSyncTests', 1)
screenGrps=Screen('Screens');
screenid=max(screenGrps);
[win,rect] = Screen('OpenWindow', screenid,0);
%% 所用图片
filename1='F:\shipin\start.jpg';
filename2='F:\shipin\choose1.jpg';
filename3='F:\shipin\choose2.jpg';
filename4='F:\shipin\ten.jpg';
imim1= imread( filename1);
imim2= imread( filename2);
imim3= imread( filename3);
imim4= imread( filename4);
opim1=Screen('MakeTexture',win ,imim1);
opim2=Screen('MakeTexture',win ,imim2);
opim3=Screen('MakeTexture',win ,imim3);
opim4=Screen('MakeTexture',win ,imim4);
feelmat=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

% 题目
Screen('DrawTexture', win ,opim1);
Screen('Flip',win);
WaitSecs(5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(5);

%% 开始1
filename = 'F:\123\gaoxing1.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose1
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,1)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,1)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,1)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,1)=4;
else
    feelmat(1,1)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,2)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,2)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,2)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,2)=4;
else
    feelmat(1,2)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(10);

%% 开始2
filename = 'F:\123\kongju1.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose2
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,3)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,3)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,3)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,3)=4;
else
    feelmat(1,3)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,4)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,4)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,4)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,4)=4;
else
    feelmat(1,1)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(10);

%% 开始3
filename = 'F:\123\fennu1.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose3
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,5)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,5)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,5)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,5)=4;
else
    feelmat(1,5)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,6)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,6)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,6)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,6)=4;
else
    feelmat(1,6)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(10);

%% 开始4
filename = 'F:\123\beishang1.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose4
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,7)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,7)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,7)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,7)=4;
else
    feelmat(1,7)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,8)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,8)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,8)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,8)=4;
else
    feelmat(1,8)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(10);

%% 开始5
filename = 'F:\123\pingjing1.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose5
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,9)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,9)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,9)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,9)=4;
else
    feelmat(1,9)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,10)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,10)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,10)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,10)=4;
else
    feelmat(1,10)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(20);

%% 开始6
filename = 'F:\123\fennu2.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose6
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,11)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,11)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,11)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,11)=4;
else
    feelmat(1,11)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,12)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,12)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,12)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,12)=4;
else
    feelmat(1,12)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(60);

%% 开始7
filename = 'F:\123\gaoxing2.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose7
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,13)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,13)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,13)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,13)=4;
else
    feelmat(1,13)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,14)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,14)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,14)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,14)=4;
else
    feelmat(1,14)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(60);

%% 开始8
filename = 'F:\123\pingjing2.mp4';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose8
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,15)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,15)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,15)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,15)=4;
else
    feelmat(1,15)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,16)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,16)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,16)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,16)=4;
else
    feelmat(1,16)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(60);

%% 开始9
filename = 'F:\123\kongju2.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose9
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,17)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,17)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,17)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,17)=4;
else
    feelmat(1,17)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,18)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,18)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,18)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,18)=4;
else
    feelmat(1,18)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim4);
Screen('Flip',win);
WaitSecs(60);

%% 开始10
filename = 'F:\123\beishang2.avi';
[ssss] = Screen('OpenMovie', win,filename);
Screen('PlayMovie',ssss, 1);
while (1)
    %
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, ssss);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end;
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end;

%% choose10
Screen('DrawTexture', win ,opim2);
 Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,19)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,19)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,19)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,19)=4;
else
    feelmat(1,19)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawTexture', win ,opim3);
Screen('Flip',win);
[keyIsDown, ~, keyCode, ~]=KbCheck;
while(keyIsDown==0)
    [keyIsDown, ~, keyCode, ~]=KbCheck;
end
if (keyCode(1,49)==1)
    feelmat(1,20)=1;
elseif (keyCode(1,50)==1)
    feelmat(1,20)=2;
elseif (keyCode(1,51)==1)
    feelmat(1,20)=3;
elseif (keyCode(1,52)==1)
    feelmat(1,20)=4;
else
    feelmat(1,20)=5;
end
keyIsDown=0;
WaitSecs(0.5);
Screen('DrawText', win,'Tkanks for you help^_^', 400, 200, [66 204 255]);
Screen('Flip',win);
WaitSecs(10);

%% end
Screen('closeall')