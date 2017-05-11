clc;
close all
clear all
sca
%%
PTB_Flag=1; % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% ����ļ���ַ
Excel_Start='A2';
Excel_End='C21';
VolunteerName='LeoLiu'; 
AnswerNum=3;
% ���ݳ�ʼ��

Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];
Picture_Wait_5s=[FolderPath,'5swait.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,[Excel_Start,':',Excel_End]);  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) �ļ���
% Video_Name_C(N,3) ���ƺ�
CarCodeAll=unique(Video_Name_C(:,3))
Random_Series=randperm(length(Video_Name_C));   % �����������
OutPut_Cell={}; % ����ĳ�ʼ��
%% PTB���߳�ʼ��
if(PTB_Flag==1)
    PsychDefaultSetup(2);
    Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ GBK
    Screen('Preference', 'SkipSyncTests', 1)    % �������
    screenGrps=Screen('Screens');   % ��ʼ�� ��Ļ
    screenNumber=max(screenGrps);  % Select the external screen if it is present, else revert to the native
    Color_black = BlackIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_white = WhiteIndex(screenNumber);
    Color_grey = Color_white / 2;
    %[window,rect] = Screen('OpenWindow', screenid,Color_black);  % PsychImaging
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    Picture_Read_TargetArea= imread(Picture_TargetArea);
    Picture_Read_Wait_5s= imread(Picture_Wait_5s);
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea);
    PTB_IMG_Wait_5s=Screen('MakeTexture',window ,Picture_Read_Wait_5s);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, 50);
    Screen('TextFont', window, 'simhei'); 
end
%% ��ѭ������
for Main_Index=1:length(Video_Name_C)    % ����ѭ��
    Temp=Random_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_VideoName=Video_Name_C(Temp,2);    % ��ȡ�ļ���
    Temp_CarCode=Video_Name_C(Temp,3);      % ��ȡ���ƺ�
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    %������ʾ��Ƶ
    %������Ƶ
    if(PTB_Flag==1)
        % ��Ŀ
        Screen('DrawTexture', window ,PTB_IMG_Wait_5s);
        Screen('Flip',window);
        WaitSecs(4);
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(1);
        [ssss] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',ssss, 1);
        while (1) % ��֡������Ƶ
            tex = Screen('GetMovieImage', window, ssss); % ���һ֡��Ƶͼ��
            if tex<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                break
            end
            %���»���
            Screen('DrawTexture', window, tex);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', tex);% �ͷ���Ƶ��Դ
        end
    end
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
    % Draw text in the middle of the screen in Courier in white
    if(PTB_Flag==1)
        DrawFormattedText(window, double('��ʹ�ü���������ȷѡ��ǰ�����:'), 'center', screenYpixels * (1/7), Color_white); % window,����,X���꣬Y���꣬��ɫ
        for i=1:AnswerNum
            DrawFormattedText(window, double([' ',num2str(i),'  ',char(CarCodeChoose(1,PTB_Display_Index(i)))]), 'center', screenYpixels * (1/7)*(i+2), Color_white);
        end
        Screen('Flip', window);% ������ʾ
    end
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
    disp(['-->��',num2str(Main_Index),'��ѡ���û��ش���ȷ���: ',num2str(Temp_Anwser),'( 1 ��ȷ 0 ����)'])
    keyIsDown=0;
    %��¼����
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %��¼���
    OutPut_Cell(Main_Index,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(Main_Index,3)=Temp_VideoName;%��¼��Ƶ�ļ���
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Anwser); %��¼�ش�����
end
%% 
DrawFormattedText(window, [double('��л���뱾�β���'),double('���β��Ե��˽�����'),double('лл��ף����죡')], 'center', 'center', Color_white);
Screen('Flip', window);% ������ʾ
WaitSecs(5);
sca % �ر���Ļ
OutPut_Cell
xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])
%xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName)