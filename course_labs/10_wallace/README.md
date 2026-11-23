# 10 Wallace 树乘法器

[下载 10wallace_display.bit](bitstream/10wallace_display.bit)

Booth 部分积和 Wallace 进位保存压缩树。操作和 2multiply_display.bit 相同。可用 A=FFFFFFFD、B=7 对照三个乘法器，结果 PRO_H:PRO_L 应是 FFFFFFFF:FFFFFFEB。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
