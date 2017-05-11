clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ������Ʋ���     ��Ҫ���õ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 1; % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
Log_Flag = 1; % 1 Ϊ�� Log 0 Ϊ �ر� (�����ã���������еļ�¼)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='C:\Users\Amy Lu\Desktop\AmyLu_Matlab_Project\';	% ����ļ���ַ
VolunteerName='LeoLiu';  % ����������
Excel_Start=2;  % Excel ��ʼ����
Excel_End=21;   % Excel ��������
CarCode_Change_Num=3;   % ���Ʒ����仯��λ�� ����� 5
CarCode_Char_Offset=7;  % ��СֵΪ 5  ���ֵ�������޴� (�Ѿ����˴���)
Play_Rate = 1; % ���ŷ�ʽ 0 ������  1 �����ٶȲ��� -1 �����ٶȵ��š�Ŀǰ�޷����򲥷š�
PTB_Text_Size=100;%���������С
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    disp(['-->־Ը�������� ',VolunteerName])
    disp(['-->��ȡ���������� ',num2str((Excel_End-Excel_Start+1))])
    disp(['-->���Ʊ仯λ���� ',num2str(CarCode_Change_Num)])
    disp(['-->�ַ�ƫ������',num2str(CarCode_Char_Offset)])
    
    
end
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(PTB_Flag==1)
    sca
%     Key_y=KbName('y');
%     Key_n=KbName('n');

end
Cross_Wait_Time=[0.22 0.24 0.26 0.28 0.3];
Data_Num=Excel_End-Excel_Start+1;
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,['A',num2str(Excel_Start),':','C',num2str(Excel_End)]);  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) �ļ���
% Video_Name_C(N,3) ���ƺ�
CarCodeAll=unique(Video_Name_C(:,3));
Random_Series=randperm(length(Video_Name_C));   % �����������
OutPut_Cell={}; % ����ĳ�ʼ��
%% PTB���߳�ʼ��
if(PTB_Flag==1)
    PsychDefaultSetup(2);
    Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ UTF-8
    Screen('Preference', 'SkipSyncTests', 1);    % �������
    screenGrps=Screen('Screens');   % ��ʼ�� ��Ļ
    screenNumber=max(screenGrps);  % ѡ���Ҫ Ͷ����ʾ��
    Color_black = BlackIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_white = WhiteIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_grey = Color_white / 2; % �õ���ɫ��Ļ����ɫ��ֵ
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % ��õ�ǰ��Ļ����Ļ�������Ϣ
    [screenXpixels, screenYpixels] = Screen('WindowSize', window); % �����Ļ�ߴ�
    [xCenter, yCenter] = RectCenter(windowRect); % �����������
    Picture_Read_TargetArea= imread(Picture_TargetArea); % ��ȡ ʮ�� ��ͼƬ
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, PTB_Text_Size);
    Screen('TextFont', window, 'simhei'); 
    DrawFormattedText(window, double('��۲�ͼƬ�г��ƺ�\n����Ƶ�г��ƺ��Ƿ�һ��\nһ�°�<-- ��һ�°�-->\n���������ʼ����'), 'center','center', Color_white); % ��ʾ����
    Screen('Flip', window);% ������ʾ
    Key_right=KbName('RightArrow');
    Key_left=KbName('LeftArrow');
    %�����������ʼ
    keyIsDown=0;
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
        if (keyIsDown==1)
            break
        end
    end
