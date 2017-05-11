% Clear the workspace and the screen
close all;
clearvars;
sca

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');
Screen('Preference', 'SkipSyncTests', 1)    % 跳过检查
Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 GBK
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
Screen('TextSize', window, 70);
Screen('TextFont', window, 'simhei');
DrawFormattedText(window, double('老婆大大'), 'center',...
    screenYpixels * 0.25, [1 0 0]);

% Draw text in the middle of the screen in Courier in white
Screen('TextSize', window, 50);
Screen('TextFont', window, 'simhei');
DrawFormattedText(window, double('我爱你'), 'center', 'center', white);
 DrawFormattedText(window, double('请键盘输入正确选择前的序号:'), 'center', screenYpixels * (1/7), white);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', window, 90);
Screen('TextFont', window, 'simhei');
DrawFormattedText(window, double('你最懒了！！！'), 'center',...
    screenYpixels * 0.75, [0 0 1]);


% Flip to the screen
Screen('Flip', window);
WaitSecs(2); % 屏幕等待时间

Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;

% Clear the screen
sca;