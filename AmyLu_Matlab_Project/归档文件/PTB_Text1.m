% Clear the workspace and the screen
close all;
clearvars;
sca

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');
Screen('Preference', 'SkipSyncTests', 1)    % �������
% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Draw text in the upper portion of the screen with the default font in red
%Screen('TextSize', window, 70);
%DrawFormattedText(window, 'Hello World', 'center',screenYpixels * 0.25, [1 0 0]);

% Draw text in the middle of the screen in Courier in white
%Screen('TextSize', window, 80);
%Screen('TextFont', window, 'Courier');
%DrawFormattedText(window, 'Hello World', 'center', 'center', white);

% Draw text in the bottom of the screen in Times in blue
%Screen('TextSize', window, 90);
%Screen('TextFont', window, 'Times');
%DrawFormattedText(window, 'Hello World', 'center',screenYpixels * 0.75, [0 0 1]);
AnswerNum=3;
% ���ݳ�ʼ��
FolderPath='E:\AmyLu_Matlab_Project\';	% ����ļ���ַ
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];
Picture_Wait_5s=[FolderPath,'5swait.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,'A2:C21');  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) �ļ���
% Video_Name_C(N,3) ���ƺ�
CarCodeAll=unique(Video_Name_C(:,3))
Random_Series=randperm(length(Video_Name_C));   % �����������
OutPut_Cell={}; % ����ĳ�ʼ��


Screen('TextSize', window, 50);
Screen('TextFont', window, 'SimHei'); 

for n=1:length(Video_Name_C)    % ����ѭ��
    Temp=Random_Series(n);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_VideoName=Video_Name_C(Temp,2);    % ��ȡ�ļ���
    Temp_CarCode=Video_Name_C(Temp,3);      % ��ȡ���ƺ�
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
WaitSecs(2);
    %% ѡ���   ������ѡ��->����ʾѡ��->����ȡ���̰�ť��->���ж϶Դ�
    %Temp_Anwser=unidrnd(2)-1;    % Ŀǰ������������� �𰸶Դ�
    Temp_CarCode_Index=find(strcmp(CarCodeAll,Temp_CarCode)==0);
    Random_CarCode_Index=randperm(length(Temp_CarCode_Index));
    CarCodeChoose={};
    keyIsDown=0;
    for i=1:AnswerNum
        if (i==1)
            CarCodeChoose(1,i)=Temp_CarCode;
        else
            CarCodeChoose(1,i)=CarCodeAll(Temp_CarCode_Index(Random_CarCode_Index(i-1)));
        end
    end
    PTB_Display_Index=randperm(AnswerNum);
	DrawFormattedText(window, '�����������ȷѡ��ǰ�����:', 'center', screenYpixels * (1/7), white); % [window,����,X���꣬Y���꣬��ɫ]
	for i=1:AnswerNum
    		DrawFormattedText(window, [' ',num2str(i),'  ',CarCodeChoose(1,PTB_Display_Index(i))], 'center', screenYpixels * (1/7)*(i+2), white);
	end
Screen('Flip', window);% ������ʾ
RightAnswer=find(PTB_Display_Index==1);
    %��������
    [keyIsDown, ~, keyCode, ~]=KbCheck;
    while(keyIsDown==0)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
    end
    % 49 ��Ӧ����ֵ 1 
    if (keyCode(1,49+(RightAnswer-1))==1)
        Temp_Anwser=1;
    else
        Temp_Anwser=0;
    end
    disp(['-->ѡ����ȷ���: ',num2str(Temp_Anwser)])
    keyIsDown=0;
    %��¼����
    OutPut_Cell(n,1)=num2cell(n);   %��¼���
    OutPut_Cell(n,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(n,3)=Temp_VideoName;%��¼��Ƶ�ļ���
    OutPut_Cell(n,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(n,5)=num2cell(Temp_Anwser); %��¼�ش�����
end

% Flip to the screen
%Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;

% Clear the screen
sca;