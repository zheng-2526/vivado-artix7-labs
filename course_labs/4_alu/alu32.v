`timescale 1ns/1ps

// ALU operation codes used by this project.
// If the lab manual specifies a different table, change these constants only.
module alu32 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUOp,
    input  wire        Cin,
    output reg  [31:0] Result,
    output reg         C,
    output wire        Z
);
    localparam [3:0] OP_ADD  = 4'd0;
    localparam [3:0] OP_SUB  = 4'd1;
    localparam [3:0] OP_SLT  = 4'd2;
    localparam [3:0] OP_SLTU = 4'd3;
    localparam [3:0] OP_AND  = 4'd4;
    localparam [3:0] OP_OR   = 4'd5;
    localparam [3:0] OP_NOR  = 4'd6;
    localparam [3:0] OP_XOR  = 4'd7;
    localparam [3:0] OP_SLL  = 4'd8;
    localparam [3:0] OP_SRL  = 4'd9;
    localparam [3:0] OP_SRA  = 4'd10;
    localparam [3:0] OP_LUI  = 4'd11;
    localparam [3:0] OP_ROR  = 4'd12;

    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire        add_carry;
    wire        sub_no_borrow;
    wire        unused_add_zero;
    wire        unused_sub_zero;

    adder32_plus u_add (
        .A(A), .B(B), .Cin(Cin), .S(add_result), .C(add_carry), .Z(unused_add_zero)
    );
    adder32_plus u_sub (
        .A(A), .B(~B), .Cin(1'b1), .S(sub_result), .C(sub_no_borrow), .Z(unused_sub_zero)
    );

    always @* begin
        Result = 32'b0;
        C = 1'b0;
        case (ALUOp)
            OP_ADD: begin Result = add_result; C = add_carry; end
            OP_SUB: begin Result = sub_result; C = sub_no_borrow; end
            OP_SLT: begin Result = {31'b0, ($signed(A) < $signed(B))}; end
            OP_SLTU: begin Result = {31'b0, (A < B)}; end
            OP_AND: begin Result = A & B; end
            OP_OR:  begin Result = A | B; end
            OP_NOR: begin Result = ~(A | B); end
            OP_XOR: begin Result = A ^ B; end
            // The course ALU convention uses A[4:0] as shamt and B as data.
            OP_SLL: begin Result = B << A[4:0]; end
            OP_SRL: begin Result = B >> A[4:0]; end
            OP_SRA: begin Result = $signed(B) >>> A[4:0]; end
            // LUI loads B[15:0] into the high half of the result.
            OP_LUI: begin Result = {B[15:0], 16'b0}; end
            // Truncating the low 32 bits of this 64-bit right shift rotates B.
            OP_ROR: begin Result = {B, B} >> A[4:0]; end
            default: begin Result = 32'b0; C = 1'b0; end
        endcase
    end

    assign Z = ~|Result;
endmodule
