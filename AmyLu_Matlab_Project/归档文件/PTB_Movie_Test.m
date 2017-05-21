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
Screen('TextSize', window, 80);
Screen('TextFont', window, 'simhei'); 
    
%% ��Ƶ����
VideoFileName='E:\workspace\AmyLuProject\AmyLu_Matlab_Project\video\01-0075.mp4';

for speed=0.5:0.5:10
speed
[Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
Screen('PlayMovie',Car_MoviePtr, speed); % ����ӰƬ���ŵ��ǵ��������� 0 ������ 1 �����ٶȲ��� -1 �����ٶȵ���

while (1) % ��֡������Ƶ
    Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
    if Movie_IMG_Temp<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
        break
    end
	%���»���
    Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
	DrawFormattedText(window, double(['�ٶ�:',num2str(speed/10.0),' m/s']), 'center', screenYpixels/8, Color_white); % window,����,X���꣬Y���꣬��ɫ
    Screen('Flip', window);% ������ʾ
    Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
end
WaitSecs(1); % ��Ļ�ȴ�ʱ��
Screen('CloseMovie', Car_MoviePtr);
end
sca