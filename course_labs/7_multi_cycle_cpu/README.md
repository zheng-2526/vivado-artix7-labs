# 07 多周期 CPU

[下载 7multi_cycle_cpu_display.bit](bitstream/7multi_cycle_cpu_display.bit)

多周期 CPU。每按一次 SW_STEP0 推进一步，单条指令会跨多个步。看 IF_PC、ID_PC、EXEPC、MEMPC、WB_PC 和 STATE。输入字节地址后再按一步可刷新同步 RAM 的读数。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
