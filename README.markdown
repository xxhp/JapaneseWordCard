Japanese Word Card
==================


给自己用的日语背单词小程序，也算是习作。
我是外行，而且是边做边设计功能的，所以代码非常混乱，有很多“Hack”和Magic Number啥的，所以我自己都不忍心看自己的代码，拍砖请手下留情。


**TODO：**

- 加入生词本导出功能；
- 加入iOS 5的词典服务支持；
- 优化单词记忆流程，加入测试模式；
- 某些目前还没有想到的功能。


**使用方法：**

1. 下载，编译；
2. 如果进行机上测试，请通过iTunes把辞典文件同步到程序中；
3. 如果在Simulator中测试，把文件放到NSHomeDirectory()中，OSX下的路径类似：/Users/*YourName*/Library/Application Support/iPhone Simulator/4.3.2/Applications/DAEF760E-91D4-41CD-9168-2CD620529E28的目录下；
4. 运行并使用。


**版权说明：**

代码随意使用和参考。不过请不要把这个App简单的改个名字，改几个变量名就扔到AppStore去卖。如果是免费软件，我也就不想计较了；如果是收费软件，则必须经过我的允许。
FMDataBase的源码版权请参考这里（https://github.com/ccgus/fmdb/blob/master/LICENSE.txt）。


**其他：**

测试用的词典数据库下载地址： http://d.pr/NaxK 词典数据库来自网络下载，版权所属不明，仅供个人测试使用。


**致谢：**

本程序使用了开源的SQLite3 Objective-C Wrapper, FMDatabase(https://github.com/ccgus/fmdb)，在此表示感谢。
