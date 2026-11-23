# 08 五级流水线 CPU

[下载 8pipeline_cpu_display.bit](bitstream/8pipeline_cpu_display.bit)

五级流水线 CPU。每按一次 SW_STEP0 推进一步。看各级 PC、VALID、HI 和 LO。输入字节地址后再按一步可刷新同步 RAM 的读数。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
