# catfish

## 消灭数字

一个用Flutter编写的小游戏。在 10 x 16 的格子中，每个格子随机出现 1-9 的数字。圈出加起来的和为10的数字。

## 版本计划
- [x] 1.0.0 完成基本的数字圈出功能，统计本局分数。
- [x] 1.5.0 每局游戏限时2分钟，统计最高分，完善游戏画面。
- [ ] 2.0.0 完善游戏界面，加入动画

### 命令行备忘

1. 命令行编译Web：  
   C:\flutter\bin\flutter build web --web-renderer canvaskit --release --base-href=/catfish/

2. 修改hosts文件  
windows上hosts文件路径为 
C:\Windows\System32\drivers\etc\hosts  
刷新本地dns数据  
ipconfig /flushdns

3. 语言文本文件更新  
C:\flutter\bin\flutter gen-l10n

### todo

- [ ] 适配不同分辨率的屏幕