clc;
close all
clear all
PsychDefaultSetup(2);
Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ UTF-8
Screen('Preference', 'SkipSyncTests', 1);    % �������
screenGrps=Screen('Screens');   % ��ʼ�� ��Ļ
screenNumber=max(screenGrps);  % ѡ���Ҫ Ͷ����ʾ��
Color_black = BlackIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_white = WhiteIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_grey = Color_white / 2; % �õ���ɫ��Ļ����ɫ��ֵ
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % ��õ�ǰ��Ļ����Ļ�������Ϣ
    [screenXpixels, screenYpixels] = Screen('WindowSize', window); % �����Ļ�ߴ�
    [xCenter, yCenter] = RectCenter(windowRect); % �����������
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, 100);
    Screen('TextFont', window, 'simhei'); 
    
    %% ��Ƶ����
    VideoFileName='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\MovieDemos\DualDiscs.mov'
        [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',Car_MoviePtr, 5); % ����ӰƬ���ŵ��ǵ��������� 0 ������ 1 �����ٶȲ��� -1 �����ٶȵ���
        while (1) % ��֡������Ƶ
            Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
            Movie_IMG_Temp
            if Movie_IMG_Temp<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                break
            end
            %���»���
            Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
        end
        Screen('CloseMovie', Car_MoviePtr);
        sca