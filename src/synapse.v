`default_nettype none

// delivers weighted data from input to neuron
module synapse (
    input clk_i,
    input rst_ni,
    input [7:0] data_i,
    input [7:0] weight_i,

    output [7:0] data_o
);

    reg [15:0] data_r;

    always @(posedge clk_i) begin
        if (!rst_ni) begin
            data_r <= 0;
        end else begin
            data_r <= data_i * weight_i;
        end
    end

    // truncate output values to 8 bits
    assign data_o = data_r[7:0];

endmodule