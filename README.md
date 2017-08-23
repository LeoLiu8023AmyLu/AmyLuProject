# AmyLuProject
研究生项目 关于脑电实验

## 主要文件:</br>
* Code :</br>
	1. `Data_Generator` 根据**txt数据，速度信息**生成 **Excel**文件</br> 
	2. `AmyLuProject` 主要实验程序，利用PTB工具进行实验</br>
	3. `Data_Analysis` 实验数据 **分析统计** 文件</br>

* Media :</br>
	1. `Adobe Photoshop` 文件，主要批量生成**车牌文件**</br>
	2. `Adobe Premiere` 文件，批量生成**视频文件**</br>
	3. `电子表格` 根据**屏幕尺寸、像素、视频尺寸、对象尺寸**得到制作的尺寸以及**视频时间**</br>



## 流程</br>
> 实验主程序流程:</br>
>> Step 0 	: 初始化数据</br>
>> Step 1 	: 初始化PTB</br>
>> Step 2 	: 显示实验说明</br>
>> Step 3 	: 等待键盘任意键输入</br>

>>> Step 4 	: 主循环：读取视频信息</br>
>>> Step 5 	: 主循环：变化车牌</br>
>>> Step 6 	: 主循环：显示十字及车牌</br>
>>> Step 7 	: 主循环：播放视频</br>
>>> Step 8 	: 主循环：选择判断</br>
>>> Step 9 	: 主循环：黑屏1秒</br>

>> Step 10 : 主循环：记录信息</br>
>> Step 11 : 保存Excel+绘制图表</br>
>> Step 12 : 结束程序</br>

## 相关资料：</br>
关于 PTB Screen 函数的一些网址：</br>
1. [ PTB OpenMovie 函数说明 http://docs.psychtoolbox.org/OpenMovie](http://docs.psychtoolbox.org/OpenMovie)</br>
2. [ PTB PlayMovie 函数说明 http://docs.psychtoolbox.org/PlayMovie](http://docs.psychtoolbox.org/PlayMovie)</br>
3. [ PTB Screen 函数说明 http://docs.psychtoolbox.org/Screen](http://docs.psychtoolbox.org/Screen)</br>
4. [ PTB FAQ https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ)</br>
5. [ PTB 官网  http://psychtoolbox.org/](http://psychtoolbox.org/)</br>
6. [ PTB Demo例子 http://peterscarfe.com/ptbtutorials.html](http://peterscarfe.com/ptbtutorials.html)</br>
7. [ PTB Text 例子程序 http://peterscarfe.com/textdemo.html](http://peterscarfe.com/textdemo.html)</br>
8. [ InpOut32 and InpOutx64](http://www.highrez.co.uk/Downloads/InpOut32/default.htm)<br>
9. [ Mex-File Plug-in for Fast MATLAB Port I/O (64-bit Windows XP, Vista, 7)](http://apps.usd.edu/coglab/psyc770/IO64.html)<br>
