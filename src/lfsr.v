`default_nettype none

module lfsr#(
    parameter SEED = 8'b10101010
) (
    input clk_i, 
    input rst_ni, 
    output [7:0] random_value
);
    reg [7:0] shift_reg;

    always @(posedge clk_i) begin
        if (~rst_ni) begin
            shift_reg <= SEED;
        end else begin
            shift_reg <= {shift_reg[6:0], shift_reg[7] ^ shift_reg[5] ^ shift_reg[4] ^ shift_reg[3]};
        end
    end
    
    assign random_value = shift_reg;
endmodule