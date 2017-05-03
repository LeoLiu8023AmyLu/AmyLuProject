# AmyLuProject
老婆的研究生项目

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
* 2017.05.03 增加播放控制</br>


## 相关资料：</br>
关于 PTB Screen 函数的一些网址：</br>
[1. PTB OpenMovie 函数说明 http://docs.psychtoolbox.org/OpenMovie](http://docs.psychtoolbox.org/OpenMovie)</br>
[2. PTB PlayMovie 函数说明 http://docs.psychtoolbox.org/PlayMovie](http://docs.psychtoolbox.org/PlayMovie)</br>
[3. PTB Screen 函数说明 http://docs.psychtoolbox.org/Screen](http://docs.psychtoolbox.org/Screen)</br>
[4. PTB FAQ https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ)</br>
[5. PTB 官网  http://psychtoolbox.org/](http://psychtoolbox.org/)</br>
[6. PTB Demo例子 http://peterscarfe.com/ptbtutorials.html](http://peterscarfe.com/ptbtutorials.html)</br>
[7. PTB Text 例子程序 http://peterscarfe.com/textdemo.html](http://peterscarfe.com/textdemo.html)</br>