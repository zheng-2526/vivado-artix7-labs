# 05 指令 ROM

[下载 5inst_rom_display.bit](bitstream/5inst_rom_display.bit)

指令 ROM。直接在 LCD 输入十六进制字节地址。地址 0 的 INST 为 24010001，地址 4 为 00011100。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
