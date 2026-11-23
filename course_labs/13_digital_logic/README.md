# 13 BCD、计数器与引脚演示

[下载 13bcd_counter_display.bit](bitstream/13bcd_counter_display.bit)

八个拨码开关组成一个 0～255 的二进制输入，LCD 显示 INPUT（十六进制）和 BCD（十进制数字）。SEC 每秒加 1，59 后回到 00。LED 显示各开关状态。配套的 board.xdc 可以用来练习重新分配引脚。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
