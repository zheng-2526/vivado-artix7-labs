`timescale 1ns/1ps

module digital_logic_display (
    input clk, resetn,
    input [7:0] switches,
    output [7:0] leds,
    output lcd_rst, lcd_cs, lcd_rs, lcd_wr, lcd_rd,
    inout [15:0] lcd_data_io,
    output lcd_bl_ctr,
    inout ct_int, ct_sda,
    output ct_scl, ct_rstn
);
    wire lab_clk, lab_resetn;
    board_lcd_clock board_clock (.clk(clk), .resetn(resetn),
        .lab_clk(lab_clk), .lab_resetn(lab_resetn), .raw_lcd_clk());

    assign leds = ~switches;

    reg [11:0] bcd;
    integer offset;
    always @* begin
        bcd = 12'd0;
        for (offset = 7; offset >= 0; offset = offset - 1) begin
            if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 4'd3;
            if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 4'd3;
            if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 4'd3;
            bcd = {bcd[10:0], switches[offset]};
        end
    end

    reg [24:0] second_divider;
    reg [7:0] seconds_bcd;
    always @(posedge lab_clk) begin
        if (!lab_resetn) begin
            second_divider <= 25'd0;
            seconds_bcd <= 8'd0;
        end else if (second_divider == 25'd24999999) begin
            second_divider <= 25'd0;
            if (seconds_bcd == 8'h59)
                seconds_bcd <= 8'd0;
            else if (seconds_bcd[3:0] == 4'd9)
                seconds_bcd <= {seconds_bcd[7:4] + 4'd1, 4'd0};
            else
                seconds_bcd <= seconds_bcd + 8'd1;
        end else
            second_divider <= second_divider + 25'd1;
    end

    wire [5:0] display_number;
    reg [39:0] display_name;
    reg [31:0] display_value;
    reg display_valid;
    always @(posedge lab_clk) begin
        display_valid <= 1'b1;
        case (display_number)
            6'd1: begin display_name <= "INPUT"; display_value <= {24'd0, switches}; end
            6'd2: begin display_name <= "BCD  "; display_value <= {20'd0, bcd}; end
            6'd3: begin display_name <= "SEC  "; display_value <= {24'd0, seconds_bcd}; end
            default: begin display_valid <= 1'b0; display_name <= 40'd0; display_value <= 32'd0; end
        endcase
    end

    lcd_module u_lcd (
        .clk(lab_clk), .resetn(lab_resetn),
        .display_valid(display_valid), .display_name(display_name),
        .display_value(display_value), .display_number(display_number),
        .input_valid(), .input_value(),
        .lcd_rst(lcd_rst), .lcd_cs(lcd_cs), .lcd_rs(lcd_rs), .lcd_wr(lcd_wr),
        .lcd_rd(lcd_rd), .lcd_data_io(lcd_data_io), .lcd_bl_ctr(lcd_bl_ctr),
        .ct_int(ct_int), .ct_sda(ct_sda), .ct_scl(ct_scl), .ct_rstn(ct_rstn)
    );
endmodule
