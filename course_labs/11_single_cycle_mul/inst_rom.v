`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: inst_rom.v
//   > 描述  ：异步指令存储器模块，采用寄存器搭建而成，类似寄存器堆
//   >         内嵌好指令，只读，异步读
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [4 :0] addr, // 指令地址
    output reg [31:0] inst       // 指令
    );

    wire [31:0] inst_rom[19:0];  // 指令存储器，字节地址7'b000_0000~7'b111_1111
    //------------- 指令编码 ---------|指令地址|--- 汇编指令 -----|- 指令结果 -----//
    assign inst_rom[ 0] = 32'h2401FFFD; // 00: addiu $1,$0,-3
    assign inst_rom[ 1] = 32'h24020007; // 04: addiu $2,$0,7
    assign inst_rom[ 2] = 32'h70221802; // 08: mul   $3,$1,$2  => FFFFFFEB
    assign inst_rom[ 3] = 32'hAC030000; // 0C: sw    $3,0($0)
    assign inst_rom[ 4] = 32'h08000004; // 10: j     0x10
    assign inst_rom[ 5] = 32'h00000000; // nop
    assign inst_rom[ 6] = 32'h00000000; // nop
    assign inst_rom[ 7] = 32'h00000000; // nop
    assign inst_rom[ 8] = 32'h00000000; // nop
    assign inst_rom[ 9] = 32'h00000000; // nop
    assign inst_rom[10] = 32'h00000000; // nop
    assign inst_rom[11] = 32'h00000000; // nop
    assign inst_rom[12] = 32'h00000000; // nop
    assign inst_rom[13] = 32'h00000000; // nop
    assign inst_rom[14] = 32'h00000000; // nop
    assign inst_rom[15] = 32'h00000000; // nop
    assign inst_rom[16] = 32'h00000000; // nop
    assign inst_rom[17] = 32'h00000000; // nop
    assign inst_rom[18] = 32'h00000000; // nop
    assign inst_rom[19] = 32'h00000000; // nop

    //读指令,取4字节
    always @(*)
    begin
        case (addr)
            5'd0 : inst <= inst_rom[0 ];
            5'd1 : inst <= inst_rom[1 ];
            5'd2 : inst <= inst_rom[2 ];
            5'd3 : inst <= inst_rom[3 ];
            5'd4 : inst <= inst_rom[4 ];
            5'd5 : inst <= inst_rom[5 ];
            5'd6 : inst <= inst_rom[6 ];
            5'd7 : inst <= inst_rom[7 ];
            5'd8 : inst <= inst_rom[8 ];
            5'd9 : inst <= inst_rom[9 ];
            5'd10: inst <= inst_rom[10];
            5'd11: inst <= inst_rom[11];
            5'd12: inst <= inst_rom[12];
            5'd13: inst <= inst_rom[13];
            5'd14: inst <= inst_rom[14];
            5'd15: inst <= inst_rom[15];
            5'd16: inst <= inst_rom[16];
            5'd17: inst <= inst_rom[17];
            5'd18: inst <= inst_rom[18];
            5'd19: inst <= inst_rom[19];
            default: inst <= 32'd0;
        endcase
    end
endmodule