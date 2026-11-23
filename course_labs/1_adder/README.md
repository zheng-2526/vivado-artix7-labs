# 01 32 位加法器

[下载 1adder_display.bit](bitstream/1adder_display.bit)

32 位加法器。SW18=0 输入 A，SW18=1 输入 B。SW19 设置 Cin，SW20=0 选择直接加法，SW20=1 选择串行进位。LCD 的 STYLE 显示当前实现。输入 A=FFFFFFFF、B=1、Cin=0，切换两种实现时都应看到 RESUL=00000000、C_Z=00000003。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
