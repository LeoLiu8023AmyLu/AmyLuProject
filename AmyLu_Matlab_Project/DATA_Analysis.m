clc;
close all
clear all
%% 设置部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为初始化设置部分   你要设置的 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% 变更文件地址 注意 '\'斜线
Sheet_Name='Data_Analysis';
%% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
[Type Sheet Format]=xlsfinfo(Excel_OUTPUT_FileName);
% Sheet 中包含表格信息
Sheet(find(strcmp(Sheet,Sheet_Name)))=[]; % 去除 分析总结表单
Data_ALL_Cell={}; % 输出的输出
%% 主循环函数
for Main_Index=1:length(Sheet)    % 设置循环
    %% 获取表格信息
    [NUM,TXT,RAW]=xlsread(Excel_OUTPUT_FileName ,char(Sheet(Main_Index)));  % 获得表格中的数据
    DATA_C=RAW(2:end,:); % 文件交换 Video_Name_C(行号,列号) 引索由1开始
    % DATA_C(N,1) 序号
    % DATA_C(N,2) 原始DATA序号
    % DATA_C(N,3) 视频文件名
    % DATA_C(N,4) 车牌号
    % DATA_C(N,5) 速度(m/s)
    % DATA_C(N,6) 回答正误(1为正确,0为错误)
    %% 数据分析部分
    Speed_All=unique(cell2mat(DATA_C(:,5)))/1.0; % 获取全部速度
    Speed_Num=length(Speed_All); % 得到速度种类数
    CarCode_Class_Num=length(unique(cell2mat(DATA_C(:,4)))); % 得到车牌种类数
    Speed_All=Speed_All'; % 转置矩阵
    Correct_Speed=[]; % 建立正确率数组
    for Speed_index=1:Speed_Num
        Correct_Speed(Speed_index)=length(...       % 求总长度
        intersect((find(cell2mat(DATA_C(:,5))==Speed_All(Speed_index))),...  % intersect 求得矩阵的交集 DATA_C(:,5) 得到速度列
        (find(cell2mat(DATA_C(:,6))==1)))); % 计算正确率  DATA_C(:,6) 答案列
    end
    Correct_Speed=Correct_Speed/double(CarCode_Class_Num);
    %Figure_Text=[repmat('  X:',length(Speed_All),1),num2str(Speed_All),repmat(', Y:',length(Correct_Speed),1),num2str(Correct_Speed')];
    Figure_Text=[repmat(' \leftarrow',length(Correct_Speed),1),num2str((Correct_Speed')*100),repmat(' %',length(Correct_Speed),1)]; %生成图表文字
    figure(Main_Index);
    plot(Speed_All,Correct_Speed,'bo-');
    axis([0 0.6 0 1]); % 设置坐标轴在指定的区间 xmin xmax ymin ymax
    xlabel('速度');
    ylabel('正确率');
    title([char(Sheet(Main_Index)),'的测试结果统计']);
    text(Speed_All,Correct_Speed,cellstr(Figure_Text));
    Data_ALL_Cell(Main_Index,1)={char(Sheet(Main_Index))}; % 添加志愿者姓名
    Data_ALL_Cell(Main_Index,2:(length(Correct_Speed)+1))=num2cell(Correct_Speed); % 把正确率数据放入Cell 中
end
% 添加Excel表头信息
Data_Title_Cell(1)={'志愿者姓名\速度(m/s)'};
Data_Title_Cell(1,2:(length(Speed_All)+1))=num2cell(Speed_All); % 放入速度信息
Excel_End=length(Sheet)+1; %
%% 记录到 Excel 文件
Data_Title_Cell
Data_ALL_Cell
% 写入 Excel
xlswrite(Excel_OUTPUT_FileName, Data_Title_Cell, Sheet_Name, ['A1:',char('A'+length(Speed_All)),'1'])
xlswrite(Excel_OUTPUT_FileName, Data_ALL_Cell, Sheet_Name, ['A2:',char('A'+length(Speed_All)),num2str(Excel_End)])
disp(['-->实验数据分析结果保存成功 ！'])
%clear all