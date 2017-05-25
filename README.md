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

## 工作日志 </br>
* 2017.04.19 程序结构大体写好 主要问题集中在 PTB 的展示部分(无法调试所以无法编写)</br>
	1.视频播放 播放视频 以及 提示部分， 提示为 预示视频播放将要开始的程序 类似 PTB 启动的时候的叹号</br>
	2.选择车牌作答 程序返回1或者0(1为正确值，0为错误值)，程序主要利用PTB工具进行选择</br>
	3.采集脑电信号需要了解清楚，之后想办法融合到Matlab中去</br>
	
* 2017.04.19 为亲爱的讲解函数,查找 PTB 错误解决方法</br>
* 2017.04.20 为亲爱的简化视频制作流程，增加新建的工程文件</br>
* 2017.04.28 去北理工解决问题 </br>
	1. 64位 电脑 Matlab 2015 b gstreamer 1.10.2 解决视频播放</br>
	2. 完成程序 [重点是车牌选择部分]</br>
	3. 制作视频播放 Demo</br>
	4. 卢加文 导师建议： A.按照实验范式 B.速度加快，速度分布为 0.1m/s ~ 0.7m/s 【440*140px】</br>
	5. 判断方式为 1.先给出车牌字符串(变化中间三位数字) 2.播放视频  3.判断是否与视频中一致</br>
	
* 2017.04.29 编写程序 实现功能 </br> 
* 2017.05.02 优化程序方案 添加注释</br>
* 2017.05.03 增加播放控制，方法还在论证中 【可以正常播放调速度，但是倒放程序本身出现问题】,帮助亲爱的更新程序，完成功能上的实现</br>
* 2017.05.04 增加视频速度提取功能，添加注释,练习使用分支；更新操作说明</br>
* 2017.05.05 帮助亲爱的完成 部分功能修改[休息功能，DATA表格文件名称拆分]，另外视频文件需要重新设计【教给亲爱的视频软件Pr的操作技巧】 </br>
* 2017.05.08 用 Python 编写 车牌生成函数</br> 
* 2017.05.09 完善Python程序，生成文本，制作Ps模板，批量生成psd文件，完善视频项目</br>
* 2017.05.11 A.完善Matlab程序，主实验程序添加视频播放时的键盘键入中断程序  B. 做Matlab DATA 数据表的生成程序  C. 整理项目目录  D. 帮助亲爱的生成视频文件</br>
* 2017.05.12 修改Txt,Ps,视频文件，完善主实验程序</br>
* 2017.05.15 完善视频中断程序</br>
* 2017.05.16 增加实验结束后的统计功能,并用Matlab生成图</br>
* 2017.05.17 A.测试播放函数，改变速率播放视频；B.制作分析程序，完善V2程序；C.制作0.75m/s视频</br>
* 2017.05.18 根据导师要求，修改随机序列相邻项重复类别问题; 完善图表显示</br>
* 2017.05.19 完善程序`Data_Generator`,`AmyLuProject`,`Data_Analysis`程序，解决视频文件名问题，优化文件路径自动读取，主实验程序添加志愿者名字输入功能;帮亲爱的调程序，加入统计功能</br>
* 2017.05.21 修改程序细节部分，检查视频播放问题</br>
* 2017.05.25 完善程序，在原有基础上进一步提炼;增加中断程序;修正统计分析函数的车牌种类统计函数部分;完善图表绘制程序部分</br>


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
[1. PTB OpenMovie 函数说明 http://docs.psychtoolbox.org/OpenMovie](http://docs.psychtoolbox.org/OpenMovie)</br>
[2. PTB PlayMovie 函数说明 http://docs.psychtoolbox.org/PlayMovie](http://docs.psychtoolbox.org/PlayMovie)</br>
[3. PTB Screen 函数说明 http://docs.psychtoolbox.org/Screen](http://docs.psychtoolbox.org/Screen)</br>
[4. PTB FAQ https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ)</br>
[5. PTB 官网  http://psychtoolbox.org/](http://psychtoolbox.org/)</br>
[6. PTB Demo例子 http://peterscarfe.com/ptbtutorials.html](http://peterscarfe.com/ptbtutorials.html)</br>
[7. PTB Text 例子程序 http://peterscarfe.com/textdemo.html](http://peterscarfe.com/textdemo.html)</br>
