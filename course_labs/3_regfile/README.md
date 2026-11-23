# 03 32 × 32 位寄存器堆

[下载 3regfile_display.bit](bitstream/3regfile_display.bit)

32×32 位寄存器堆，提供两路读口。SW18 是写使能，先保持 0。SW19:SW20 的 00、01、10、11 分别选择读地址 1、读地址 2、写地址、写数据。例：设置读地址 1 和写地址为 3、写数据为 1234，短暂将 SW18 置 1 再拨回 0，RDAT1 应显示 00001234。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
