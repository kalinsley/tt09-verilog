`default_nettype none

module onehot2binary #(
    parameter WIDTH_P = 10
) (
    input clk_i,
    input rst_ni,
    input [WIDTH_P-1:0] one_hot_i,
    output [$clog2(WIDTH_P)-1:0] binary_o
);

    reg [$clog2(WIDTH_P)-1:0] binary_r;

    always @(posedge clk_i) begin
        case (one_hot_i)
            10'd0: binary_r = 4'b0000;
            10'd1: binary_r = 4'b0001;
            10'd2: binary_r = 4'b0010;
            10'd4: binary_r = 4'b0011; 
            10'd8: binary_r = 4'b0100;
            10'd16: binary_r = 4'b0101;
            10'd32: binary_r = 4'b0110;
            10'd64: binary_r = 4'b0111;
            10'd128: binary_r = 4'b1000;
            10'd256: binary_r = 4'b1001;
            default: binary_r = 4'b0000;
        endcase
    end

    assign binary_o = binary_r;

endmodule