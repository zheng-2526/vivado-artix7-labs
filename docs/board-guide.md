# Artix-7 实验箱上板合集

适用于 FPGA-A7-PRJ-UDB-V1.3（xc7a200tfbg676-2）。设计使用 25 MHz 的 LCD 时钟，输入、输出和拨码编号以这一版说明为准。

## 下载到 FPGA

1. 给实验箱通电，连接 USB 下载线和板上的 JTAG 下载口。
2. 在 Vivado 2019.2 中打开 **Hardware Manager → Open Target → Auto Connect**。
3. 右键 **xc7a200t_0 → Program Device**，选择本次实验的一个 .bit 文件并点击 **Program**。
4. 屏幕就绪后按该实验的步骤操作。换实验时重新选另一个 .bit 下载即可。

下文的开关按板上丝印 SW18～SW25 称呼。拨下为 1，拨上为 0。需要触摸输入时，先拨好开关，再点 **START INPUTING**，键入十六进制数字，点 **OK**。FPGA_RST 会复位当前实验。各 CPU 使用 **SW_STEP0** 单步，按下再松开一次完成一个时钟步。

## 截图里的八项

| 文件 | 功能和上手步骤 |
|---|---|
| 1adder_display.bit | 32 位加法器。SW18=0 输入 A，SW18=1 输入 B。SW19 设置 Cin，SW20=0 选择直接加法，SW20=1 选择串行进位。LCD 的 STYLE 显示当前实现。输入 A=FFFFFFFF、B=1、Cin=0，切换两种实现时都应看到 RESUL=00000000、C_Z=00000003。 |
| 2multiply_display.bit | 32 位有符号串行乘法。先把 SW19 拨上。SW18=0 输入 A，SW18=1 输入 B。输入后把 SW19 拨下启动。LCD 的 PRO_H、PRO_L 显示 64 位乘积，DONE=1 表示完成。每次重算先把 SW19 拨回 0，再拨到 1。 |
| 3regfile_display.bit | 32×32 位寄存器堆，提供两路读口。SW18 是写使能，先保持 0。SW19:SW20 的 00、01、10、11 分别选择读地址 1、读地址 2、写地址、写数据。例：设置读地址 1 和写地址为 3、写数据为 1234，短暂将 SW18 置 1 再拨回 0，RDAT1 应显示 00001234。 |
| 4alu_display.bit | 32 位 ALU。按 SW19:SW18 排列，00 输入控制字、10 输入 A、11 输入 B。控制字、操作数各按一次 OK。LCD 的 RESUL 显示结果，C_Z 的 bit 1 是进位，bit 0 是零标志。 |
| 5inst_rom_display.bit | 指令 ROM。直接在 LCD 输入十六进制字节地址。地址 0 的 INST 为 24010001，地址 4 为 00011100。 |
| 6single_cycle_cpu_display.bit | 单周期 CPU。按 SW_STEP0 逐条执行预置程序。看 PC、INST 和 REGnn。触摸输入字节地址可观察 MADDR 和 MDATA。 |
| 7multi_cycle_cpu_display.bit | 多周期 CPU。每按一次 SW_STEP0 推进一步，单条指令会跨多个步。看 IF_PC、ID_PC、EXEPC、MEMPC、WB_PC 和 STATE。输入字节地址后再按一步可刷新同步 RAM 的读数。 |
| 8pipeline_cpu_display.bit | 五级流水线 CPU。每按一次 SW_STEP0 推进一步。看各级 PC、VALID、HI 和 LO。输入字节地址后再按一步可刷新同步 RAM 的读数。 |

### ALU 控制字

| 操作 | 十六进制 | 操作 | 十六进制 |
|---|---|---|---|
| ADD，Cin=0 | 0800 | ADD，Cin=1 | 2800 |
| SUB | 0400 | SLT（有符号） | 0200 |
| SLTU（无符号） | 0100 | AND | 0080 |
| NOR | 0040 | OR | 0020 |
| XOR | 0010 | SLL | 0008 |
| SRL | 0004 | SRA | 0002 |
| LUI | 0001 | ROR | 1000 |

按课程接口，移位或循环右移的数据来自 B，移位量取 A 的低五位。A=00000001、B=80000001、控制字=1000 时，RESUL 应为 C0000000。用 A=80000000、B=7FFFFFFF 比较时，有符号 SLT 应输出 1，无符号 SLTU 应输出 0。

## PPT 中的扩展示例

| 文件 | 功能和上手步骤 |
|---|---|
| 9booth_display.bit | 基 4 Booth 串行乘法，每步处理两个乘数位，运算核心用 16 步。操作和 2multiply_display.bit 相同。 |
| 10wallace_display.bit | Booth 部分积和 Wallace 进位保存压缩树。操作和 2multiply_display.bit 相同。可用 A=FFFFFFFD、B=7 对照三个乘法器，结果 PRO_H:PRO_L 应是 FFFFFFFF:FFFFFFEB。 |
| 11single_cycle_mul_display.bit | 单周期 CPU 增加 MIPS MUL 指令。初次复位后单步执行，预置程序把 −3×7 写到 REG03，再存入字节地址 0。执行四条指令后 REG03 和 MDATA 应为 FFFFFFEB。 |
| 12data_ram_display.bit | 数据 RAM。SW18:SW19 的 00 输入 ADDR、01 输入 WDATA、10 输入 T_ADD。SW20～SW23 是四个字节写使能，先全部向上输入地址和数据，再拨下对应写使能写入，最后拨回。例：ADDR=4、WDATA=12345678，全字写入后输入 T_ADD=4，T_DAT 应显示 12345678。 |
| 13bcd_counter_display.bit | 八个拨码开关组成一个 0～255 的二进制输入，LCD 显示 INPUT（十六进制）和 BCD（十进制数字）。SEC 每秒加 1，59 后回到 00。LED 显示各开关状态。配套的 board.xdc 可以用来练习重新分配引脚。 |

## 源码和构建

实验目录按数字分开。寄存器堆、存储器、CPU 和 LCD 驱动沿用龙芯培训资料的示例接口；串行／Booth 乘法器和数字逻辑演示是本工程新增的 RTL。Wallace 版保留课程树结构并修正压缩器连接。加法器、ALU、单周期 MUL、CPU 存储器和上板时钟均做了适配。

源码包中的 course_labs 下有 Verilog、引脚约束、CPU 程序及配套 LCD 检查点。保留目录结构，用 Vivado 2019.2 运行 scripts/build_course_labs.tcl 就能重新生成。举例：

~~~powershell
vivado -mode batch -source .\scripts\build_course_labs.tcl
vivado -mode batch -source .\scripts\build_course_labs.tcl -tclargs 4_alu 11_single_cycle_mul
~~~

本合集的实际板卡按键、屏幕和验收照片需要在实验箱上确认。
