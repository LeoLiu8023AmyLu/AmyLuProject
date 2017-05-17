clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% ����ļ���ַ ע�� '\'б��
Sheet_Name='Data_Analysis';
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
[Type Sheet Format]=xlsfinfo(Excel_OUTPUT_FileName);
% Sheet �а��������Ϣ
Sheet(find(strcmp(Sheet,Sheet_Name)))=[]; % ȥ�� �����ܽ��
Data_ALL_Cell={}; % ��������
%% ��ѭ������
for Main_Index=1:length(Sheet)    % ����ѭ��
    %% ��ȡ�����Ϣ
    [NUM,TXT,RAW]=xlsread(Excel_OUTPUT_FileName ,char(Sheet(Main_Index)));  % ��ñ���е�����
    DATA_C=RAW(2:end,:); % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
    % DATA_C(N,1) ���
    % DATA_C(N,2) ԭʼDATA���
    % DATA_C(N,3) ��Ƶ�ļ���
    % DATA_C(N,4) ���ƺ�
    % DATA_C(N,5) �ٶ�(m/s)
    % DATA_C(N,6) �ش�����(1Ϊ��ȷ,0Ϊ����)
    %% ���ݷ�������
    Speed_All=unique(cell2mat(DATA_C(:,5)))/1.0; % ��ȡȫ���ٶ�
    Speed_Num=length(Speed_All); % �õ��ٶ�������
    CarCode_Class_Num=length(unique(cell2mat(DATA_C(:,4)))); % �õ�����������
    Speed_All=Speed_All'; % ת�þ���
    Correct_Speed=[]; % ������ȷ������
    for Speed_index=1:Speed_Num
        Correct_Speed(Speed_index)=length(...       % ���ܳ���
        intersect((find(cell2mat(DATA_C(:,5))==Speed_All(Speed_index))),...  % intersect ��þ���Ľ��� DATA_C(:,5) �õ��ٶ���
        (find(cell2mat(DATA_C(:,6))==1)))); % ������ȷ��  DATA_C(:,6) ����
    end
    Correct_Speed=Correct_Speed/double(CarCode_Class_Num);
    %Figure_Text=[repmat('  X:',length(Speed_All),1),num2str(Speed_All),repmat(', Y:',length(Correct_Speed),1),num2str(Correct_Speed')];
    Figure_Text=[repmat(' \leftarrow',length(Correct_Speed),1),num2str((Correct_Speed')*100),repmat(' %',length(Correct_Speed),1)]; %����ͼ������
    figure(Main_Index);
    plot(Speed_All,Correct_Speed,'bo-');
    axis([0 0.6 0 1]); % ������������ָ�������� xmin xmax ymin ymax
    xlabel('�ٶ�');
    ylabel('��ȷ��');
    title([char(Sheet(Main_Index)),'�Ĳ��Խ��ͳ��']);
    text(Speed_All,Correct_Speed,cellstr(Figure_Text));
    Data_ALL_Cell(Main_Index,1)={char(Sheet(Main_Index))}; % ���־Ը������
    Data_ALL_Cell(Main_Index,2:(length(Correct_Speed)+1))=num2cell(Correct_Speed); % ����ȷ�����ݷ���Cell ��
end
% ���Excel��ͷ��Ϣ
Data_Title_Cell(1)={'־Ը������\�ٶ�(m/s)'};
Data_Title_Cell(1,2:(length(Speed_All)+1))=num2cell(Speed_All); % �����ٶ���Ϣ
Excel_End=length(Sheet)+1; %
%% ��¼�� Excel �ļ�
Data_Title_Cell
Data_ALL_Cell
% д�� Excel
xlswrite(Excel_OUTPUT_FileName, Data_Title_Cell, Sheet_Name, ['A1:',char('A'+length(Speed_All)),'1'])
xlswrite(Excel_OUTPUT_FileName, Data_ALL_Cell, Sheet_Name, ['A2:',char('A'+length(Speed_All)),num2str(Excel_End)])
disp(['-->ʵ�����ݷ����������ɹ� ��'])
%clear all