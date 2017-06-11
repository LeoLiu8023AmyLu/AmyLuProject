clc;
close all
clear all
PsychDefaultSetup(2);
Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 UTF-8
Screen('Preference', 'SkipSyncTests', 1);    % 跳过检查
screenGrps=Screen('Screens');   % 初始化 屏幕
screenNumber=max(screenGrps);  % 选择次要 投放显示器
Color_black = BlackIndex(screenNumber); % 得到黑色屏幕的颜色数值
Color_white = WhiteIndex(screenNumber); % 得到白色屏幕的颜色数值
Color_grey = Color_white / 2; % 得到灰色屏幕的颜色数值
[window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % 获得当前屏幕与屏幕的相关信息
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % 获得屏幕尺寸
[xCenter, yCenter] = RectCenter(windowRect); % 获得中心坐标
% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('TextSize', window, 80);
Screen('TextFont', window, 'simhei'); 
    
%% 视频播放
VideoFileName='E:\workspace\AmyLuProject\AmyLu_Matlab_Project\video\Fade.mp4';

for speed=0.5:0.5:10
speed
[Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
Screen('PlayMovie',Car_MoviePtr, speed); % 控制影片播放的是第三个参数 0 不播放 1 正常速度播放 -1 正常速度倒放

while (1) % 逐帧播放视频
    Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % 获得一帧视频图像
    if Movie_IMG_Temp<=0 %判断视频是否已经读取完
        break
    end
	%更新画面
    Screen('DrawTexture', window, Movie_IMG_Temp);% 绘制图像
	DrawFormattedText(window, double(['速度:',num2str(speed/10.0),' m/s']), 'center', screenYpixels/8, Color_white); % window,文字,X坐标，Y坐标，颜色
    Screen('Flip', window);% 更新显示
    Screen('Close', Movie_IMG_Temp);% 释放视频资源
end
WaitSecs(1); % 屏幕等待时间
Screen('CloseMovie', Car_MoviePtr);
end
sca