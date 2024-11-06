`default_nettype none

module #(
    parameter NUM_SYNAPSES = 100,
    parameter WIDTH_P = 8
) weights (
    input clk_i, 
    input rst_ni,
    output reg [WIDTH_P-1:0] weights_o [0:NUM_SYNAPSES-1] 
);
    
    integer i;
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin
                weights_o[i] <= 0;
            end
        end else begin  
            for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin
                weights_o[i] <= $urandom % (1 << WIDTH_P);        // use $urandom for unsigned?
            end
        end
    end
endmodule