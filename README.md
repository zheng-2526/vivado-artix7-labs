# Vivado Artix-7 实验合集

本仓库包含 13 个可独立构建和下载的 FPGA 实验，目标板卡为 **FPGA-A7-PRJ-UDB-V1.3**，目标器件为 **XC7A200T-FBG676-2**。实验按目录分开，每个目录都有 Verilog、引脚约束、下载说明和对应的比特流。

## 实验目录

| 编号 | 实验 |
|---:|---|
| 01 | [32 位加法器](course_labs/1_adder/) |
| 02 | [基础有符号乘法器](course_labs/2_multiply/) |
| 03 | [32 × 32 位寄存器堆](course_labs/3_regfile/) |
| 04 | [32 位 ALU 和循环右移](course_labs/4_alu/) |
| 05 | [指令 ROM](course_labs/5_inst_rom/) |
| 06 | [单周期 CPU](course_labs/6_single_cycle_cpu/) |
| 07 | [多周期 CPU](course_labs/7_multi_cycle_cpu/) |
| 08 | [五级流水线 CPU](course_labs/8_pipeline_cpu/) |
| 09 | [基 4 Booth 乘法器](course_labs/9_booth/) |
| 10 | [Wallace 树乘法器](course_labs/10_wallace/) |
| 11 | [带 MUL 指令的单周期 CPU](course_labs/11_single_cycle_mul/) |
| 12 | [数据 RAM](course_labs/12_data_ram/) |
| 13 | [BCD、计数器与引脚演示](course_labs/13_digital_logic/) |

## 下载到板上

进入实验目录，可以在 `bitstream` 下下载对应的 `.bit`。板卡通电并通过 USB 下载线连接电脑后，在 Vivado 2019.2 的 **Hardware Manager → Open Target → Auto Connect** 连接设备，再选 **Program Device** 和当前实验的文件。每次下载一个实验。参见 [上板操作与验收用例](docs/board-guide.md)。

## 从源码构建

把仓库克隆到短英文路径，并在 Vivado 2019.2 的命令行环境下运行以下命令。构建产物写入 `course_output/bit/`，报告写入 `course_output/reports/`。

~~~powershell
vivado -mode batch -source .\scripts\build_course_labs.tcl
~~~

也可用 `-tclargs` 指定一个或多个实验目录名，例如 `-tclargs 4_alu 11_single_cycle_mul`。

课程示例来源、调整范围和检查点信息见 [来源说明](PROVENANCE.md)。Vivado 构建与实物上板验证分别记录，实验箱的触摸、按键和显示需要现场确认。
