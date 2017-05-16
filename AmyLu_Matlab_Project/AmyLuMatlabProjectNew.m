clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ������Ʋ���     ��Ҫ���õ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 0;       % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
Log_Flag = 1;       % 1 Ϊ�� Log 0 Ϊ �ر� (�����ã���������еļ�¼)
Video_Interrupt=0;  % 1 Ϊ����Ƶ�ն� 0 Ϊ�ر�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% ����ļ���ַ ע�� '\'б��
VolunteerName='LeoLiu';  % ����������
Excel_Start=2;          % Excel ��ʼ����
Speed_Num=5;            % �ٶȵ������
CarCode_Class_Num=40;   % ���������
Excel_End=Excel_Start+CarCode_Class_Num*Speed_Num-1; % ���� Excel ��������
CarCode_Change_Num=3;   % ���Ʒ����仯��λ�� ����� 4
CarCode_Char_Offset=7;  % ��СֵΪ 5  ���ֵ�������޴� (�Ѿ����˴���)
Play_Rate = 1;          % ���ŷ�ʽ 0 ������  1 �����ٶȲ��� -1 �����ٶȵ��š�Ŀǰ�޷����򲥷š�
PTB_Text_Size=75;       % ���������С
Rest_Num=50;            % 50�κ���Ϣһ��
%% ��ӡ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    disp(['-->־Ը�������� ',VolunteerName])
    disp(['-->��ȡ���������� ',num2str((Excel_End-Excel_Start+1))])
    disp(['-->�ٶ��������� ',num2str(Speed_Num)])
    disp(['-->������������ ',num2str(CarCode_Class_Num)])
    disp(['-->���Ʊ仯λ���� ',num2str(CarCode_Change_Num)])
    disp(['-->�ַ�ƫ������',num2str(CarCode_Char_Offset)])
end
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(PTB_Flag==1)
    %sca % �ر� PTB �����Ĵ���
end
Cross_Wait_Time=[0.22 0.24 0.26 0.28 0.3]; % ���õȴ�ʱ��
Data_Num=Excel_End-Excel_Start+1; % ��ȡ���ݶ�ȡ����
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];  % �õ� ʮ�� ��ͼƬ����·����ַ
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,['A',num2str(Excel_Start),':','E',num2str(Excel_End)]);  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) ���
% Video_Name_C(N,3) �ٶ�
% Video_Name_C(N,4) �ļ�����
% Video_Name_C(N,5) ��������
CarCodeAll=unique(Video_Name_C(:,5)); % ��ȡȫ��������Ϣ
Random_Series=randperm(length(Video_Name_C));   % �����������
OutPut_Cell={}; % ����ĳ�ʼ��
%% PTB���߳�ʼ��
if(PTB_Flag==1)
    PsychDefaultSetup(2); % PTB Ĭ�ϳ�ʼ��
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
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea); % ת�� ʮ��ͼƬΪ PTB ����
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % PTB����
    Screen('TextSize', window, PTB_Text_Size); % ���������С
    Screen('TextFont', window, 'simhei');  % ��������
    DrawFormattedText(window, double('��۲�ͼƬ�г��ƺ�\n����Ƶ�г��ƺ��Ƿ�һ��\nһ�°�<-- ��һ�°�-->\n\n\n���������ʼ����'), 'center','center', Color_white); % ��ʾ����
    Screen('Flip', window);% ������ʾ
    Key_right=KbName('RightArrow'); % ��������Ҽ�ͷ��
    Key_left=KbName('LeftArrow');   % ����������ͷ��
    Key_Rest=KbName('ESCAPE');      % �����˳���
    Screen('TextSize', window, (PTB_Text_Size+20)); % ���ú��ڵ������С����һ�²�һ��
    %�����������ʼ
    keyIsDown=0;
    while(1)
        [keyIsDown, ~, keyCode, ~]=KbCheck; % ��ȡ���̰���
        if (keyIsDown==1) % �������˳�ѭ��
            break
        end
    end
    keyIsDown=0; % ����Flag��ʼ��
