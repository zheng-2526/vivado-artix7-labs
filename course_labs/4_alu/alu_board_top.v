`timescale 1ns/1ps

// Board-level wrapper for the FPGA-A7-PRJ-UDB-V1.3 lab box.
// The supplied lcd_module checkpoint handles touchscreen entry and display.
module alu_board_top (
    input  wire       clk,
    input  wire       resetn,
    input  wire [1:0] input_sel,
    output wire       led_cout,

    output wire       lcd_rst,
    output wire       lcd_cs,
    output wire       lcd_rs,
    output wire       lcd_wr,
    output wire       lcd_rd,
    inout  wire [15:0] lcd_data_io,
    output wire       lcd_bl_ctr,
    inout  wire       ct_int,
    inout  wire       ct_sda,
    output wire       ct_scl,
    output wire       ct_rstn
);
    wire clock_feedback;
    wire lcd_clock_unbuffered;
    wire lcd_clock;
    wire clock_locked;

    // The board oscillator runs at 100 MHz. The supplied LCD driver uses
    // a 25 MHz input to derive its display and touchscreen timings.
    MMCME2_BASE #(
        .CLKIN1_PERIOD(10.0),
        .CLKFBOUT_MULT_F(10.0),
        .CLKOUT0_DIVIDE_F(40.0)
    ) u_lcd_mmcm (
        .CLKIN1(clk), .CLKFBIN(clock_feedback), .CLKFBOUT(clock_feedback),
        .CLKOUT0(lcd_clock_unbuffered), .LOCKED(clock_locked),
        .PWRDWN(1'b0), .RST(1'b0)
    );
    BUFG u_lcd_clock_buffer (.I(lcd_clock_unbuffered), .O(lcd_clock));

    wire reset_request_n = resetn & clock_locked;
    (* ASYNC_REG = "TRUE" *) reg [1:0] reset_release = 2'b00;
    wire lcd_resetn = reset_release[1];
    always @(posedge lcd_clock or negedge reset_request_n) begin
        if (!reset_request_n)
            reset_release <= 2'b00;
        else
            reset_release <= {reset_release[0], 1'b1};
    end

    (* ASYNC_REG = "TRUE" *) reg [1:0] input_sel_meta;
    (* ASYNC_REG = "TRUE" *) reg [1:0] input_sel_sync;
    always @(posedge lcd_clock) begin
        input_sel_meta <= input_sel;
        input_sel_sync <= input_sel_meta;
    end

    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [13:0] alu_control;
    reg [3:0]  alu_op;
    wire       cin;

    wire [31:0] result;
    wire        carry_flag;
    wire        zero_flag;

    // input_sel=00: touchscreen entry is {Cin, one-hot ALU control};
    // input_sel=10: load A; input_sel=11: load B.
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5:0]  display_number;
    wire        input_valid;
    wire [31:0] input_value;

    assign cin = alu_control[13];

    // The course board interface uses the manual's one-hot control word.
    // ALUOp is decoded internally to the compact core's 0..12 encoding.
    always @* begin
        case (alu_control[12:0])
            13'h0800: alu_op = 4'd0;  // ADD
            13'h0400: alu_op = 4'd1;  // SUB
            13'h0200: alu_op = 4'd2;  // signed SLT
            13'h0100: alu_op = 4'd3;  // unsigned SLTU
            13'h0080: alu_op = 4'd4;  // AND
            13'h0020: alu_op = 4'd5;  // OR
            13'h0040: alu_op = 4'd6;  // NOR
            13'h0010: alu_op = 4'd7;  // XOR
            13'h0008: alu_op = 4'd8;  // SLL
            13'h0004: alu_op = 4'd9;  // SRL
            13'h0002: alu_op = 4'd10; // SRA
            13'h0001: alu_op = 4'd11; // LUI
            13'h1000: alu_op = 4'd12; // ROR
            default:  alu_op = 4'd15;
        endcase
    end

    alu32 u_alu (
        .A(operand_a), .B(operand_b), .ALUOp(alu_op), .Cin(cin),
        .Result(result), .C(carry_flag), .Z(zero_flag)
    );

    // The board's discrete LED is active-low (as in the supplied adder demo).
    assign led_cout = ~carry_flag;

    lcd_module u_lcd (
        .clk(lcd_clock), .resetn(lcd_resetn),
        .display_valid(display_valid), .display_name(display_name),
        .display_value(display_value), .display_number(display_number),
        .input_valid(input_valid), .input_value(input_value),
        .lcd_rst(lcd_rst), .lcd_cs(lcd_cs), .lcd_rs(lcd_rs),
        .lcd_wr(lcd_wr), .lcd_rd(lcd_rd), .lcd_data_io(lcd_data_io),
        .lcd_bl_ctr(lcd_bl_ctr), .ct_int(ct_int), .ct_sda(ct_sda),
        .ct_scl(ct_scl), .ct_rstn(ct_rstn)
    );

    always @(posedge lcd_clock) begin
        if (!lcd_resetn) begin
            operand_a <= 32'd0;
            operand_b <= 32'd0;
            alu_control <= 14'd0;
        end else if (input_valid) begin
            case (input_sel_sync)
                2'b00: alu_control <= input_value[13:0];
                2'b10: operand_a <= input_value;
                2'b11: operand_b <= input_value;
                default: begin end
            endcase
        end
    end

    // The LCD displays A, B, operation control, result and C/Z.
    always @(posedge lcd_clock) begin
        case (display_number)
            6'd1: begin
                display_valid <= 1'b1;
                display_name  <= "SRC_A";
                display_value <= operand_a;
            end
            6'd2: begin
                display_valid <= 1'b1;
                display_name  <= "SRC_B";
                display_value <= operand_b;
            end
            6'd3: begin
                display_valid <= 1'b1;
                display_name  <= "OP_CI";
                display_value <= {18'd0, alu_control};
            end
            6'd4: begin
                display_valid <= 1'b1;
                display_name  <= "RESUL";
                display_value <= result;
            end
            6'd5: begin
                display_valid <= 1'b1;
                display_name  <= "C_Z  ";
                display_value <= {30'd0, carry_flag, zero_flag};
            end
            default: begin
                display_valid <= 1'b0;
                display_name  <= 40'd0;
                display_value <= 32'd0;
            end
        endcase
    end
endmodule
