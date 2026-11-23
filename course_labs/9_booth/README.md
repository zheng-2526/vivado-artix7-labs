# 09 基 4 Booth 乘法器

[下载 9booth_display.bit](bitstream/9booth_display.bit)

基 4 Booth 串行乘法，每步处理两个乘数位，运算核心用 16 步。操作和 2multiply_display.bit 相同。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
