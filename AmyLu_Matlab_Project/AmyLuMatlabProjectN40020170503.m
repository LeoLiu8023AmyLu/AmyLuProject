clc;
close all
clear all
%% 设置部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为程序控制部分     你要设置的
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 1; % 1 为打开 PTB 0 为 关闭 (调试用，在PTB不正常的情况下 调试其他功能)
Log_Flag = 1; % 1 为打开 Log 0 为 关闭 (调试用，输出运行中的记录)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为初始化设置部分   你要设置的 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='C:\Users\Amy Lu\Desktop\AmyLu_Matlab_Project\';	% 变更文件地址
VolunteerName='LeoLiu';  % 测试者姓名
Excel_Start=2;  % Excel 开始行数
Excel_End=21;   % Excel 结束行数
CarCode_Change_Num=3;   % 车牌发生变化的位数 最大是 5
CarCode_Char_Offset=7;  % 最小值为 5  最大值可以无限大 (已经做了处理)
Play_Rate = 1; % 播放方式 0 不播放  1 正常速度播放 -1 正常速度倒放【目前无法倒序播放】
PTB_Text_Size=100;%调节字体大小
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 设置输出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    disp(['-->志愿者姓名： ',VolunteerName])
    disp(['-->读取数据数量： ',num2str((Excel_End-Excel_Start+1))])
    disp(['-->车牌变化位数： ',num2str(CarCode_Change_Num)])
    disp(['-->字符偏移量：',num2str(CarCode_Char_Offset)])
    
    
end
%% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(PTB_Flag==1)
    sca
%     Key_y=KbName('y');
%     Key_n=KbName('n');

end
Cross_Wait_Time=[0.22 0.24 0.26 0.28 0.3];
Data_Num=Excel_End-Excel_Start+1;
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
Picture_TargetArea=[FolderPath,'target_area.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,['A',num2str(Excel_Start),':','C',num2str(Excel_End)]);  % 获得表格中的数据
Video_Name_C=RAW; % 文件交换 Video_Name_C(行号,列号) 引索由1开始
% Video_Name_C(N,1) 序号
% Video_Name_C(N,2) 文件名
% Video_Name_C(N,3) 车牌号
CarCodeAll=unique(Video_Name_C(:,3));
Random_Series=randperm(length(Video_Name_C));   % 生成随机数列
OutPut_Cell={}; % 输出的初始化
%% PTB工具初始化
if(PTB_Flag==1)
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
    Picture_Read_TargetArea= imread(Picture_TargetArea); % 读取 十字 的图片
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, PTB_Text_Size);
    Screen('TextFont', window, 'simhei'); 
    DrawFormattedText(window, double('请观察图片中车牌号\n与视频中车牌号是否一致\n一致按<-- 不一致按-->\n按任意键开始测试'), 'center','center', Color_white); % 显示文字
    Screen('Flip', window);% 更新显示
    Key_right=KbName('RightArrow');
    Key_left=KbName('LeftArrow');
    %按下任意键开始
    keyIsDown=0;
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
        if (keyIsDown==1)
            break
        end
    end
