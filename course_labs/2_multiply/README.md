# 02 基础有符号乘法器

[下载 2multiply_display.bit](bitstream/2multiply_display.bit)

32 位有符号串行乘法。先把 SW19 拨上。SW18=0 输入 A，SW18=1 输入 B。输入后把 SW19 拨下启动。LCD 的 PRO_H、PRO_L 显示 64 位乘积，DONE=1 表示完成。每次重算先把 SW19 拨回 0，再拨到 1。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
