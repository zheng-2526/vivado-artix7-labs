# 12 数据 RAM

[下载 12data_ram_display.bit](bitstream/12data_ram_display.bit)

数据 RAM。SW18:SW19 的 00 输入 ADDR、01 输入 WDATA、10 输入 T_ADD。SW20～SW23 是四个字节写使能，先全部向上输入地址和数据，再拨下对应写使能写入，最后拨回。例：ADDR=4、WDATA=12345678，全字写入后输入 T_ADD=4，T_DAT 应显示 12345678。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
