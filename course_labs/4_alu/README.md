# 04 32 位 ALU 和循环右移

[下载 4alu_display.bit](bitstream/4alu_display.bit)

32 位 ALU。按 SW19:SW18 排列，00 输入控制字、10 输入 A、11 输入 B。控制字、操作数各按一次 OK。LCD 的 RESUL 显示结果，C_Z 的 bit 1 是进位，bit 0 是零标志。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
