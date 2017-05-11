clc;
close all;
clear all;
PTB_Flag=0; % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
VolunteerName='Jiawen';
% ���ݳ�ʼ��
FolderPath='C:\Users\Amy Lu\Desktop\AmyLu_Matlab_Project\';	% ����ļ���ַ
Excel_DATA_FileName = [FolderPath,'DATA.xls']  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls']  % �õ�Excel���ӱ������Ŀ¼
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,'A2:C201');  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) 
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) �ļ���
% Video_Name_C(N,3) ���ƺ�
Random_Series=randperm(length(Video_Name_C));   %�����������
OutPut_Cell={};%����ĳ�ʼ��
% PTB���߳�ʼ��
if(PTB_Flag==1)
    Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ utf-8
    Screen('Preference', 'SkipSyncTests', 0)    % �������
    screenGrps=Screen('Screens');   % ��ʼ�� ��Ļ
    screenid=max(screenGrps);   % ȫ����ʾ
    [win,rect] = Screen('OpenWindow', screenid,0);  % 
end
%��ѭ������
for n=1:length(Video_Name_C)    % ����ѭ��
    Temp=Random_Series(n);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_VideoName=Video_Name_C(Temp,2);    % ��ȡ�ļ���
    Temp_CarCode=Video_Name_C(Temp,3);      % ��ȡ���ƺ�
    VideoFileName =[FolderPath,char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    %������ʾ��Ƶ
    %������Ƶ
    if(PTB_Flag==1)
       [ssss] = Screen('OpenMovie', win,filename);
       Screen('PlayMovie',ssss, 1);
    end
    %ѡ���
       Temp_Anwser=unidrnd(2)-1;    % Ŀǰ������������� �𰸶Դ�
    %��¼����
    OutPut_Cell(n,1)=num2cell(n);   %��¼���
    OutPut_Cell(n,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(n,3)=Temp_VideoName;%��¼��Ƶ�ļ���
    OutPut_Cell(n,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(n,5)=num2cell(Temp_Anwser); %��¼�ش�����
end
OutPut_Cell
xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, 'A2:E201')