end
%% ��ѭ������
for Main_Index=1:length(Video_Name_C)    % ����ѭ��
    %% ��ȡ��Ƶ��Ϣ
    Temp=Random_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_VideoName=Video_Name_C(Temp,2);    % ��ȡ�ļ���
    Temp_CarCode=Video_Name_C(Temp,3);      % ��ȡ���ƺ�
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    Flag_Change_Random=unidrnd(2)-1; % ������� 0 �� 1 
    %% ���������Ϣ 
    if (Flag_Change_Random==1) % �ı���ʾ�ĳ�������
    CarCode_Mask_Middle=[ones(1,CarCode_Change_Num) zeros(1,(5-CarCode_Change_Num))]; % ����5λ�ı仯λ�������� [ 1 1 1 0 0 ] 1 ����仯��0 ���仯
        CarCode_Mask_Middle_Size = length(CarCode_Mask_Middle); % �õ��������鳤��
        CarCode_Mask_Middle(randperm(CarCode_Mask_Middle_Size)) = CarCode_Mask_Middle(1:1:CarCode_Mask_Middle_Size); % ���������������
        CarCode_Mask=[0 CarCode_Mask_Middle 0];  % �������鲹ȫ���Ƶ� 7 λ
        Text_Offset_Random=randperm(CarCode_Char_Offset); % ����5λ�� �����ַ�ƫ���� ����
        CarCode_Text_Offset_SQ=[0 Text_Offset_Random(1:5) 0]; % ��ȫΪ7λ
        CarCode_Text_Offset=CarCode_Text_Offset_SQ.*CarCode_Mask; % ������������˵õ���������ַ�ƫ������
        Temp_CarCode_Char=char(Temp_CarCode); % �� cell ��ʽ ת��Ϊ char ��ʽ
        for CarChange_Index=1:7 % ѭ������ÿһ���ַ�        
            Temp_Text=[]; % ��ʼ��
            Temp_Text(1,1)=Temp_CarCode_Char(CarChange_Index)+CarCode_Text_Offset(CarChange_Index); % + �ַ�ƫ��
            Temp_Text(1,2)=Temp_CarCode_Char(CarChange_Index)-CarCode_Text_Offset(CarChange_Index); % - �ַ�ƫ��
            Temp_Text(1,3)=Temp_CarCode_Char(CarChange_Index)+floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1); % + �ַ�ƫ�� (1~5)
            Temp_Text(1,4)=Temp_CarCode_Char(CarChange_Index)-floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1); % - �ַ�ƫ�� (1~5)
            for i=1:length(Temp_Text) %�ж��Ƿ���Բ���
                if((Temp_Text(1,i)>=65 && Temp_Text(1,i)<=90)||(Temp_Text(1,i)>=97 && Temp_Text(1,i)<=122)||(Temp_Text(1,i)>=48 && Temp_Text(1,i)<=57))
                    Temp_CarCode_Char(CarChange_Index)=Temp_Text(1,i); % ��ֵ����ʱ�ַ���
                    break % ���ѭ�� ����������������� ������ѭ��
                end
            end
        end
        Display_CarCode=Temp_CarCode_Char;
    else % ���ı���ʾ�ĳ�������
        Display_CarCode=Temp_CarCode;
    end
    if(Log_Flag==1)
        % ��ʾ ��ӡ
        disp(['-->ԭʼ���ƣ�',char(Temp_CarCode),'�Ƿ�ı䣺',num2str(Flag_Change_Random),' ( 1 �ı� 0 ���ı�)'])
        disp(['-->�ı���ƣ�',char(Display_CarCode)])
    end
    %% ��ʾ���� �� ������Ƶ
    if(PTB_Flag==1)
        %% ��ʾ��λ
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(Cross_Wait_Time(unidrnd(5)));
        %% ��ʾ����
        % DrawFormattedText(window, double('��۲����г��ƺ�:'), 'center', screenYpixels * (2/7), Color_white); % ��ʾ����
        DrawFormattedText(window, double(char(Display_CarCode)), 'center', 'center', Color_white); % ��ʾ����
        Screen('Flip',window);
        WaitSecs(0.2);
        %% ��Ƶ����
        [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',Car_MoviePtr, Play_Rate); % ����ӰƬ���ŵ��ǵ��������� 0 ������ 1 �����ٶȲ��� -1 �����ٶȵ���
        while (1) % ��֡������Ƶ
            Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
            Movie_IMG_Temp
            if Movie_IMG_Temp<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                break
            end
            %���»���
            Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
        end
        Screen('CloseMovie', Car_MoviePtr);
    end
    %% ѡ���
    if(PTB_Flag==1)
        DrawFormattedText(window, double('<-- (һ��)   --> (��һ��)'), 'center', 'center', Color_white); % window,����,X���꣬Y���꣬��ɫ
        Screen('Flip', window);% ������ʾ
    end
    %��������
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
        if (keyIsDown==1 && (keyCode(Key_right)||keyCode(Key_left)))
            break
        end
    end
    % �ж�ѡ���Ƿ���ȷ�������Ҽ�ͷ��ʾ
    if(Flag_Change_Random==1)%��ʾ��һ��
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
    keyCode(Key_right)=0;    % ����
    keyCode(Key_left)=0;    % ����
    keyIsDown=0;        % ����
    if(Log_Flag==1)
        disp(['-->��',num2str(Main_Index),'��ѡ���û��ش���ȷ���: ',num2str(Temp_Anwser),'( 1 ��ȷ 0 ����)'])
        disp(['  '])
    end
    %% ����1��
     %Screen('DrawTexture', window ,PTB_IMG_Wait_5s); % �ȴ�5���ӵ�ͼƬ
     Screen('Flip',window);  % ������ʾ
     WaitSecs(1); % ��Ļ�ȴ�ʱ��
    %% ��¼����
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %��¼���
    OutPut_Cell(Main_Index,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(Main_Index,3)=Temp_VideoName;%��¼��Ƶ�ļ���
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Anwser); %��¼�ش�����
end
%% �����ʺ�
if(PTB_Flag==1)
    DrawFormattedText(window, [double('��л���뱾�β���'),double('\n���β��Ե��˽�����'),double('\nлл��ף����죡')], 'center', 'center', Color_white);
    Screen('Flip', window);% ������ʾ
    WaitSecs(5);
    sca % �ر���Ļ
end
%% ��¼�� Excel �ļ�
if(Log_Flag==1)
    OutPut_Cell
end
xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])