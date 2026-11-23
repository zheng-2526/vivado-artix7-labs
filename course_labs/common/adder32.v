`timescale 1ns/1ps

// 32-bit adder using Verilog arithmetic operators.
// S = A + B + Cin; C is the carry out of bit 31; Z is high iff S is zero.
module adder32_plus (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Cin,
    output wire [31:0] S,
    output wire        C,
    output wire        Z
);
    wire [32:0] full_sum;
    assign full_sum = {1'b0, A} + {1'b0, B} + Cin;
    assign {C, S} = full_sum;
    assign Z = ~|S;
endmodule

// 32-bit ripple-carry (serial carry) adder made from bit-level logic.
// The sum and carry equations intentionally contain no '+' operator.
module adder32_ripple (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Cin,
    output wire [31:0] S,
    output wire        C,
    output wire        Z
);
    wire [31:0] propagate;
    wire [31:0] generate_carry;
    wire [32:0] carry;

    assign carry[0] = Cin;
    assign C = carry[32];
    assign Z = ~|S;

    genvar bit_index;
    generate
        for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1) begin : gen_ripple
            assign propagate[bit_index] = A[bit_index] ^ B[bit_index];
            assign generate_carry[bit_index] = A[bit_index] & B[bit_index];
            assign S[bit_index] = propagate[bit_index] ^ carry[bit_index];
            assign carry[bit_index + 1] = generate_carry[bit_index]
                                         | (propagate[bit_index] & carry[bit_index]);
        end
    endgenerate
endmodule
