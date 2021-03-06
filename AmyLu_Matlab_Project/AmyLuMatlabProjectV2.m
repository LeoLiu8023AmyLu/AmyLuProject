clc;
close all
clear all
%% 设置部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为程序控制部分     你要设置的
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 1;       % 1 为打开 PTB 0 为 关闭 (调试用，在PTB不正常的情况下 调试其他功能)
Log_Flag = 1;       % 1 为打开 Log 0 为 关闭 (调试用，输出运行中的记录)
Video_Interrupt=0;  % 1 为打开视频播放中断 0 为关闭
Speed_Mode=0;       % 1 为MATLAB通过代码控制速度 0 为直接读取视频文件
Play_Order=0;       % 0 为原始 随机播放顺序; 1 为 同速度递进播放方式
Auto_Anwser=0;      % 0 关闭 ; 1 开启 自动回答
Trigger_Flag=1;     % 0 关闭 ; 1 开启 Trigger
Trigger_End_Flag=0;	% 0 关闭 ; 1 开启 Trigger 结束记录
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为初始化设置部分   你要设置的 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Trigger 设置部分
Trigger_Port='E000';	% 设置Trigger 端口号
Trigger_End_Num=0;		% 设置Trigger截止线 数字
%% 试验中的文字
Screen_Strings_A='请观察图片中车牌号\n与视频中车牌号是否一致\n一致按<-- 不一致按-->\n\n\n按任意键开始测试';
Screen_Strings_B='一致    不一致 \n\n<--    -->';
Screen_Strings_C='休息一下\n\n按 Esc键 继续';
Screen_Strings_D='实验结束\n感谢配合';
Screen_Strings_E='实验中断\n结果无效\n';
Input_String='请输入志愿者姓名:  ';
%% 键盘按键设置
Key_Right_String='RightArrow';	% 正确回答的按键
Key_Wrong_String='LeftArrow';	% 错误回答的按键
Key_Restart_String='ESCAPE';	% 休息退出的按键
Key_Quit_String='Q';			% 中断退出的按键
%% 程序自动化设置
% 车牌自动变化字符设置
CarCode_Change_Num=3;       % 车牌发生变化的位数 最大是 4
CarCode_Char_Offset=7;      % 最小值为 5  最大值可以无限大 (已经做了处理)
% 实验显示及休息设置
PTB_Text_Size=75;           % 调节字体大小
Rest_Num=50;                % 50次后休息一下
% 无关设置
Play_Rate = 1;              % 播放方式 0 不播放  1 正常速度播放 -1 正常速度倒放【目前无法倒序播放】
%% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VolunteerName=input(Input_String,'s');		% 输入测试者姓名
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % 自动获取 .m 文件目录 因此项目的相对文件位置不要改变
if(Trigger_Flag==1)
	addpath([FolderPath,'config_io','\']);		% 引入 input/output 模块
end
Cross_Wait_Time=[0.22 0.24 0.26 0.28 0.3]; % 设置等待时间
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
Picture_TargetArea=[FolderPath,'target_area.jpg'];  % 得到 十字 的图片完整路径地址
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1);  % 获得表格中的数据
DATA_Input_Cell=RAW(2:end,:); % 去掉表头保留数据 
% DATA_Input_Cell(行号,列号) 引索由1开始
% DATA_Input_Cell(N,1) 序号
% DATA_Input_Cell(N,2) 方向
% DATA_Input_Cell(N,3) 类别
% DATA_Input_Cell(N,4) 速度
% DATA_Input_Cell(N,5) 文件类型
% DATA_Input_Cell(N,6) 车牌内容
% 根据 Excel 读取内容获取信息
%% 数据列表定义
Excel_Index=1;
Excel_Direction=2;
Excel_Class=3;
Excel_Speed=4;
Excel_Form=5;
Excel_CarCode=6;
%% 自动计算Excel得到的数据
CarCodeAll=unique(DATA_Input_Cell(:,Excel_CarCode));   % 获取全部车牌信息
Excel_Start=2;                          % Excel 开始行数
Speed_Num=length(unique(cell2mat(DATA_Input_Cell(:,Excel_Speed)))); % 速度的类别数
CarCode_Class_Num=length(CarCodeAll);   % 车牌类别数
Excel_End=Excel_Start+CarCode_Class_Num*Speed_Num*2-1; % 计算 Excel 结束行数
OutPut_Cell={}; % 输出的初始化
%% 播放顺序控制
if(Play_Order==0)
    %% 随机序列 修正
    Random_Series=randperm(length(DATA_Input_Cell));   % 生成随机数列
    Random_OK_Flag=1; % 训练标识符
    % 循环修正
    while(Random_OK_Flag)
        Temp_Random_Class=cell2mat(DATA_Input_Cell(Random_Series,Excel_Class));% 根据随机序列提取类别信息
        Random_OK_Flag=0; % 置零 若循环判断没有相邻项 则退出while循环
        for n=1:(length(Temp_Random_Class)-1) % 循环比较 n 和 n+1 项
            if(Temp_Random_Class(n)==Temp_Random_Class(n+1)) % 如果相同
                if(n>1) % 大于 1 的时候
                    Temp_Random_Num=Random_Series(n-1);
                    Random_Series(n-1)=Random_Series(n);
                    Random_Series(n)=Temp_Random_Num;
                else % 等于 1 的时候
                    Temp_Random_Num=Random_Series(end);
                    Random_Series(end)=Random_Series(n);
                    Random_Series(n)=Temp_Random_Num;
                end
                Random_OK_Flag=1; % 表示有相邻项
            end
        end
    end
    Play_Series=Random_Series;
else
    %% 同速度递进播放模式
    Play_Series=sortrows(DATA_Input_Cell,Excel_Speed);    % 按照速度排序
    Play_Series=cell2mat(Play_Series(:,1));     % 抽取第一列序号 并 转化为数组结构类型
    Play_Series=Play_Series';                   % 由列变换为行 (其实这一步可以省略的)
end
%% 打印设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 设置输出显示
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    disp(['-->志愿者姓名: ',VolunteerName])
    disp(['-->项目文件目录:',FolderPath])
    disp(['-->读取数据数量: ',num2str((Excel_End-Excel_Start+1))])
    disp(['-->速度种类数: ',num2str(Speed_Num)])
    disp(['-->速度分别为: ',num2str((unique(cell2mat(DATA_Input_Cell(:,Excel_Speed)))/10.0)'),'   (m/s)'])
    disp(['-->车牌种类数: ',num2str(CarCode_Class_Num)])
    disp(['-->车牌随机变化 ',num2str(CarCode_Change_Num),' 位数字'])
    disp(['-->字符最大偏移量: ',num2str(CarCode_Char_Offset),' (ASCII 码偏移) '])
    disp(' ')
end
%% Trigger 初始化
if(Trigger_Flag==1)
    config_io;              % Trigger程序文件导入 初始化
end
%% PTB 工具初始化
if(PTB_Flag==1)
	AssertOpenGL;           % PTB OpenGL显示设置
    PsychDefaultSetup(2);   % PTB 默认初始化
    Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 UTF-8
    Screen('Preference', 'SkipSyncTests', 1);           % 跳过检查
    screenGrps=Screen('Screens');                       % 初始化 屏幕
    screenNumber=max(screenGrps);                       % 选择次要 投放显示器
    Color_black = BlackIndex(screenNumber);             % 得到黑色屏幕的颜色数值
    Color_white = WhiteIndex(screenNumber);             % 得到白色屏幕的颜色数值
    Color_grey = Color_white / 2;                       % 得到灰色屏幕的颜色数值
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % 获得当前屏幕与屏幕的相关信息
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);  % 获得屏幕尺寸
    [xCenter, yCenter] = RectCenter(windowRect);                    % 获得中心坐标
    Picture_Read_TargetArea= imread(Picture_TargetArea);            % 读取 十字 的图片
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea); % 转化 十字图片为 PTB 对象
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % PTB设置
    Screen('TextSize', window, PTB_Text_Size);                      % 设置字体大小
    Screen('TextFont', window, 'simhei');                           % 设置字体
    DrawFormattedText(window, double(Screen_Strings_A), 'center','center', Color_white); % 显示文字
    Screen('Flip', window);% 更新显示
	% 定义键盘按键
	KbName('UnifyKeyNames');
    Key_O=KbName(Key_Right_String);         % 定义键盘右箭头键
    Key_X=KbName(Key_Wrong_String);         % 定义键盘左箭头键
    Key_Rest=KbName(Key_Restart_String);	% 定义退出键
	Key_Exit=KbName(Key_Quit_String);       % 定义退出键
    Screen('TextSize', window, (PTB_Text_Size+20)); % 设置后期的字体大小，如一致不一致
    %按下任意键开始
    keyIsDown=0;
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck; % 获取键盘按键
        if (keyIsDown==1) % 按键后退出循环
            break
        end
    end
    keyIsDown=0; % 按键Flag初始化
    if(Trigger_Flag==1)
        outp(hex2dec(Trigger_Port),0);	% 输出0
    end
end
%% 主循环函数
for Main_Index=1:length(DATA_Input_Cell)    % 设置循环
    %% 获取视频信息
    Temp=Play_Series(Main_Index);  % 读取随机数列的值
    Temp_Number=DATA_Input_Cell(Temp,Excel_Index);       % 读取序号
    Temp_Direction=char(DATA_Input_Cell(Temp,Excel_Direction));      % 读取车牌号
    Temp_Video_Class=cell2mat(DATA_Input_Cell(Temp,Excel_Class));    % 读取类别
    Temp_Video_Speed=cell2mat(DATA_Input_Cell(Temp,Excel_Speed));    % 读取速度
    Temp_Video_Form=DATA_Input_Cell(Temp,Excel_Form);    % 读取文件类型
    Temp_CarCode=char(DATA_Input_Cell(Temp,Excel_CarCode));      % 读取车牌号
    Temp_Speed=Temp_Video_Speed/10.0;%计算速度
    keyIsDown=0;      % 初始化按键标识符
	%% 计算Trigger 输出数字
	if(Temp_Direction=='R')
		Temp_Trigger_Num=floor(Temp_Video_Speed);		% 从右向左 获取 Trigger 的编号 从1开始
	else
		Temp_Trigger_Num=(floor(Temp_Video_Speed))*10;	% 从左向右 获取 Trigger 的编号 从10开始
	end
    if(Trigger_Flag==1)
        outp(hex2dec(Trigger_Port),0);	% Trigger 置零 
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 转化格式 (由于Excel 存入的类型是数字，所以在此转化为字符)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Temp_Video_Class<10) % 视频类别转化为字符
        Temp_Category_Char=[int2str(0),int2str(Temp_Video_Class)];% 添加零
    else
        Temp_Category_Char=num2str(Temp_Video_Class);              % 转化为字符串
    end
    if (Temp_Video_Speed<10) % 视频速度转化为字符
        Temp_Speed_Char=[int2str(0),strrep(num2str(Temp_Video_Speed),'.','')];   % 添加零 去掉小数点
    else
        Temp_Speed_Char=num2str(Temp_Video_Speed);                % 转化为字符串
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(Speed_Mode==1)
        Temp_Speed_Char='01'; % 设置为 01 代表使用 0.1 m/s 视频文件作为基础
    end
    Temp_VideoName=[Temp_Direction,'-',char(Temp_Category_Char),'-',char(Temp_Speed_Char),char(Temp_Video_Form)]; % 组成视频文件名
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % 得到完整的视频文件路径
    Flag_Change_Random=unidrnd(2)-1; % 随机生成 0 或 1 
    %% 変更车牌信息 
    if (Flag_Change_Random==1) % 改变显示的车牌内容
        CarCode_Mask_Middle=[ones(1,CarCode_Change_Num) zeros(1,(4-CarCode_Change_Num))]; % 制作4位的变化位遮罩数组 [1 1 0 0 ] 1 代表变化，0 不变化
        CarCode_Mask_Middle_Size = length(CarCode_Mask_Middle); % 得到遮罩数组长度
        CarCode_Mask_Middle(randperm(CarCode_Mask_Middle_Size)) = CarCode_Mask_Middle(1:1:CarCode_Mask_Middle_Size); % 遮罩数组随机排序
        CarCode_Mask=[0 0 CarCode_Mask_Middle 0];  % 遮罩数组补全车牌的 7 位
        Text_Offset_Random=randperm(CarCode_Char_Offset); % 生成4位的 各个字符偏移量 数组
        CarCode_Text_Offset_SQ=[0 0 Text_Offset_Random(1:4) 0]; % 补全为7位
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
        Display_CarCode=Temp_CarCode_Char; % 将得到的车牌给显示车牌变量
    else % 不改变显示的车牌内容
        Display_CarCode=Temp_CarCode;
    end
    if(Log_Flag==1)
        % 显示 打印
        disp(['-->序号: ',num2str(Main_Index),'  -->视频文件: ',Temp_VideoName,'  -->播放速度控制: ',num2str(Temp_Video_Speed/1.0),' 倍'])
        if(Flag_Change_Random)
            Temp_Text='改变';
        else
            Temp_Text='不改变';
        end
        disp(['-->原始车牌: ',char(Temp_CarCode),' --> [',Temp_Text,'] --> ',char(Display_CarCode)])
    end
    %% 显示文字 及 播放视频
    if(PTB_Flag==1)
        %% 显示定位
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(Cross_Wait_Time(unidrnd(5)));
        %% 显示车牌
        DrawFormattedText(window, double(char(Display_CarCode)), 'center', 'center', Color_white); % 显示车牌
        Screen('Flip',window);
        WaitSecs(0.2);
        %% 视频播放
        [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
        if(Speed_Mode == 1)
            Play_Rate=Temp_Video_Speed/1.0;
        end
		if(Trigger_Flag==1)
			outp(hex2dec(Trigger_Port),Temp_Trigger_Num);	% 输出 Trigger 编号
			Screen('PlayMovie',Car_MoviePtr, Play_Rate); % 控制影片播放的是第三个参数 0 不播放 1 正常速度播放 -1 正常速度倒放
            outp(hex2dec(Trigger_Port),0);	% 输出 Trigger 置零0
		else
			Screen('PlayMovie',Car_MoviePtr, Play_Rate); % 控制影片播放的是第三个参数 0 不播放 1 正常速度播放 -1 正常速度倒放
        end
        while (1) % 逐帧播放视频
            if(Video_Interrupt == 1)% 接收键盘按键
                keyIsDown=0;      % 初始化按键标识符
                [keyIsDown, ~, keyCode, ~]=KbCheck;
                if (keyIsDown==1 && (keyCode(Key_O)||keyCode(Key_X)||keyCode(Key_Exit))) % 判断是否是按键 并且是否是左右箭头键
                    break
                end
            end
			% 逐帧读取视频图像
			Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % 获得一帧视频图像
            if (Movie_IMG_Temp<=0) %判断视频是否已经读取完
                if(Trigger_Flag==1 && Trigger_End_Flag==1)
                    outp(hex2dec(Trigger_Port),0);	% 输出0
                    pause(0.1);
                end
				break
            end
            % 更新画面
            Screen('DrawTexture', window, Movie_IMG_Temp);% 绘制图像
            Screen('Flip', window);% 更新显示
            Screen('Close', Movie_IMG_Temp);% 释放视频资源
        end
        if(Trigger_Flag==1 && Trigger_End_Flag==1)
            outp(hex2dec(Trigger_Port),Trigger_End_Num);	% 输出 Trigger_End_Num 截止 线
        end
        Screen('CloseMovie', Car_MoviePtr);
        Screen('Flip', window);% 更新显示 (去除一些视频残留)
        %% 选择答案
        if(keyIsDown~=1)
            DrawFormattedText(window, double(Screen_Strings_B), 'center', 'center', Color_white); % window,文字,X坐标，Y坐标，颜色
            Screen('Flip', window);% 更新显示
           if(Auto_Anwser==0)
               %% 键盘输入
                while(1)  
                    [keyIsDown, ~, keyCode, ~]=KbCheck;
                    if (keyIsDown==1 && (keyCode(Key_O)||keyCode(Key_X)||keyCode(Key_Exit))) % 判断是否是按键 并且是否是左右箭头键
                        break
                    end
                end
           else
               %% 自动生成按键应答
               keyCode(Key_X)=unidrnd(2)-1; % 随机生成答案
               if(keyCode(Key_X)==1)
                   keyCode(Key_O)=0;
               else
                   keyCode(Key_O)=1;
               end
           end
        end
        %% 判断选择是否正确，用左右箭头表示
        if(Flag_Change_Random==1)% 表示不一致
            if (keyCode(Key_O)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        else % 一致的情况
            if (keyCode(Key_X)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        end
		% 中断退出
		if(keyCode(Key_Exit)==1)
			break
		end
        keyCode(Key_O)=0;    % 清零
        keyCode(Key_X)=0;    % 清零
        keyIsDown=0;        % 清零
        %% 黑屏1秒
        Screen('Flip',window);  % 更新显示
        WaitSecs(1); % 屏幕等待时间
    else % 调试模式使用随机生成方式
        Temp_Anwser=unidrnd(2)-1; % 随机生成答案
        if(Trigger_Flag==1)
            outp(hex2dec(Trigger_Port),Temp_Trigger_Num);	% 输出 Trigger 编号
            pause(0.5);
            outp(hex2dec(Trigger_Port),0);	% Trigger 置零
            pause(0.2);
            outp(hex2dec(Trigger_Port),Trigger_End_Num);	% 输出 Trigger 结束线
        end
    end
    if(Log_Flag==1)
        if(Temp_Anwser)
            Temp_Text='O  正确';
        else
            Temp_Text='X  不正确';
        end
        disp(['-->用户回答: ',Temp_Text])
		disp(['-->Trigger : ',num2str(Temp_Trigger_Num)])
        disp(['  '])
    end
    %% 记录函数
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %记录序号
    OutPut_Cell(Main_Index,2)=Temp_Number;   %记录原始序号
    OutPut_Cell(Main_Index,3)={Temp_VideoName};%记录视频文件名
    OutPut_Cell(Main_Index,4)={Temp_CarCode};  %记录车牌号
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Speed);  % 记录速度
    OutPut_Cell(Main_Index,6)=num2cell(Temp_Anwser); %记录回答正误
    OutPut_Cell(Main_Index,7)={Temp_Direction};%记录视频运动方向
    %% 试次间暂停休息
    if(PTB_Flag==1)
        if(mod(Main_Index,Rest_Num)==0)
            DrawFormattedText(window, double(Screen_Strings_C), 'center', 'center', Color_white);
            Screen('Flip', window);% 更新显示
            %WaitSecs(10);
			%按下任意键开始
			keyIsDown=0;
			while(1)
				[keyIsDown, ~, keyCode, ~]=KbCheck; % 获取键盘按键
				if (keyIsDown==1 && keyCode(Key_Rest)) % 按键后退出循环
					break
				end
			end
        end
    else    % 测试休息功能
        if(mod(Main_Index,Rest_Num)==0)
            disp(['主循环引索: ',num2str(Main_Index),' -->休息10秒<--'])
        end
    end     
end
%% 结束问候
if(PTB_Flag==1)
	if(length(OutPut_Cell)==(Excel_End-1))
		DrawFormattedText(window, double(Screen_Strings_D), 'center', 'center', Color_white);
	else
		DrawFormattedText(window, double(Screen_Strings_E), 'center', 'center', [1,0,0]);
	end
    Screen('Flip', window);% 更新显示
    WaitSecs(5);
    sca % 关闭屏幕
end
%% 实验结果显示
if(Log_Flag==1)
    Temp={'序号','原始DATA序号','视频文件名','车牌号','速度(m/s)','回答正误(1为正确,0为错误)','方向'}
    OutPut_Cell
end
%% 记录到 Excel 文件
if(length(OutPut_Cell)==(Excel_End-1))
	xlswrite(Excel_OUTPUT_FileName, {'序号','原始DATA序号','视频文件名','车牌号','速度(m/s)','回答正误(1为正确,0为错误)','方向'}, VolunteerName, 'A1:G1')
	xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','G',num2str(Excel_End)])
	if(Log_Flag==1)
		disp(['-->实验数据保存成功 ！'])
	end
	%% 数据分析部分
	Speed_All=unique(cell2mat(OutPut_Cell(:,5)))/1.0; % 获取全部速度
	Speed_All=Speed_All';   % 转置矩阵
	Correct_Speed=[];       % 速度
	for Speed_index=1:Speed_Num % 循环得到每类速度的正确数
		Correct_Speed(Speed_index)=length(...       % 求总长度
		intersect((find(cell2mat(OutPut_Cell(:,5))==Speed_All(Speed_index))),...  % intersect 求得矩阵的交集 OutPut_Cell(:,5) 得到速度列
		(find(cell2mat(OutPut_Cell(:,6))==1)))); % 计算正确个数  OutPut_Cell(:,6) 答案列
	end
	Correct_Speed=Correct_Speed/double(CarCode_Class_Num*2); % 计算正确率 每列/数目总数(车牌种类数)
	Speed_All       % 打印速度
	Correct_Speed   % 打印正确率
	%% 绘图部分
	Figure_Arrow=[repmat('\uparrow',length(Correct_Speed),1)]; % 生成箭头
    Figure_Number=[num2str(roundn((Correct_Speed')*100,-1)),repmat(' %',length(Correct_Speed),1)]; %生成图表文字
	figure; % 画图
	plot(Speed_All,Correct_Speed,'bo-'); % 绘图
	axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % 设置坐标轴在指定的区间
	xlabel('速度');       % X轴 名称
	ylabel('正确率');     % Y轴 名称
	title([VolunteerName,' 的测试结果统计']); % 图表 名称
	% 数据标注
    Adjust_Temp=ones(1,length(Speed_All));
    Adjust_Temp(1,1)=0.85;
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center');   % 画箭头
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.1),cellstr(Figure_Number),'center');   % 画百分比
end
clear all       % 释放所有资源