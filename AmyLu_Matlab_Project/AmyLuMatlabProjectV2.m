clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ������Ʋ���     ��Ҫ���õ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 0;       % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
Log_Flag = 1;       % 1 Ϊ�� Log 0 Ϊ �ر� (�����ã���������еļ�¼)
Video_Interrupt=0;  % 1 Ϊ����Ƶ�����ж� 0 Ϊ�ر�
Speed_Mode=0;       % 1 ΪMATLABͨ����������ٶ� 0 Ϊֱ�Ӷ�ȡ��Ƶ�ļ�
Play_Order=1;       % 0 Ϊԭʼ �������˳��; 1 Ϊ ͬ�ٶȵݽ����ŷ�ʽ
Auto_Anwser=1;      % 0 �ر� ; 1 �����Զ��ش�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Trigger ���ò���
Trigger_Port='E000';	% ����Trigger �˿ں�
Trigger_End_Num=50;		% ����Trigger��ֹ�� ����
%% �����е�����
Screen_Strings_A='��۲�ͼƬ�г��ƺ�\n����Ƶ�г��ƺ��Ƿ�һ��\nһ�°�<-- ��һ�°�-->\n\n\n���������ʼ����';
Screen_Strings_B='һ��    ��һ�� \n\n<--    -->';
Screen_Strings_C='��Ϣһ��\n\n�� Esc�� ����';
Screen_Strings_D='ʵ�����\n��л���';
Screen_Strings_E='ʵ���ж�\n�����Ч\n';
Input_String='������־Ը������:  ';
%% ���̰�������
Key_Right_String='RightArrow';	% ��ȷ�ش�İ���
Key_Wrong_String='LeftArrow';	% ����ش�İ���
Key_Restart_String='ESCAPE';	% ��Ϣ�˳��İ���
Key_Quit_String='Q';			% �ж��˳��İ���
%% �����Զ�������
% �����Զ��仯�ַ�����
CarCode_Change_Num=3;       % ���Ʒ����仯��λ�� ����� 4
CarCode_Char_Offset=7;      % ��СֵΪ 5  ���ֵ�������޴� (�Ѿ����˴���)
% ʵ����ʾ����Ϣ����
PTB_Text_Size=75;           % ���������С
Rest_Num=50;                % 50�κ���Ϣһ��
% �޹�����
Play_Rate = 1;              % ���ŷ�ʽ 0 ������  1 �����ٶȲ��� -1 �����ٶȵ��š�Ŀǰ�޷����򲥷š�
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VolunteerName=input(Input_String,'s');		% �������������
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % �Զ���ȡ .m �ļ�Ŀ¼ �����Ŀ������ļ�λ�ò�Ҫ�ı�
addpath([FolderPath,"config_io",'\']);		% ���� input/output ģ��
Cross_Wait_Time=[0.22 0.24 0.26 0.28 0.3]; % ���õȴ�ʱ��
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];  % �õ� ʮ�� ��ͼƬ����·����ַ
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1);  % ��ñ���е�����
DATA_Input_Cell=RAW(2:end,:); % ȥ����ͷ�������� 
% DATA_Input_Cell(�к�,�к�) ������1��ʼ
% DATA_Input_Cell(N,1) ���
% DATA_Input_Cell(N,2) ���
% DATA_Input_Cell(N,3) �ٶ�
% DATA_Input_Cell(N,4) �ļ�����
% DATA_Input_Cell(N,5) ��������
% ���� Excel ��ȡ���ݻ�ȡ��Ϣ
CarCodeAll=unique(DATA_Input_Cell(:,5));   % ��ȡȫ��������Ϣ
Excel_Start=2;                          % Excel ��ʼ����
Speed_Num=length(unique(cell2mat(DATA_Input_Cell(:,3)))); % �ٶȵ������
CarCode_Class_Num=length(CarCodeAll);   % ���������
Excel_End=Excel_Start+CarCode_Class_Num*Speed_Num-1; % ���� Excel ��������
OutPut_Cell={}; % ����ĳ�ʼ��
%% ����˳�����
if(Play_Order==0)
    %% ������� ����
    Random_Series=randperm(length(DATA_Input_Cell));   % �����������
    Random_OK_Flag=1; % ѵ����ʶ��
    % ѭ������
    while(Random_OK_Flag)
        Temp_Random_Class=cell2mat(DATA_Input_Cell(Random_Series,2));% �������������ȡ�����Ϣ
        Random_OK_Flag=0; % ���� ��ѭ���ж�û�������� ���˳�whileѭ��
        for n=1:(length(Temp_Random_Class)-1) % ѭ���Ƚ� n �� n+1 ��
            if(Temp_Random_Class(n)==Temp_Random_Class(n+1)) % �����ͬ
                if(n>1) % ���� 1 ��ʱ��
                    Temp_Random_Num=Random_Series(n-1);
                    Random_Series(n-1)=Random_Series(n);
                    Random_Series(n)=Temp_Random_Num;
                else % ���� 1 ��ʱ��
                    Temp_Random_Num=Random_Series(end);
                    Random_Series(end)=Random_Series(n);
                    Random_Series(n)=Temp_Random_Num;
                end
                Random_OK_Flag=1; % ��ʾ��������
            end
        end
    end
    Play_Series=Random_Series;
