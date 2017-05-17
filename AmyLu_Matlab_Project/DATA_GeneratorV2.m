clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Ϊ������Ʋ���     ��Ҫ���õ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CarCode_Mode=1;     % 1 ʹ���ⲿtxt �ļ� 0 ʹ�ñ��������ɵ��������
Char_Flag = 1;      % 1 Ϊ��  0 Ϊ�ر� ���ƺ�5λ�������Ϊ��ĸ
Log_Flag = 1;       % 1 Ϊ�� Log 0 Ϊ �ر� (�����ã���������еļ�¼)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Title_Name='CarCode';   % Txt �ļ�������������
Txt_File_Name='AmyLuTxt.txt';    % Ҫ��ȡ�� Python ���ɵ�Txt�ļ���
Video_Form='.mp4';
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% ����ļ���ַ ע�� '\'б��
Start_Speed=0.1;    % ��ʼ�ٶ�
Speed_Step=0.1;     % �ٶȱ仯����
Speed_Num=5;        % �ٶ������
Speed_Class=[0.1,0.2,0.3,0.4,0.5,0.6,0.75]
End_Speed=Start_Speed+(Speed_Num-1)*Speed_Step;      % ��ֹ�ٶ�
Excel_Start=2;      % Excel ��ʼ����
Car_Code_Num=40;    % �Զ��峵�Ƶ�������
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Car_City={'��','��','ԥ','��','��','��','��','��','��','��','��','³','��',...
    '��','��','��','��','��','��','��','��','��','��','��','��'};
Car_Char='ABCDEFGHIJKLMNOPQRSTUVWXYZ'; % �ַ�����
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ�������Ŀ¼
CarCode_Cell={};    % ��ų���
OutPut_Cell={};     % ��ʼ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(CarCode_Mode==1)
    %% ��ȡ TXT �ļ�
    TXT_CarCode_FileName = [FolderPath,Txt_File_Name];  % TXT �ļ���
    TXT_CarCode = fopen(TXT_CarCode_FileName,'r','n','UTF-8');      % ����UTF-8�����ת��
    TXT_CarCode_Tline = fgetl(TXT_CarCode);                         % ��ȡ��һ��
    Temp_Index=1;                                                   % ������ʱ����
    while ischar(TXT_CarCode_Tline)                                 % ѭ����ȡ
        CarCode_Cell(Temp_Index)={TXT_CarCode_Tline};               % ���ӵ�Cell
        TXT_CarCode_Tline = fgetl(TXT_CarCode);
        Temp_Index=Temp_Index+1;
    end
    fclose(TXT_CarCode);                                            % �ر��ļ�
    CarCode_Cell=CarCode_Cell(2:end);                               % ȥ�� TXT ��ͷ�ļ�����������
    Car_Code_Num=length(CarCode_Cell);                              % ��ȡ���ݳ���
end
Excel_All=(Car_Code_Num*((End_Speed-Start_Speed)/Speed_Step+1));
Excel_End=Excel_Start+Excel_All-1;   % Excel ��������

%% ��ӡ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    if(CarCode_Mode==1)
        disp('-->�ⲿ��ȡTXT�ļ�')
    else
        disp('-->���������������')
    end
    disp(['-->�Ƿ����ɺ�5λ����ĸ�ĳ���: ',num2str(Char_Flag),' (1 �� 0 ��)'])
    disp(['-->��������: ',num2str(Car_Code_Num)])
    disp(['-->��ʼ�ٶ�: ',num2str(Start_Speed),' m/s  ��ֹ�ٶ�: ',num2str(End_Speed),' m/s  �ٶȲ���: ',num2str(Speed_Step),' m/s'])
    disp(['-->�ٶ�����: ',num2str(Speed_Num)])
end
%% ��ѭ������
if(CarCode_Mode==0)
    for Main_Index=1:Car_Code_Num    % ����ѭ��
    %% ���ɳ���
    Temp_CarCode_Num=randperm(9);
    Temp_CarCode=[char(Car_City(unidrnd(length(Car_City)))),char(Car_Char(unidrnd(length(Car_Char)))),num2str(Temp_CarCode_Num(1:5))];
    Temp_CarCode=strrep(Temp_CarCode,' ','');
    if(Char_Flag==1)
        Temp_Char_Change_Index=unidrnd(3)+2;
        Temp_CarCode(Temp_Char_Change_Index)=char(Car_Char(unidrnd(length(Car_Char))));
    end
    % ��¼����
    CarCode_Cell(Main_Index)={Temp_CarCode};
    end
    % ��ӡ��ʾ
    if(Log_Flag==1)
        disp('-->��������������')
    end
    %% ���泵��
    CarCode_Txt_OutPut=fopen('CarCode.txt','w','n','UTF-8');
    fprintf(CarCode_Txt_OutPut,[Title_Name,'\r\n']);
    for index=1:length(CarCode_Cell)
        fprintf(CarCode_Txt_OutPut,[char(CarCode_Cell(index)),'\r\n']);  % \r\n Windows�汾���з�
    end
    fclose(CarCode_Txt_OutPut);
    % ��ӡ��ʾ
    if(Log_Flag==1)
        CarCode_Cell
        disp('-->�ı��������')
    end
end
%% ѭ�� ����Excel��������
for Excel_Index=1:Excel_All
    %% �������
    Temp_Category=ceil(Excel_Index/Speed_Num);
    if (Temp_Category<10) % ����0
        Temp_Category_Char=[int2str(0),int2str(Temp_Category)];% ������
    else
        Temp_Category_Char=num2str(Temp_Category);              % ת��Ϊ�ַ���
    end
    % �����ٶ�
    Temp_Speed=mod(Excel_Index,Speed_Num);
    if(Temp_Speed==0)
        Temp_Speed=Speed_Num;
    end
    Temp_Speed=Start_Speed*10+(Temp_Speed-1);               % �����ٶ� 
    if (Temp_Speed<10) % ����0
        Temp_Speed_Char=[int2str(0),int2str(Temp_Speed)];   % ������
    else
        Temp_Speed_Char=num2str(Temp_Speed);                % ת��Ϊ�ַ���
    end
    % ��¼
    OutPut_Cell(Excel_Index,1)=num2cell(Excel_Index);       % ��¼���
    OutPut_Cell(Excel_Index,2)={Temp_Category_Char};        % ��¼���
    OutPut_Cell(Excel_Index,3)={Temp_Speed_Char};           % ��¼�ٶ�
    OutPut_Cell(Excel_Index,4)={Video_Form};                % ��¼��Ƶ�ļ�����
    OutPut_Cell(Excel_Index,5)=CarCode_Cell(Temp_Category); %��¼��������
end
%% ��¼�� Excel �ļ�
if(Log_Flag==1)
    Temp={'���','���','�ٶ�','�ļ�����','��������'}
    OutPut_Cell
end
xlswrite(Excel_DATA_FileName, {'���','���','�ٶ�','�ļ�����','��������'}, 'Sheet1', 'A1:E1')
xlswrite(Excel_DATA_FileName, OutPut_Cell, 'Sheet1', ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])
if(Log_Flag==1)
    disp(['-->ʵ�����ݱ���ɹ� ��'])
end