end
%% ��ѭ������
for Main_Index=1:length(Video_Name_C)    % ����ѭ��
    %% ��ȡ��Ƶ��Ϣ
    Temp=Random_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_Video_Class=cell2mat(Video_Name_C(Temp,2));    % ��ȡ���
    Temp_Video_Speed=cell2mat(Video_Name_C(Temp,3));    % ��ȡ�ٶ�
    Temp_Video_Form=Video_Name_C(Temp,4);    % ��ȡ�ļ�����
    Temp_CarCode=Video_Name_C(Temp,5);      % ��ȡ���ƺ�
    Temp_Speed=Temp_Video_Speed/10.0;%�����ٶ�
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ת����ʽ (����Excel ��������������֣������ڴ�ת��Ϊ�ַ�)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Temp_Video_Class<10) % ��Ƶ���ת��Ϊ�ַ�
        Temp_Category_Char=[int2str(0),int2str(Temp_Video_Class)];% �����
    else
        Temp_Category_Char=num2str(Temp_Video_Class);              % ת��Ϊ�ַ���
    end
    if (Temp_Video_Speed<10) % ��Ƶ�ٶ�ת��Ϊ�ַ�
        Temp_Speed_Char=[int2str(0),int2str(Temp_Video_Speed)];   % �����
    else
        Temp_Speed_Char=num2str(Temp_Video_Speed);                % ת��Ϊ�ַ���
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Temp_VideoName=[char(Temp_Category_Char),'-',char(Temp_Speed_Char),char(Temp_Video_Form)] % �����Ƶ�ļ���
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    Flag_Change_Random=unidrnd(2)-1; % ������� 0 �� 1 
    %% ���������Ϣ 
    if (Flag_Change_Random==1) % �ı���ʾ�ĳ�������
        CarCode_Mask_Middle=[ones(1,CarCode_Change_Num) zeros(1,(4-CarCode_Change_Num))]; % ����4λ�ı仯λ�������� [1 1 0 0 ] 1 ����仯��0 ���仯
        CarCode_Mask_Middle_Size = length(CarCode_Mask_Middle); % �õ��������鳤��
        CarCode_Mask_Middle(randperm(CarCode_Mask_Middle_Size)) = CarCode_Mask_Middle(1:1:CarCode_Mask_Middle_Size); % ���������������
        CarCode_Mask=[0 0 CarCode_Mask_Middle 0];  % �������鲹ȫ���Ƶ� 7 λ
        Text_Offset_Random=randperm(CarCode_Char_Offset); % ����4λ�� �����ַ�ƫ���� ����
        CarCode_Text_Offset_SQ=[0 0 Text_Offset_Random(1:4) 0]; % ��ȫΪ7λ
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
        Display_CarCode=Temp_CarCode_Char; % ���õ��ĳ��Ƹ���ʾ���Ʊ���
    else % ���ı���ʾ�ĳ�������
        Display_CarCode=Temp_CarCode;
    end
    if(Log_Flag==1)
        % ��ʾ ��ӡ
        disp(['-->ԭʼ���ƣ�',char(Temp_CarCode),'�Ƿ�ı䣺 ',num2str(Flag_Change_Random),' ( 1 �ı� 0 ���ı�)'])
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
            if(Video_Interrupt==1)% ���ռ��̰���
                keyIsDown=0;      % ��ʼ��������ʶ��
                [keyIsDown, ~, keyCode, ~]=KbCheck;
                if (keyIsDown==1 && (keyCode(Key_right)||keyCode(Key_left))) % �ж��Ƿ��ǰ��� �����Ƿ������Ҽ�ͷ��
                    break
                end
            end
			% ��֡��ȡ��Ƶͼ��
			Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
            if Movie_IMG_Temp<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                break
            end
            % ���»���
            Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
        end
        Screen('CloseMovie', Car_MoviePtr);
        Screen('Flip', window);% ������ʾ (ȥ��һЩ��Ƶ����)
    end
    %% ѡ���
    if(PTB_Flag==1)
        if(keyIsDown~=1)
            DrawFormattedText(window, double('һ��    ��һ�� \n\n<--    -->'), 'center', 'center', Color_white); % window,����,X���꣬Y���꣬��ɫ
            Screen('Flip', window);% ������ʾ
            %% ��������
            while(1)  
                [keyIsDown, ~, keyCode, ~]=KbCheck;
                if (keyIsDown==1 && (keyCode(Key_right)||keyCode(Key_left))) % �ж��Ƿ��ǰ��� �����Ƿ������Ҽ�ͷ��
                    break
                end
            end
        end
        %% �ж�ѡ���Ƿ���ȷ�������Ҽ�ͷ��ʾ
        if(Flag_Change_Random==1)% ��ʾ��һ��
            if (keyCode(Key_right)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        else % һ�µ����
            if (keyCode(Key_left)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        end
        keyCode(Key_right)=0;    % ����
        keyCode(Key_left)=0;    % ����
        keyIsDown=0;        % ����
        %% ����1��
        Screen('Flip',window);  % ������ʾ
        WaitSecs(1); % ��Ļ�ȴ�ʱ��
    else % ����ģʽʹ��������ɷ�ʽ
        Temp_Anwser=unidrnd(2)-1; % ������ɴ�
    end
    if(Log_Flag==1)
        disp(['-->��',num2str(Main_Index),'��ѡ���û��ش���ȷ���: ',num2str(Temp_Anwser),'( 1 ��ȷ 0 ����)'])
        disp(['  '])
    end
    %% ��¼����
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %��¼���
    OutPut_Cell(Main_Index,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(Main_Index,3)= {Temp_VideoName};%��¼��Ƶ�ļ���
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Speed);  % ��¼�ٶ�
    OutPut_Cell(Main_Index,6)=num2cell(Temp_Anwser); %��¼�ش�����
    %% �Դμ���ͣ��Ϣ
    if(PTB_Flag==1)
        if(mod(Main_Index,Rest_Num)==0)
            DrawFormattedText(window, double('��Ϣһ��\n\n�� Esc�� ����'), 'center', 'center', Color_white);
            Screen('Flip', window);% ������ʾ
            %WaitSecs(10);
			%�����������ʼ
			keyIsDown=0;
			while(1)
				[keyIsDown, ~, keyCode, ~]=KbCheck; % ��ȡ���̰���
				if (keyIsDown==1 && keyCode(Key_Rest)) % �������˳�ѭ��
					break
				end
			end
        end
    else    % ������Ϣ����
        if(mod(Main_Index,Rest_Num)==0)
            disp(['��ѭ������: ',num2str(Main_Index),' -->��Ϣ10��<--'])
        end
    end     
end
%% �����ʺ�
if(PTB_Flag==1)
    DrawFormattedText(window, [double('ʵ�����'),double('\n��л���')], 'center', 'center', Color_white);
    Screen('Flip', window);% ������ʾ
    WaitSecs(5);
    sca % �ر���Ļ
end
%% ��¼�� Excel �ļ�
if(Log_Flag==1)
    Temp={'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ٶ�(m/s)','�ش�����(1Ϊ��ȷ,0Ϊ����)'}
    OutPut_Cell
end
xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ٶ�(m/s)','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:F1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','F',num2str(Excel_End)])
if(Log_Flag==1)
    disp(['-->ʵ�����ݱ���ɹ� ��'])
end
%% ���ݷ�������
Speed_All=unique(cell2mat(Video_Name_C(:,3)))/10.0; % ��ȡȫ��������Ϣ
Speed_All=Speed_All';
Correct_Speed=[];
for Speed_index=1:Speed_Num
    Correct_Speed(Speed_index)=length(intersect((find(cell2mat(OutPut_Cell(:,5))==Speed_All(Speed_index))),(find(cell2mat(OutPut_Cell(:,6))==1)))); % ������ȷ��
end
Correct_Speed=Correct_Speed/double(CarCode_Class_Num);
%Figure_Text=[repmat('  X:',length(Speed_All),1),num2str(Speed_All),repmat(', Y:',length(Correct_Speed),1),num2str(Correct_Speed')];
figure;
plot(Speed_All,Correct_Speed,'bo-');
xlabel('�ٶ�');
ylabel('��ȷ��');
title([VolunteerName,'�Ĳ��Խ��ͳ��']);
%text(Speed_All,Correct_Speed,cellstr(Figure_Text));
Speed_All
Correct_Speed
clear all