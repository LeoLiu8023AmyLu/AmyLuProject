clc;close all;clear all;
% function MovieTest
% Most simplistic demo on how to play a movie.
%
% SimpleMovieDemo(moviename);
%
% This bare-bones demo plays a single movie whose name has to be provided -
% including the full filesystem path to the movie - exactly once, then
% exits. This is the most minimalistic way of doing it. For a more complex
% demo see PlayMoviesDemoOSX. The remaining demos show even more advanced
% concepts like proper timing etc.
%
% The demo will play our standard DualDiscs.mov movie if the 'moviename' is
% omitted.
%
% Movieplayback works on Mac OS/X, and on MS-Windows if you install
% Quicktime-7 or later, which is available as a free download from Apple.
%

% History:
% 2/5/2009  Created. (MK)

% Check if Psychtoolbox is properly installed:

tic;
%将声音存放路径保存到变量

waveFile='F:\Stimuli\A\';
movieFile1='F:\Stimuli\AV\';
movieFile2='F:\Stimuli\V\';
imageFile='F:\Stimuli\image\';
% load avi_wav;%aviwav
L=1;
T=0.45;%the time to lead in
movieNum=L;
waveNum=L;
result=zeros(1,3*L);
KbName('UnifyKeyNames');
esckey = KbName('ESCAPE');
allstr='AAAA';
crosstime=[0.20 0.22 0.24 0.26 0.28 0.30];%'+' display time
section=0;%section num, repeat recording for 5 section;
% Wait until user releases keys on keyboard:
% KbReleaseWait;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % config_io;
% % outp(hex2dec('C0C0'),0);
% % AssertOpenGL;
% % setnum=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select screen for display of movie:

screenGrps=Screen('Screens');
screenid=max(screenGrps);
color=[255 255 255];

try
    ListenChar(2);
    % Open fullscreen window on screen, with black [0] background color:
    [win,rect] = Screen('OpenWindow', screenid,0);
    vbl=Screen('Flip',win);
    Screen('TextColor', win, color);%WhiteIndex(win)
    
    InitializePsychSound;
    nrchannels=2;
    % Open movie and wave file:
    seq=[zeros(1,movieNum*2),ones(1,waveNum)];%0值播放视频，1播放声音
    stimulus=cell(1,movieNum*2+waveNum);
    imdata=cell(1,movieNum*2+waveNum);
%     for i=1:movieNum
%         %         stimulus{i} = Screen('OpenMovie', win, [movieFile1,'avn',num2str(i),'.avi']);
%         imdata{i}=imread([imageFile,'image',num2str(i),'.jpg']);
%         %         stimulus{i+movieNum} = Screen('OpenMovie', win, [movieFile2,'vn',num2str(i),'.avi']);
%         imdata{i+movieNum}=imread([imageFile,'image',num2str(i),'.jpg']);
%     end
    for i=(movieNum*2+1):length(stimulus)
        %把第i个声音文件读入到内存
        
        [Wav,Fs]=wavread([waveFile,'wn',num2str(i-movieNum*2),'.wav']);
        [samplecount, ninchannels] = size(Wav);
        Wav = repmat(transpose(Wav), nrchannels / ninchannels, 1);
        stimulus{i} =PsychPortAudio('CreateBuffer', [], Wav);
        imdata{i}=imread([imageFile,'image0.jpg']);
    end
  
    %设置声卡；
%     pahandle = PsychPortAudio('Open',17, [], 3, Fs, nrchannels);%[], [], 0
    pahandle = PsychPortAudio('Open', [], [], 0, Fs, nrchannels);
