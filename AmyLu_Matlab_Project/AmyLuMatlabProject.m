clc;
close all;
clear all;
PTB_Flag=0; % 1 为打开 PTB 0 为 关闭 (调试用，在PTB不正常的情况下 调试其他功能)
VolunteerName='AmyLuA'; 
% 数据初始化
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% 变更文件地址
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,'A2:C201');  % 获得表格中的数据
Video_Name_C=RAW; % 文件交换 Video_Name_C(行号,列号) 引索由1开始
% Video_Name_C(N,1) 序号
% Video_Name_C(N,2) 文件名
% Video_Name_C(N,3) 车牌号
Random_Series=randperm(length(Video_Name_C));   % 生成随机数列
OutPut_Cell={}; % 输出的初始化
% PTB工具初始化
if(PTB_Flag==1)
    Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 utf-8
    Screen('Preference', 'SkipSyncTests', 1)    % 跳过检查
    screenGrps=Screen('Screens');   % 初始化 屏幕
    screenid=max(screenGrps);   % 全屏显示
    [win,rect] = Screen('OpenWindow', screenid,0);  % 
end
%主循环函数
for n=1:length(Video_Name_C)    % 设置循环
    Temp=Random_Series(n);  % 读取随机数列的值
    Temp_Number=Video_Name_C(Temp,1);       % 读取序号
    Temp_VideoName=Video_Name_C(Temp,2);    % 读取文件名
    Temp_CarCode=Video_Name_C(Temp,3);      % 读取车牌号
    VideoFileName =[FolderPath,char(Temp_VideoName)];   % 得到完整的视频文件路径
    %播放提示视频
    %播放视频
    if(PTB_Flag==1)
       [ssss] = Screen('OpenMovie', win,filename);
       Screen('PlayMovie',ssss, 1);
    end
    %选择答案
    Temp_Anwser=unidrnd(2)-1;    % 目前先用随机数生成 答案对错
    %记录函数
    OutPut_Cell(n,1)=num2cell(n);   %记录序号
    OutPut_Cell(n,2)=Temp_Number;   %记录原始序号
    OutPut_Cell(n,3)=Temp_VideoName;%记录视频文件名
    OutPut_Cell(n,4)=Temp_CarCode;  %记录车牌号
    OutPut_Cell(n,5)=num2cell(Temp_Anwser); %记录回答正误
end
OutPut_Cell
xlswrite(Excel_OUTPUT_FileName, {'序号','原始DATA序号','视频文件名','车牌号','回答正误(1为正确,0为错误)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, 'A2:E201')