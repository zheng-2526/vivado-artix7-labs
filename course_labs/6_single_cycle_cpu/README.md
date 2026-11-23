# 06 单周期 CPU

[下载 6single_cycle_cpu_display.bit](bitstream/6single_cycle_cpu_display.bit)

单周期 CPU。按 SW_STEP0 逐条执行预置程序。看 PC、INST 和 REGnn。触摸输入字节地址可观察 MADDR 和 MDATA。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
