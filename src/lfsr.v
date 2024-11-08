`default_nettype none

module lfsr#(
    parameter SEED = 4'b1010
) (
    input clk_i, 
    input rst_ni, 
    output [3:0] random_value
);
    reg [3:0] shift_reg;

    always @(posedge clk_i) begin
        if (~rst_ni) begin
            shift_reg <= SEED;
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3] ^ shift_reg[2]};
        end
    end
    
    assign random_value = shift_reg;
endmodule