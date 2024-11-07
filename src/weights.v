`default_nettype none

module weights #(
    parameter NUM_SYNAPSES = 100,
    parameter WIDTH_P = 8,
    parameter SEED = 42
) (
    input clk_i, 
    input rst_ni,
    output reg [WIDTH_P-1:0] weights_o [0:NUM_SYNAPSES-1] 
);
    
    wire [7:0] random_weight;   
    lfsr #(
        .SEED(SEED)
    ) random_weights (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .random_value(random_weight)
    );

    integer i;
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin
                weights_o[i] <= 0;
            end
        end else begin  
            for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin
                weights_o[i] <= random_weight % (1 << WIDTH_P);        // use $urandom for unsigned?
            end
        end
    end
    
endmodule