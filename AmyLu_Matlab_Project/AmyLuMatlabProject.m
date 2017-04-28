clc;
close all
clear all
sca
%%
PTB_Flag=1; % 1 为打开 PTB 0 为 关闭 (调试用，在PTB不正常的情况下 调试其他功能)
VolunteerName='AmyLuA'; 
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
%% PTB工具初始化
if(PTB_Flag==1)
    PsychDefaultSetup(2);
    Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 GBK
    Screen('Preference', 'SkipSyncTests', 1)    % 跳过检查
    screenGrps=Screen('Screens');   % 初始化 屏幕
    screenNumber=max(screenGrps);  % Select the external screen if it is present, else revert to the native
    Color_black = BlackIndex(screenNumber); % 得到黑色屏幕的颜色数值
    Color_white = WhiteIndex(screenNumber);
    Color_grey = Color_white / 2;
    %[window,rect] = Screen('OpenWindow', screenid,Color_black);  % PsychImaging
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    Picture_Read_TargetArea= imread(Picture_TargetArea);
    Picture_Read_Wait_5s= imread(Picture_Wait_5s);
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea);
    PTB_IMG_Wait_5s=Screen('MakeTexture',window ,Picture_Read_Wait_5s);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, 50);
    Screen('TextFont', window, 'simhei'); 
end
%% 主循环函数
for Main_Index=1:length(Video_Name_C)    % 设置循环
    Temp=Random_Series(Main_Index);  % 读取随机数列的值
    Temp_Number=Video_Name_C(Temp,1);       % 读取序号
    Temp_VideoName=Video_Name_C(Temp,2);    % 读取文件名
    Temp_CarCode=Video_Name_C(Temp,3);      % 读取车牌号
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % 得到完整的视频文件路径
    %播放提示视频
    %播放视频
    if(PTB_Flag==1)
        % 题目
        Screen('DrawTexture', window ,PTB_IMG_Wait_5s);
        Screen('Flip',window);
        WaitSecs(4);
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(1);
        [ssss] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',ssss, 1);
        while (1) % 逐帧播放视频
            tex = Screen('GetMovieImage', window, ssss); % 获得一帧视频图像
            if tex<=0 %判断视频是否已经读取完
                break
            end
            %更新画面
            Screen('DrawTexture', window, tex);% 绘制图像
            Screen('Flip', window);% 更新显示
            Screen('Close', tex);% 释放视频资源
        end
    end
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
    % Draw text in the middle of the screen in Courier in white
    if(PTB_Flag==1)
        DrawFormattedText(window, double('请使用键盘输入正确选择前的序号:'), 'center', screenYpixels * (1/7), Color_white); % window,文字,X坐标，Y坐标，颜色
        for i=1:AnswerNum
            DrawFormattedText(window, double([' ',num2str(i),'  ',char(CarCodeChoose(1,PTB_Display_Index(i)))]), 'center', screenYpixels * (1/7)*(i+2), Color_white);
        end
        Screen('Flip', window);% 更新显示
    end
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
    disp(['-->第',num2str(Main_Index),'个选项用户回答正确与否: ',num2str(Temp_Anwser),'( 1 正确 0 错误)'])
    keyIsDown=0;
    %记录函数
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %记录序号
    OutPut_Cell(Main_Index,2)=Temp_Number;   %记录原始序号
    OutPut_Cell(Main_Index,3)=Temp_VideoName;%记录视频文件名
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %记录车牌号
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Anwser); %记录回答正误
end
%% 
DrawFormattedText(window, [double('感谢参与本次测试'),double('本次测试到此结束！'),double('谢谢，祝您愉快！')], 'center', 'center', Color_white);
Screen('Flip', window);% 更新显示
WaitSecs(5);
sca % 关闭屏幕
OutPut_Cell
xlswrite(Excel_OUTPUT_FileName, {'序号','原始DATA序号','视频文件名','车牌号','回答正误(1为正确,0为错误)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, 'A2:E21')
%xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName)