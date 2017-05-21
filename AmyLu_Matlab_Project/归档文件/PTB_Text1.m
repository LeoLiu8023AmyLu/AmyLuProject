% Clear the workspace and the screen
close all;
clearvars;
sca

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');
Screen('Preference', 'SkipSyncTests', 1)    % 跳过检查
% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Draw text in the upper portion of the screen with the default font in red
%Screen('TextSize', window, 70);
%DrawFormattedText(window, 'Hello World', 'center',screenYpixels * 0.25, [1 0 0]);

% Draw text in the middle of the screen in Courier in white
%Screen('TextSize', window, 80);
%Screen('TextFont', window, 'Courier');
%DrawFormattedText(window, 'Hello World', 'center', 'center', white);

% Draw text in the bottom of the screen in Times in blue
%Screen('TextSize', window, 90);
%Screen('TextFont', window, 'Times');
%DrawFormattedText(window, 'Hello World', 'center',screenYpixels * 0.75, [0 0 1]);
AnswerNum=3;
% 数据初始化
FolderPath='E:\AmyLu_Matlab_Project\';	% 变更文件地址
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
Picture_TargetArea=[FolderPath,'target_area.jpg'];
Picture_Wait_5s=[FolderPath,'5swait.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,'A2:C21');  % 获得表格中的数据
Video_Name_C=RAW; % 文件交换 Video_Name_C(行号,列号) 引索由1开始
% Video_Name_C(N,1) 序号
% Video_Name_C(N,2) 文件名
% Video_Name_C(N,3) 车牌号
CarCodeAll=unique(Video_Name_C(:,3))
Random_Series=randperm(length(Video_Name_C));   % 生成随机数列
OutPut_Cell={}; % 输出的初始化


Screen('TextSize', window, 50);
Screen('TextFont', window, 'SimHei'); 

for n=1:length(Video_Name_C)    % 设置循环
    Temp=Random_Series(n);  % 读取随机数列的值
    Temp_Number=Video_Name_C(Temp,1);       % 读取序号
    Temp_VideoName=Video_Name_C(Temp,2);    % 读取文件名
    Temp_CarCode=Video_Name_C(Temp,3);      % 读取车牌号
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % 得到完整的视频文件路径
WaitSecs(2);
    %% 选择答案   【生成选择】->【显示选择】->【获取键盘按钮】->【判断对错】
    %Temp_Anwser=unidrnd(2)-1;    % 目前先用随机数生成 答案对错
    Temp_CarCode_Index=find(strcmp(CarCodeAll,Temp_CarCode)==0);
    Random_CarCode_Index=randperm(length(Temp_CarCode_Index));
    CarCodeChoose={};
    keyIsDown=0;
    for i=1:AnswerNum
        if (i==1)
            CarCodeChoose(1,i)=Temp_CarCode;
        else
            CarCodeChoose(1,i)=CarCodeAll(Temp_CarCode_Index(Random_CarCode_Index(i-1)));
        end
    end
    PTB_Display_Index=randperm(AnswerNum);
	DrawFormattedText(window, '请键盘输入正确选择前的序号:', 'center', screenYpixels * (1/7), white); % [window,文字,X坐标，Y坐标，颜色]
	for i=1:AnswerNum
    		DrawFormattedText(window, [' ',num2str(i),'  ',CarCodeChoose(1,PTB_Display_Index(i))], 'center', screenYpixels * (1/7)*(i+2), white);
	end
Screen('Flip', window);% 更新显示
RightAnswer=find(PTB_Display_Index==1);
    %键盘输入
    [keyIsDown, ~, keyCode, ~]=KbCheck;
    while(keyIsDown==0)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
    end
    % 49 对应键盘值 1 
    if (keyCode(1,49+(RightAnswer-1))==1)
        Temp_Anwser=1;
    else
        Temp_Anwser=0;
    end
    disp(['-->选项正确与否: ',num2str(Temp_Anwser)])
    keyIsDown=0;
    %记录函数
    OutPut_Cell(n,1)=num2cell(n);   %记录序号
    OutPut_Cell(n,2)=Temp_Number;   %记录原始序号
    OutPut_Cell(n,3)=Temp_VideoName;%记录视频文件名
    OutPut_Cell(n,4)=Temp_CarCode;  %记录车牌号
    OutPut_Cell(n,5)=num2cell(Temp_Anwser); %记录回答正误
end

% Flip to the screen
%Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;

% Clear the screen
sca;