%     pahandle = PsychPortAudio('Open', 7, [], 2, Fs, nrchannels);
    %设置随机序列
    randomSeq=randperm(movieNum*2+waveNum);
    seq=seq(randomSeq);
    stimulus=stimulus(randomSeq);
    aviwavseq=aviwav(randomSeq,:);
    imdataseq=imdata(randomSeq);
    save('randomSeq','randomSeq');
    %begin
    Screen('TextSize',win,35);
    Screen('DrawText', win,'点击鼠标后，开始测试...', 200, 350, [255 255 255]);
    Screen(win, 'Flip');
    [clicks,x,y,whichButton] = GetClicks;
    while(x==0||y==0)
        [clicks,x,y,whichButton] = GetClicks;
    end
    HideCursor;%hide cursor of mouse
    %broadcast
    for i=1:150 %(movieNum*2+waveNum)
        
        %for "+" displays crosstime at random;
        randtime=randperm(length(crosstime));
        Screen('TextSize',win,35);
        DrawFormattedText(win, '+', 'center','center');
        Screen('Flip', win);
        WaitSecs(crosstime(randtime(1)));
        %for Auditory test
        if seq(i)==1
            %           %for 450ms to lead in
            DrawFormattedText(win, ' ', 'center','center');
            Screen('Flip', win);
            WaitSecs(T);
            %Auditory play
            DrawFormattedText(win, ' ', 'center','center');
            Screen('Flip', win);
            
            PsychPortAudio('UseSchedule', pahandle, 2);
            PsychPortAudio('AddToSchedule', pahandle, stimulus{i}, 1);
            PsychPortAudio('UseSchedule', pahandle, 3);
% %                         outp(hex2dec('C0C0'),3);%set 3 for An
            PsychPortAudio('Start', pahandle, [], 0, [],[],1);
% %                         outp(hex2dec('C0C0'),0);
            WaitSecs(0.667);%??
        else
            %vedio play
            if randomSeq(i)>=1&&randomSeq(i)<=250  %for AVn vedio
                stimulus{i} = Screen('OpenMovie', win, [movieFile1,'avn',num2str(randomSeq(i)),'.avi']);
                setnum=1;%outp set 1 for AVn
            elseif randomSeq(i)>=251&&randomSeq(i)<=500  %for Vn vedio
                stimulus{i} = Screen('OpenMovie', win, [movieFile2,'vn',num2str(randomSeq(i)-250),'.avi']);
                setnum=2;%set 2 for Vn
            end
            %for 450ms to lead in
            tex=Screen('MakeTexture', win, imdataseq{i});
            Screen('DrawTexture', win, tex);
            Screen('Flip', win);
            WaitSecs(T);
            Screen('Close', tex);
            % Start playback engine:
% %                         outp(hex2dec('C0C0'),setnum);
            Screen('PlayMovie', stimulus{i}, 1);
% %                         outp(hex2dec('C0C0'),0);
            % Playback loop: Runs until end of movie or keypress:
            while (1)
                %
                % Wait for next movie frame, retrieve texture handle to it
                tex = Screen('GetMovieImage', win, stimulus{i});
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
%             outp(hex2dec('C0C0'),5);
            % Stop playback:
            Screen('PlayMovie', stimulus{i}, 0);
%             outp(hex2dec('C0C0'),0);
            % Close movie:
            Screen('CloseMovie', stimulus{i});
        end
        
        %make a response
        ShowCursor;%show cursor of mouse
        str = displaytest(rect,win);
        allstr=[allstr;str;];
        %for 30 trials to have a rest
        if mod(i,30)==0
            section=section+1;
            Screen('TextSize',win,35);
            if mod(section,5) ==0
                Screen('DrawText', win,['Section' num2str(section) '结束,请重新记录数据'], 100, 300, [255 255 255]);
                Screen('DrawText', win,'稍作休息后，进入下一阶段测试...', 100, 400, [255 255 255]);
                Screen(win, 'Flip');
            else
                Screen('DrawText', win,'稍作休息后，点击鼠标继续测试...', 100, 350, [255 255 255]);
                Screen(win, 'Flip');
            end
            [clicks,x,y,whichButton] = GetClicks;
            while(x==0||y==0)
                [clicks,x,y,whichButton] = GetClicks;
            end
        end
        
        HideCursor;%hide cursor of mouse
        %black window for 1000ms
        Screen('DrawText', win,' ', 200, 300, [255 255 255]);
        Screen('Flip', win);
        WaitSecs(1);
        
    end
    
    % Close Screen, we're done:
    ListenChar(0);
    %关闭声音设备
    PsychPortAudio('Stop', pahandle);
    %         Close the audio device:
    PsychPortAudio('Close', pahandle);
    Screen('CloseAll');
    
    allstr1=allstr;
    save('resultall_1','allstr1');
    
catch
%     ListenChar(0);
    Screen('CloseAll');
%     psychrethrow(psychlasterror);
%     sca;
end
toc
% return;
