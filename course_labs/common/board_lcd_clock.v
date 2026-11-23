`timescale 1ns/1ps

module board_lcd_clock(input clk, input resetn,
                       output lab_clk, output lab_resetn, output raw_lcd_clk);
    wire feedback, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(10.0),
                  .CLKOUT0_DIVIDE_F(40.0)) clock_mmcm (
        .CLKIN1(clk), .CLKFBIN(feedback), .CLKFBOUT(feedback),
        .CLKOUT0(raw_lcd_clk), .LOCKED(locked), .PWRDWN(1'b0), .RST(1'b0)
    );
    BUFG lcd_buffer (.I(raw_lcd_clk), .O(lab_clk));

    wire release_request = resetn & locked;
    (* ASYNC_REG = "TRUE" *) reg [2:0] reset_pipe = 3'b000;
    always @(posedge lab_clk or negedge release_request) begin
        if (!release_request)
            reset_pipe <= 3'b000;
        else
            reset_pipe <= {reset_pipe[1:0], 1'b1};
    end
    assign lab_resetn = reset_pipe[2];
endmodule
