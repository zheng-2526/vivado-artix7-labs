# 11 带 MUL 指令的单周期 CPU

[下载 11single_cycle_mul_display.bit](bitstream/11single_cycle_mul_display.bit)

单周期 CPU 增加 MIPS MUL 指令。初次复位后单步执行，预置程序把 −3×7 写到 REG03，再存入字节地址 0。执行四条指令后 REG03 和 MDATA 应为 FFFFFFEB。

当前目录包含本实验的 Verilog 和 `board.xdc`，共享组件在 [common](../common/)。
Vivado 下载方法、拨码开关和完整验收步骤见 [上板说明](../../docs/board-guide.md)。
