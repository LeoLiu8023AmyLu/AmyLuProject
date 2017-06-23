clc;
close all
clear all
%% ���ò���
config_io;
outp(hex2dec('E000'),0);
AssertOpenGL;
setnum=0;

%% ��Ƶ����
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
% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('TextSize', window, 100);
Screen('TextFont', window, 'simhei'); 
%% �����Ƶ·��
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % �Զ���ȡ .m �ļ�Ŀ¼ �����Ŀ������ļ�λ�ò�Ҫ�ı�
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1);  % ��ñ���е�����
DATA_Input_Cell=RAW(2:end,:); % ȥ����ͷ�������� 
CarCodeAll=unique(DATA_Input_Cell(:,5));   % ��ȡȫ��������Ϣ
Excel_Start=2;                          % Excel ��ʼ����
Speed_Num=length(unique(cell2mat(DATA_Input_Cell(:,3)))); % �ٶȵ������
CarCode_Class_Num=length(CarCodeAll);   % ���������
Excel_End=Excel_Start+CarCode_Class_Num*Speed_Num-1; % ���� Excel ��������
OutPut_Cell={}; % ����ĳ�ʼ��
%% ��Ƶ����
Play_Series=sortrows(DATA_Input_Cell,3);    % �����ٶ�����
Play_Series=cell2mat(Play_Series(:,1));     % ��ȡ��һ����� �� ת��Ϊ����ṹ����

for Main_Index=1:length(DATA_Input_Cell)
	Temp=Play_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=DATA_Input_Cell(Temp,1);       % ��ȡ���
    Temp_Video_Class=cell2mat(DATA_Input_Cell(Temp,2));    % ��ȡ���
    Temp_Video_Speed=cell2mat(DATA_Input_Cell(Temp,3));    % ��ȡ�ٶ�
    Temp_Video_Form=DATA_Input_Cell(Temp,4);    % ��ȡ�ļ�����
    Temp_CarCode=char(DATA_Input_Cell(Temp,5));      % ��ȡ���ƺ�
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
    Temp_VideoName=[char(Temp_Category_Char),'-',char(Temp_Speed_Char),char(Temp_Video_Form)]; % �����Ƶ�ļ���
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    Car_MoviePtr{Main_Index} = Screen('OpenMovie', window,VideoFileName);
end

for Main_Index=1:length(DATA_Input_Cell)
    tic;
    setnum = 1
    outp(hex2dec('E000'),setnum);
    Screen('PlayMovie',Car_MoviePtr{Main_Index}, 1);
    outp(hex2dec('E000'),0);
    while (1) % ��֡������Ƶ
        Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % ���һ֡��Ƶͼ��
        if Movie_IMG_Temp<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
			break
		end
		%���»���
		Screen('DrawTexture', window, Movie_IMG_Temp);% ����ͼ��
		Screen('Flip', window);% ������ʾ
		Screen('Close', Movie_IMG_Temp);% �ͷ���Ƶ��Դ
    end
     %% ����1��
	Screen('Flip',window);  % ������ʾ
	WaitSecs(1); % ��Ļ�ȴ�ʱ��
	Screen('CloseMovie', Car_MoviePtr);
	toc;
end
sca