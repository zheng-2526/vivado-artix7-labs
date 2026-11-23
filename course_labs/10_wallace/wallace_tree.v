`timescale 1ns/1ps
// Booth partial products and carry-save tree from the Loongson course.
module lab_wallace(input [31:0] x, y, output [63:0] product);
    wire [63:0] multiplicand = {{32{x[31]}}, x};
    wire [63:0] p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15;
    booth #(0) booth0({y[1:0],1'b0}, multiplicand, p0);
    booth #(2) booth2(y[3:1], multiplicand, p1);
    booth #(4) booth4(y[5:3], multiplicand, p2);
    booth #(6) booth6(y[7:5], multiplicand, p3);
    booth #(8) booth8(y[9:7], multiplicand, p4);
    booth #(10) booth10(y[11:9], multiplicand, p5);
    booth #(12) booth12(y[13:11], multiplicand, p6);
    booth #(14) booth14(y[15:13], multiplicand, p7);
    booth #(16) booth16(y[17:15], multiplicand, p8);
    booth #(18) booth18(y[19:17], multiplicand, p9);
    booth #(20) booth20(y[21:19], multiplicand, p10);
    booth #(22) booth22(y[23:21], multiplicand, p11);
    booth #(24) booth24(y[25:23], multiplicand, p12);
    booth #(26) booth26(y[27:25], multiplicand, p13);
    booth #(28) booth28(y[29:27], multiplicand, p14);
    booth #(30) booth30(y[31:29], multiplicand, p15);

    wire [63:0] level1_1_s, level1_1_c;
    adder level1_1(p0,p1,p2,level1_1_s,level1_1_c);
    wire [63:0] level1_2_s, level1_2_c;
    adder level1_2(p3,p4,p5,level1_2_s,level1_2_c);
    wire [63:0] level1_3_s, level1_3_c;
    adder level1_3(p6,p7,p8,level1_3_s,level1_3_c);
    wire [63:0] level1_4_s, level1_4_c;
    adder level1_4(p9,p10,p11,level1_4_s,level1_4_c);
    wire [63:0] level1_5_s, level1_5_c;
    adder level1_5(p12,p13,p14,level1_5_s,level1_5_c);

    wire [63:0] level2_1_s, level2_1_c;
    adder level2_1(level1_1_s,level1_1_c,level1_2_s,level2_1_s,level2_1_c);
    wire [63:0] level2_2_s, level2_2_c;
    adder level2_2(level1_2_c,level1_3_s,level1_3_c,level2_2_s,level2_2_c);
    wire [63:0] level2_3_s, level2_3_c;
    adder level2_3(level1_4_s,level1_4_c,level1_5_s,level2_3_s,level2_3_c);

    wire [63:0] level3_1_s, level3_1_c;
    adder level3_1(level2_1_s,level2_1_c,level2_2_s,level3_1_s,level3_1_c);
    wire [63:0] level3_2_s, level3_2_c;
    adder level3_2(level2_2_c,level2_3_s,level2_3_c,level3_2_s,level3_2_c);

    wire [63:0] level4_1_s, level4_1_c;
    adder level4_1(level3_1_s,level3_1_c,level3_2_s,level4_1_s,level4_1_c);
    wire [63:0] level4_2_s, level4_2_c;
    adder level4_2(level3_2_c,level1_5_c,p15,level4_2_s,level4_2_c);

    wire [63:0] level5_s, level5_c;
    adder level5(level4_1_s,level4_1_c,level4_2_s,level5_s,level5_c);

    wire [63:0] level6_s, level6_c;
    adder level6(level4_2_c,level5_s,level5_c,level6_s,level6_c);

    assign product = level6_s + level6_c;

endmodule

module booth(
    input [2:0] y,
    input [63:0] x,
    output [63:0] p
);
parameter base = 0;
wire [63:0] sx;

assign sx = x << base;
assign p = (y === 3'b000 | y === 3'b111) ? 64'd0 :
           (y === 3'b001 | y === 3'b010) ? sx :
           (y === 3'b101 | y === 3'b110) ? (~sx + 1) :
           (y === 3'b011) ? (sx << 1) : (~(sx << 1) + 1);

endmodule

module adder(
    input [63:0] op1, op2, op3,
    output [63:0] s, c
);
    assign s = op1 ^ op2 ^ op3;
    assign c = ((op1 & op2) | (op1 & op3) | (op2 & op3)) << 1;
endmodule