else
    %% ͬ�ٶȵݽ�����ģʽ
    Play_Series=sortrows(DATA_Input_Cell,3);    % �����ٶ�����
    Play_Series=cell2mat(Play_Series(:,1));     % ��ȡ��һ����� �� ת��Ϊ����ṹ����
    Play_Series=Play_Series';                   % ���б任Ϊ�� (��ʵ��һ������ʡ�Ե�)
end
%% ��ӡ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ʾ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    disp(['-->־Ը������: ',VolunteerName])
    disp(['-->��Ŀ�ļ�Ŀ¼:',FolderPath])
    disp(['-->��ȡ��������: ',num2str((Excel_End-Excel_Start+1))])
    disp(['-->�ٶ�������: ',num2str(Speed_Num)])
    disp(['-->�ٶȷֱ�Ϊ: ',num2str((unique(cell2mat(DATA_Input_Cell(:,3)))/10.0)'),'   (m/s)'])
    disp(['-->����������: ',num2str(CarCode_Class_Num)])
    disp(['-->��������仯 ',num2str(CarCode_Change_Num),' λ����'])
    disp(['-->�ַ����ƫ����: ',num2str(CarCode_Char_Offset),' (ASCII ��ƫ��) '])
    disp(' ')
end
%% PTB���߳�ʼ��
config_io;              % Trigger�����ļ����� ��ʼ��
if(PTB_Flag==1)
	AssertOpenGL;           % PTB OpenGL��ʾ����
    PsychDefaultSetup(2);   % PTB Ĭ�ϳ�ʼ��
    Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ UTF-8
    Screen('Preference', 'SkipSyncTests', 1);           % �������
    screenGrps=Screen('Screens');                       % ��ʼ�� ��Ļ
    screenNumber=max(screenGrps);                       % ѡ���Ҫ Ͷ����ʾ��
    Color_black = BlackIndex(screenNumber);             % �õ���ɫ��Ļ����ɫ��ֵ
    Color_white = WhiteIndex(screenNumber);             % �õ���ɫ��Ļ����ɫ��ֵ
    Color_grey = Color_white / 2;                       % �õ���ɫ��Ļ����ɫ��ֵ
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % ��õ�ǰ��Ļ����Ļ�������Ϣ
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);  % �����Ļ�ߴ�
    [xCenter, yCenter] = RectCenter(windowRect);                    % �����������
    Picture_Read_TargetArea= imread(Picture_TargetArea);            % ��ȡ ʮ�� ��ͼƬ
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea); % ת�� ʮ��ͼƬΪ PTB ����
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % PTB����
    Screen('TextSize', window, PTB_Text_Size);                      % ���������С
    Screen('TextFont', window, 'simhei');                           % ��������
    DrawFormattedText(window, double(Screen_Strings_A), 'center','center', Color_white); % ��ʾ����
    Screen('Flip', window);% ������ʾ
	% ������̰���
	KbName('UnifyKeyNames');
    Key_O=KbName(Key_Right_String);         % ��������Ҽ�ͷ��
    Key_X=KbName(Key_Wrong_String);         % ����������ͷ��
    Key_Rest=KbName(Key_Restart_String);	% �����˳���
	Key_Exit=KbName(Key_Quit_String);       % �����˳���
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
    outp(hex2dec(Trigger_Port),0);	% ���0 
end
%% ��ѭ������
for Main_Index=1:length(DATA_Input_Cell)    % ����ѭ��
    %% ��ȡ��Ƶ��Ϣ
    Temp=Play_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=DATA_Input_Cell(Temp,1);       % ��ȡ���
    Temp_Video_Class=cell2mat(DATA_Input_Cell(Temp,2));    % ��ȡ���
    Temp_Video_Speed=cell2mat(DATA_Input_Cell(Temp,3));    % ��ȡ�ٶ�
    Temp_Video_Form=DATA_Input_Cell(Temp,4);    % ��ȡ�ļ�����
    Temp_CarCode=char(DATA_Input_Cell(Temp,5));      % ��ȡ���ƺ�
	Temp_Trigger_Num=floor(Temp_Video_Speed+1);		% ��ȡ Trigger �ı�� ��1��ʼ
    Temp_Speed=Temp_Video_Speed/10.0;%�����ٶ�
    keyIsDown=0;      % ��ʼ��������ʶ��
	outp(hex2dec(Trigger_Port),0);	% Trigger ���� 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ת����ʽ (����Excel ��������������֣������ڴ�ת��Ϊ�ַ�)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Temp_Video_Class<10) % ��Ƶ���ת��Ϊ�ַ�
        Temp_Category_Char=[int2str(0),int2str(Temp_Video_Class)];% �����
    else
        Temp_Category_Char=num2str(Temp_Video_Class);              % ת��Ϊ�ַ���
    end
    if (Temp_Video_Speed<10) % ��Ƶ�ٶ�ת��Ϊ�ַ�
        Temp_Speed_Char=[int2str(0),strrep(num2str(Temp_Video_Speed),'.','')];   % ����� ȥ��С����
    else
        Temp_Speed_Char=num2str(Temp_Video_Speed);                % ת��Ϊ�ַ���
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(Speed_Mode==1)
        Temp_Speed_Char='01'; % ����Ϊ 01 ����ʹ�� 0.1 m/s ��Ƶ�ļ���Ϊ����
    end
    Temp_VideoName=[char(Temp_Category_Char),'-',char(Temp_Speed_Char),char(Temp_Video_Form)]; % �����Ƶ�ļ���
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
        disp(['-->���: ',num2str(Main_Index),'  -->��Ƶ�ļ�: ',Temp_VideoName,'  -->�����ٶȿ���: ',num2str(Temp_Video_Speed/1.0),' ��'])
        if(Flag_Change_Random)
            Temp_Text='�ı�';
        else
            Temp_Text='���ı�';
        end
        disp(['-->ԭʼ����: ',char(Temp_CarCode),' --> [',Temp_Text,'] --> ',char(Display_CarCode)])
    end
    %% ��ʾ���� �� ������Ƶ
    if(PTB_Flag==1)
        %% ��ʾ��λ
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(Cross_Wait_Time(unidrnd(5)));
        %% ��ʾ����
        DrawFormattedText(window, double(char(Display_CarCode)), 'center', 'center', Color_white); % ��ʾ����
        Screen('Flip',window);
        WaitSecs(0.2);
        %% ��Ƶ����
        [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
        if(Speed_Mode == 1)
            Play_Rate=Temp_Video_Speed/1.0;
        end
        Screen('PlayMovie',Car_MoviePtr, Play_Rate); % ����ӰƬ���ŵ��ǵ��������� 0 ������ 1 �����ٶȲ��� -1 �����ٶȵ���
		outp(hex2dec(Trigger_Port),Temp_Trigger_Num);	% ��� Trigger ���
        while (1) % ��֡������Ƶ
            if(Video_Interrupt == 1)% ���ռ��̰���
                keyIsDown=0;      % ��ʼ��������ʶ��
                [keyIsDown, ~, keyCode, ~]=KbCheck;
                if (keyIsDown==1 && (keyCode(Key_O)||keyCode(Key_X)||keyCode(Key_Exit))) % �ж��Ƿ��ǰ��� �����Ƿ������Ҽ�ͷ��
                    break
                end
            end
			% ��֡��ȡ��Ƶͼ��
			Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
            if (Movie_IMG_Temp<=0) %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                outp(hex2dec(Trigger_Port),0);	% ���0 
				break
            end
            % ���»���
            Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
        end
		outp(hex2dec(Trigger_Port),Trigger_End_Num);	% ��� Trigger_End_Num ��ֹ ��
        Screen('CloseMovie', Car_MoviePtr);
        Screen('Flip', window);% ������ʾ (ȥ��һЩ��Ƶ����)
        %% ѡ���
        if(keyIsDown~=1)
            DrawFormattedText(window, double(Screen_Strings_B), 'center', 'center', Color_white); % window,����,X���꣬Y���꣬��ɫ
            Screen('Flip', window);% ������ʾ
           if(Auto_Anwser==0)
               %% ��������
                while(1)  
                    [keyIsDown, ~, keyCode, ~]=KbCheck;
                    if (keyIsDown==1 && (keyCode(Key_O)||keyCode(Key_X)||keyCode(Key_Exit))) % �ж��Ƿ��ǰ��� �����Ƿ������Ҽ�ͷ��
                        break
                    end
                end
           else
               %% �Զ����ɰ���Ӧ��
               keyCode(Key_X)=unidrnd(2)-1; % ������ɴ�
               if(keyCode(Key_X)==1)
                   keyCode(Key_O)=0;
               else
                   keyCode(Key_O)=1;
               end
           end
        end
        %% �ж�ѡ���Ƿ���ȷ�������Ҽ�ͷ��ʾ
        if(Flag_Change_Random==1)% ��ʾ��һ��
            if (keyCode(Key_O)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        else % һ�µ����
            if (keyCode(Key_X)==1)
                Temp_Anwser=1;
            else
                Temp_Anwser=0;
            end
        end
		% �ж��˳�
		if(keyCode(Key_Exit)==1)
			break
		end
        keyCode(Key_O)=0;    % ����
        keyCode(Key_X)=0;    % ����
        keyIsDown=0;        % ����
        %% ����1��
        Screen('Flip',window);  % ������ʾ
        WaitSecs(1); % ��Ļ�ȴ�ʱ��
    else % ����ģʽʹ��������ɷ�ʽ
        Temp_Anwser=unidrnd(2)-1; % ������ɴ�
		outp(hex2dec(Trigger_Port),Temp_Trigger_Num);	% ��� Trigger ���
		pause(0.1);
		outp(hex2dec(Trigger_Port),0);	% Trigger ����
		pause(0.1);
		outp(hex2dec(Trigger_Port),Trigger_End_Num);	% ��� Trigger ������
    end
    if(Log_Flag==1)
        if(Temp_Anwser)
            Temp_Text='O  ��ȷ';
        else
            Temp_Text='X  ����ȷ';
        end
        disp(['-->�û��ش�: ',Temp_Text])
		disp(['-->Trigger : ',num2str(Temp_Trigger_Num)])
        disp(['  '])
    end
    %% ��¼����
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %��¼���
    OutPut_Cell(Main_Index,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(Main_Index,3)={Temp_VideoName};%��¼��Ƶ�ļ���
    OutPut_Cell(Main_Index,4)={Temp_CarCode};  %��¼���ƺ�
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Speed);  % ��¼�ٶ�
    OutPut_Cell(Main_Index,6)=num2cell(Temp_Anwser); %��¼�ش�����
    %% �Դμ���ͣ��Ϣ
    if(PTB_Flag==1)
        if(mod(Main_Index,Rest_Num)==0)
            DrawFormattedText(window, double(Screen_Strings_C), 'center', 'center', Color_white);
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
	if(length(OutPut_Cell)==(Excel_End-1))
		DrawFormattedText(window, double(Screen_Strings_D), 'center', 'center', Color_white);
	else
		DrawFormattedText(window, double(Screen_Strings_E), 'center', 'center', [1,0,0]);
	end
    Screen('Flip', window);% ������ʾ
    WaitSecs(5);
    sca % �ر���Ļ
end
%% ʵ������ʾ
if(Log_Flag==1)
    Temp={'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ٶ�(m/s)','�ش�����(1Ϊ��ȷ,0Ϊ����)'}
    OutPut_Cell
end
%% ��¼�� Excel �ļ�
if(length(OutPut_Cell)==(Excel_End-1))
	xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ٶ�(m/s)','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:F1')
	xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','F',num2str(Excel_End)])
	if(Log_Flag==1)
		disp(['-->ʵ�����ݱ���ɹ� ��'])
	end
	%% ���ݷ�������
	Speed_All=unique(cell2mat(OutPut_Cell(:,5)))/1.0; % ��ȡȫ���ٶ�
	Speed_All=Speed_All';   % ת�þ���
	Correct_Speed=[];       % �ٶ�
	for Speed_index=1:Speed_Num % ѭ���õ�ÿ���ٶȵ���ȷ��
		Correct_Speed(Speed_index)=length(...       % ���ܳ���
		intersect((find(cell2mat(OutPut_Cell(:,5))==Speed_All(Speed_index))),...  % intersect ��þ���Ľ��� OutPut_Cell(:,5) �õ��ٶ���
		(find(cell2mat(OutPut_Cell(:,6))==1)))); % ������ȷ����  OutPut_Cell(:,6) ����
	end
	Correct_Speed=Correct_Speed/double(CarCode_Class_Num); % ������ȷ�� ÿ��/��Ŀ����(����������)
	Speed_All       % ��ӡ�ٶ�
	Correct_Speed   % ��ӡ��ȷ��
	%% ��ͼ����
	Figure_Arrow=[repmat('\uparrow',length(Correct_Speed),1)]; % ���ɼ�ͷ
    Figure_Number=[num2str(roundn((Correct_Speed')*100,-1)),repmat(' %',length(Correct_Speed),1)]; %����ͼ������
	figure; % ��ͼ
	plot(Speed_All,Correct_Speed,'bo-'); % ��ͼ
	axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % ������������ָ��������
	xlabel('�ٶ�');       % X�� ����
	ylabel('��ȷ��');     % Y�� ����
	title([VolunteerName,' �Ĳ��Խ��ͳ��']); % ͼ�� ����
	% ���ݱ�ע
    Adjust_Temp=ones(1,length(Speed_All));
    Adjust_Temp(1,1)=0.85;
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center');   % ����ͷ
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.1),cellstr(Figure_Number),'center');   % ���ٷֱ�
end
clear all       % �ͷ�������Դ