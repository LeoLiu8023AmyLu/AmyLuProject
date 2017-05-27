clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sheet_Name='Data_Analysis'; % �������ı�����
Plot_Text_Flag=0;   % �Ƿ���ͼ�н������Եײ�������ʽ��ʾ���� 1 ��ʾ 0 ����ʾ
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % �Զ���ȡ .m �ļ�Ŀ¼ �����Ŀ������ļ�λ�ò�Ҫ�ı�
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
[Type Sheet Format]=xlsfinfo(Excel_OUTPUT_FileName);    % �õ�����ļ����� �����õ����� Sheet ���б���Ϣ
% ���� Sheet �еı� �ų�����Ҫ����
Sheet(find(strcmp(Sheet,Sheet_Name)))=[];   % ȥ�� �����ܽ��
Sheet(find(strcmp(Sheet,'Sheet1')))=[];     % ȥ�� Sheet1 ��
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
    CarCode_Class_Num=length(unique(DATA_C(:,4))); % �õ����������� [����ͳ�Ƶ�ʱ������ת��Cell����]
    Speed_All=Speed_All'; % ת�þ���
    Correct_Speed=[]; % ������ȷ������
    for Speed_index=1:Speed_Num
        Correct_Speed(Speed_index)=length(...       % ���ܳ���
        intersect((find(cell2mat(DATA_C(:,5))==Speed_All(Speed_index))),...  % intersect ��þ���Ľ��� DATA_C(:,5) �õ��ٶ���
        (find(cell2mat(DATA_C(:,6))==1)))); % ������ȷ��  DATA_C(:,6) ����
    end
    Correct_Speed=Correct_Speed/double(CarCode_Class_Num); % ����ÿ����ȷ��
	%% ��ͼ
    Figure_Arrow=[repmat('\uparrow',length(Correct_Speed),1)]; % ���ɼ�ͷ
    Figure_Number=[num2str(roundn((Correct_Speed')*100,-1)),repmat(' %',length(Correct_Speed),1)]; %����ͼ������
    figure(Main_Index);
    plot(Speed_All,Correct_Speed,'bo-');
    axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % ������������ָ�������� xmin xmax ymin ymax
    % ͼ���ע
    xlabel('�ٶ�');
    ylabel('��ȷ��');
    title([char(Sheet(Main_Index)),'�Ĳ��Խ��ͳ��']);
    % ���ݱ�ע
    Adjust_Temp=ones(1,length(Speed_All));
    Adjust_Temp(1,1)=0.85;
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center');   % ����ͷ
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.1),cellstr(Figure_Number),'center');   % ���ٷֱ�
    if(Plot_Text_Flag==1)
        text(0,0.4,' �ٶ� (m/s)');
        text(0:0.1:max(Speed_All),(repmat(0.3,1,length(Correct_Speed))),(num2cell(Speed_All)));
        text(0,0.2,' ��ȷ�� %');
        text(0:0.1:max(Speed_All),(repmat(0.1,1,length(Correct_Speed))),(num2cell(roundn(Correct_Speed*100,-1))));
    end
    Data_ALL_Cell(Main_Index,1)={char(Sheet(Main_Index))}; % ���־Ը������
    Data_ALL_Cell(Main_Index,2:(length(Correct_Speed)+1))=num2cell(Correct_Speed); % ����ȷ�����ݷ���Cell ��
end
%% ��ƽ��ֵ����
% ����
if(length(Data_ALL_Cell(:,1))>1) % �ж��Ƿ�ֻ��һ������
    Avg_Correct=sum(cell2mat(Data_ALL_Cell(:,2:end))/length(Data_ALL_Cell(:,1)));
else
    Avg_Correct=cell2mat(Data_ALL_Cell(:,2:end))/length(Data_ALL_Cell(:,1));
end
Figure_Arrow=[repmat('\uparrow',length(Avg_Correct),1)]; % ���ɼ�ͷ
Figure_Number=[num2str(roundn((Avg_Correct')*100,-1)),repmat(' %',length(Avg_Correct),1)]; %����ͼ������
%����ͼ������
figure;
plot(Speed_All,Avg_Correct,'ro-');
axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % ������������ָ�������� xmin xmax ymin ymax
% ͼ���ע
xlabel('�ٶ�');
ylabel('��ȷ��');
title('ƽ��׼ȷ��ͳ��');
% ���ݱ�ע
text(Speed_All,(Avg_Correct.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center'); % ����ͷ
text(Speed_All,(Avg_Correct.*Adjust_Temp-0.1),cellstr(Figure_Number),'center'); % ���ٷֱ�
if(Plot_Text_Flag==1)
    text(0,0.4,' �ٶ� (m/s)');
    text(0:0.1:max(Speed_All),(repmat(0.3,1,length(Correct_Speed))),(num2cell(Speed_All)));
    text(0,0.2,' ��ȷ�� %');
    text(0:0.1:max(Speed_All),(repmat(0.1,1,length(Correct_Speed))),(num2cell(roundn(Avg_Correct*100,-1))));
end
% ���Excel��β��Ϣ
Data_Avg_Cell(1)={'ƽ��׼ȷ��'}; % ��ͷ
Data_Avg_Cell(1,2:(length(Avg_Correct)+1))=num2cell(Avg_Correct); % ����ƽ��׼ȷ��
%% ��¼�� Excel �ļ�
% ���Excel��ͷ��Ϣ
Data_Title_Cell(1)={'־Ը������\�ٶ�(m/s)'}; % ��ͷ
Data_Title_Cell(1,2:(length(Speed_All)+1))=num2cell(Speed_All); % �����ٶ���Ϣ
Excel_End=length(Sheet)+1; % �������ݽ�ֹ��
% ��ӡ
Data_Title_Cell % ��ͷ
Data_ALL_Cell 	% ����
Avg_Correct     % ƽ��ֵ
% д�� Excel
xlswrite(Excel_OUTPUT_FileName, Data_Title_Cell, Sheet_Name, ['A1:',char('A'+length(Speed_All)),'1']) % ��¼��ͷ
xlswrite(Excel_OUTPUT_FileName, Data_ALL_Cell, Sheet_Name, ['A2:',char('A'+length(Speed_All)),num2str(Excel_End)]) % ��¼����
xlswrite(Excel_OUTPUT_FileName, Data_Avg_Cell, Sheet_Name, ['A',num2str(Excel_End+1),':',char('A'+length(Speed_All)),num2str(Excel_End+1)]) % ��¼ƽ��ֵ
disp(['-->ʵ�����ݷ����������ɹ� ��'])
%clear all   % �ͷ�������Դ