end
%% 主循环函数
for Main_Index=1:length(Video_Name_C)    % 设置循环
    %% 获取视频信息
    Temp=Random_Series(Main_Index);  % 读取随机数列的值
    Temp_Number=Video_Name_C(Temp,1);       % 读取序号
    Temp_VideoName=Video_Name_C(Temp,2);    % 读取文件名
    Temp_CarCode=Video_Name_C(Temp,3);      % 读取车牌号
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % 得到完整的视频文件路径
    Flag_Change_Random=unidrnd(2)-1; % 随机生成 0 或 1 
    %% 変更车牌信息 
    if (Flag_Change_Random==1) % 改变显示的车牌内容
    CarCode_Mask_Middle=[ones(1,CarCode_Change_Num) zeros(1,(5-CarCode_Change_Num))]; % 制作5位的变化位遮罩数组 [ 1 1 1 0 0 ] 1 代表变化，0 不变化
        CarCode_Mask_Middle_Size = length(CarCode_Mask_Middle); % 得到遮罩数组长度
        CarCode_Mask_Middle(randperm(CarCode_Mask_Middle_Size)) = CarCode_Mask_Middle(1:1:CarCode_Mask_Middle_Size); % 遮罩数组随机排序
        CarCode_Mask=[0 CarCode_Mask_Middle 0];  % 遮罩数组补全车牌的 7 位
        Text_Offset_Random=randperm(CarCode_Char_Offset); % 生成5位的 各个字符偏移量 数组
        CarCode_Text_Offset_SQ=[0 Text_Offset_Random(1:5) 0]; % 补全为7位
        CarCode_Text_Offset=CarCode_Text_Offset_SQ.*CarCode_Mask; % 与遮罩数组相乘得到最后的随机字符偏移数组
        Temp_CarCode_Char=char(Temp_CarCode); % 由 cell 格式 转变为 char 格式
        for CarChange_Index=1:7 % 循环处理每一个字符        
            Temp_Text=[]; % 初始化
            Temp_Text(1,1)=Temp_CarCode_Char(CarChange_Index)+CarCode_Text_Offset(CarChange_Index); % + 字符偏移
            Temp_Text(1,2)=Temp_CarCode_Char(CarChange_Index)-CarCode_Text_Offset(CarChange_Index); % - 字符偏移
            Temp_Text(1,3)=Temp_CarCode_Char(CarChange_Index)+floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1); % + 字符偏移 (1~5)
            Temp_Text(1,4)=Temp_CarCode_Char(CarChange_Index)-floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1); % - 字符偏移 (1~5)
            for i=1:length(Temp_Text) %判断是否可以操作
                if((Temp_Text(1,i)>=65 && Temp_Text(1,i)<=90)||(Temp_Text(1,i)>=97 && Temp_Text(1,i)<=122)||(Temp_Text(1,i)>=48 && Temp_Text(1,i)<=57))
                    Temp_CarCode_Char(CarChange_Index)=Temp_Text(1,i); % 赋值到临时字符串
                    break % 打断循环 发现满足条件的情况 就跳出循环
                end
            end
        end
        Display_CarCode=Temp_CarCode_Char;
    else % 不改变显示的车牌内容
        Display_CarCode=Temp_CarCode;
    end
    if(Log_Flag==1)
        % 显示 打印
        disp(['-->原始车牌：',char(Temp_CarCode),'是否改变：',num2str(Flag_Change_Random),' ( 1 改变 0 不改变)'])
        disp(['-->改变后车牌：',char(Display_CarCode)])
    end
    %% 显示文字 及 播放视频
    if(PTB_Flag==1)
        %% 显示定位
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(Cross_Wait_Time(unidrnd(5)));
        %% 显示车牌
        % DrawFormattedText(window, double('请观察下列车牌号:'), 'center', screenYpixels * (2/7), Color_white); % 显示文字
        DrawFormattedText(window, double(char(Display_CarCode)), 'center', 'center', Color_white); % 显示车牌
        Screen('Flip',window);
        WaitSecs(0.2);
        %% 视频播放
        [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',Car_MoviePtr, Play_Rate); % 控制影片播放的是第三个参数 0 不播放 1 正常速度播放 -1 正常速度倒放
        while (1) % 逐帧播放视频
            Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % 获得一帧视频图像
            Movie_IMG_Temp
            if Movie_IMG_Temp<=0 %判断视频是否已经读取完
                break
            end
            %更新画面
            Screen('DrawTexture', window, Movie_IMG_Temp);% 绘制图像
            Screen('Flip', window);% 更新显示
            Screen('Close', Movie_IMG_Temp);% 释放视频资源
        end
        Screen('CloseMovie', Car_MoviePtr);
    end
    %% 选择答案
    if(PTB_Flag==1)
        DrawFormattedText(window, double('<-- (一致)   --> (不一致)'), 'center', 'center', Color_white); % window,文字,X坐标，Y坐标，颜色
        Screen('Flip', window);% 更新显示
    end
    %键盘输入
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
        if (keyIsDown==1 && (keyCode(Key_right)||keyCode(Key_left)))
            break
        end
    end
    % 判断选择是否正确，用左右箭头表示
    if(Flag_Change_Random==1)%表示不一致
        if (keyCode(Key_right)==1)
            Temp_Anwser=1;
        else
            Temp_Anwser=0;
        end
    else
        if (keyCode(Key_left)==1)
            Temp_Anwser=1;
        else
            Temp_Anwser=0;
        end
    end
    keyCode(Key_right)=0;    % 清零
    keyCode(Key_left)=0;    % 清零
    keyIsDown=0;        % 清零
    if(Log_Flag==1)
        disp(['-->第',num2str(Main_Index),'个选项用户回答正确与否: ',num2str(Temp_Anwser),'( 1 正确 0 错误)'])
        disp(['  '])
    end
    %% 黑屏1秒
     %Screen('DrawTexture', window ,PTB_IMG_Wait_5s); % 等待5秒钟的图片
     Screen('Flip',window);  % 更新显示
     WaitSecs(1); % 屏幕等待时间
    %% 记录函数
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %记录序号
    OutPut_Cell(Main_Index,2)=Temp_Number;   %记录原始序号
    OutPut_Cell(Main_Index,3)=Temp_VideoName;%记录视频文件名
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %记录车牌号
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Anwser); %记录回答正误
end
%% 结束问候
if(PTB_Flag==1)
    DrawFormattedText(window, [double('感谢参与本次测试'),double('\n本次测试到此结束！'),double('\n谢谢，祝您愉快！')], 'center', 'center', Color_white);
    Screen('Flip', window);% 更新显示
    WaitSecs(5);
    sca % 关闭屏幕
end
%% 记录到 Excel 文件
if(Log_Flag==1)
    OutPut_Cell
end
xlswrite(Excel_OUTPUT_FileName, {'序号','原始DATA序号','视频文件名','车牌号','回答正误(1为正确,0为错误)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])