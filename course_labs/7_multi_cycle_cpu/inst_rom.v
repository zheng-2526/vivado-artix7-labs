`timescale 1ns/1ps

// One-cycle synchronous read, initialized from the accompanying course COE.
module inst_rom(input clka, input [7:0] addra, output reg [31:0] douta);
    always @(posedge clka) begin
        case (addra)
            8'd0: douta <= 32'h24010001;
            8'd1: douta <= 32'h00011100;
            8'd2: douta <= 32'h00411821;
            8'd3: douta <= 32'h00022082;
            8'd4: douta <= 32'h28990005;
            8'd5: douta <= 32'h07210010;
            8'd6: douta <= 32'h00642823;
            8'd7: douta <= 32'hAC050014;
            8'd8: douta <= 32'h00A23027;
            8'd9: douta <= 32'h00C33825;
            8'd10: douta <= 32'h00E64026;
            8'd11: douta <= 32'hAC08001C;
            8'd12: douta <= 32'h11030002;
            8'd13: douta <= 32'h00C7482A;
            8'd14: douta <= 32'h24010008;
            8'd15: douta <= 32'h8C2A0014;
            8'd16: douta <= 32'h15450004;
            8'd17: douta <= 32'h00415824;
            8'd18: douta <= 32'hAC2B001C;
            8'd19: douta <= 32'hAC240010;
            8'd20: douta <= 32'h0C000019;
            8'd21: douta <= 32'h3C0C000C;
            8'd22: douta <= 32'h004CD007;
            8'd23: douta <= 32'h003AD804;
            8'd24: douta <= 32'h0360F809;
            8'd25: douta <= 32'hA07A0005;
            8'd26: douta <= 32'h0063682B;
            8'd27: douta <= 32'h1DA00003;
            8'd28: douta <= 32'h00867004;
            8'd29: douta <= 32'h000E7883;
            8'd30: douta <= 32'h002F8006;
            8'd31: douta <= 32'h1A000008;
            8'd32: douta <= 32'h002F8007;
            8'd33: douta <= 32'h240B008C;
            8'd34: douta <= 32'h06000006;
            8'd35: douta <= 32'h8D5C0003;
            8'd36: douta <= 32'h179D0007;
            8'd37: douta <= 32'hA0AF0008;
            8'd38: douta <= 32'h80B20008;
            8'd39: douta <= 32'h90B30008;
            8'd40: douta <= 32'h2DF8FFFF;
            8'd41: douta <= 32'h0185E825;
            8'd42: douta <= 32'h01600008;
            8'd43: douta <= 32'h31F4FFFF;
            8'd44: douta <= 32'h35F5FFFF;
            8'd45: douta <= 32'h39F6FFFF;
            8'd46: douta <= 32'h08000000;
            default: douta <= 32'd0;
        endcase
    end
endmodule
