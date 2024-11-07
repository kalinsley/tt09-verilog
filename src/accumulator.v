`default_nettype none

module accumulator #(
    parameter WIDTH_P = 8
) (
    input clk_i,
    input rst_ni,
    input [WIDTH_P-1:0] data_i,
    output [WIDTH_P-1:0] data_o
);

reg [WIDTH_P-1:0] accumulation;
always @(posedge clk_i) begin
    if (!rst_ni) begin
        accumulation <= 0;      // Reset the accumulated value
    end else if (data_i) begin
        accumulation <= accumulation + data_i; // Accumulate input
    end else begin
        accumulation <= accumulation;
    end
end

assign data_o = accumulation;

endmodule