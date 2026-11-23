`timescale 1ns/1ps

// Shared CPU data port and LCD inspection port; same 256-word interface
// and one-cycle registered outputs as the course Block Memory Generator.
module data_ram(
    input clka, input [3:0] wea, input [7:0] addra,
    input [31:0] dina, output reg [31:0] douta,
    input clkb, input [3:0] web, input [7:0] addrb,
    input [31:0] dinb, output reg [31:0] doutb
);
    (* ram_style = "block" *) reg [31:0] words[0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            words[i] = 32'd0;
    end
    genvar lane;
    generate for (lane = 0; lane < 4; lane = lane + 1) begin : byte_lane
        always @(posedge clka) begin
            if (wea[lane]) begin
                words[addra][lane * 8 +: 8] <= dina[lane * 8 +: 8];
                douta[lane * 8 +: 8] <= dina[lane * 8 +: 8];
            end else
                douta[lane * 8 +: 8] <= words[addra][lane * 8 +: 8];
        end
        always @(posedge clkb) begin
            if (web[lane]) begin
                words[addrb][lane * 8 +: 8] <= dinb[lane * 8 +: 8];
                doutb[lane * 8 +: 8] <= dinb[lane * 8 +: 8];
            end else
                doutb[lane * 8 +: 8] <= words[addrb][lane * 8 +: 8];
        end
    end endgenerate
endmodule
