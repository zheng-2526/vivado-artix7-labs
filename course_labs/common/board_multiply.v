`timescale 1ns/1ps

// A signed 64-bit product with one start pulse and one completion pulse.
// The default uses a reused 32-bit adder and 32 serial steps.
module multiply #(parameter USE_BOOTH = 0) (
    input clk, resetn, mult_begin,
    input [31:0] mult_op1, mult_op2,
    output reg [63:0] product,
    output reg mult_end
);
`ifdef LAB_WALLACE
    reg busy;
    wire [63:0] tree_result;
    lab_wallace multiply_tree (.x(mult_op1), .y(mult_op2), .product(tree_result));
    always @(posedge clk) begin
        if (!resetn) begin
            busy <= 1'b0;
            product <= 64'd0;
            mult_end <= 1'b0;
        end else begin
            busy <= mult_begin;
            mult_end <= busy;
            if (mult_begin)
                product <= tree_result;
        end
    end
`else
    reg [5:0] steps_left;
    reg signed [33:0] multiplicand;
    reg signed [66:0] partial;
    reg signed [33:0] addend;
    always @* begin
        addend = 34'sd0;
        if (USE_BOOTH) begin
            case (partial[2:0])
                3'b001, 3'b010: addend = multiplicand;
                3'b011:         addend = multiplicand <<< 1;
                3'b100:         addend = -(multiplicand <<< 1);
                3'b101, 3'b110: addend = -multiplicand;
                default:       addend = 34'sd0;
            endcase
        end else if (partial[1]) begin
            // The most significant multiplier bit has negative weight.
            addend = steps_left == 6'd1 ? -multiplicand : multiplicand;
        end
    end
    wire signed [33:0] upper_sum = $signed(partial[66:33]) + addend;
    wire signed [66:0] next_partial = $signed({upper_sum, partial[32:0]}) >>> (USE_BOOTH ? 2 : 1);
    always @(posedge clk) begin
        if (!resetn) begin
            steps_left <= 6'd0;
            multiplicand <= 34'sd0;
            partial <= 67'sd0;
            product <= 64'd0;
            mult_end <= 1'b0;
        end else begin
            mult_end <= 1'b0;
            if (steps_left != 0) begin
                partial <= next_partial;
                steps_left <= steps_left - 1'b1;
                if (steps_left == 6'd1) begin
                    product <= next_partial[64:1];
                    mult_end <= 1'b1;
                end
            end else if (mult_begin) begin
                multiplicand <= {{2{mult_op1[31]}}, mult_op1};
                partial <= {34'd0, mult_op2, 1'b0};
                steps_left <= USE_BOOTH ? 6'd16 : 6'd32;
            end
        end
    end
`endif
endmodule
