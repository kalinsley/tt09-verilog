`default_nettype none

module spike_counter #(
    parameter NUM_SPIKES = 10,
    parameter WIDTH_P = 8
) (
    input clk_i,
    input rst_ni,
    input [NUM_SPIKES-1:0] spike_i,
    // output [$clog2(WIDTH_P)-1:0] binary_o
    output reg [WIDTH_P-1:0] spike_count_0, spike_count_1, spike_count_2, spike_count_3, spike_count_4,
                             spike_count_5, spike_count_6, spike_count_7, spike_count_8, spike_count_9
);

    always @(posedge clk_i) begin
        if (~rst_ni) begin
            spike_count_0 <= 0; spike_count_1 <= 0; spike_count_2 <= 0; spike_count_3 <= 0; spike_count_4 <= 0; 
            spike_count_5 <= 0; spike_count_6 <= 0; spike_count_7 <= 0; spike_count_8 <= 0; spike_count_9 <= 0;
        end else begin
            // For each neuron, increment the spike count on each spike
            if (spike_i[0]) spike_count_0 <= spike_count_0 + 1;
            if (spike_i[1]) spike_count_1 <= spike_count_1 + 1;
            if (spike_i[2]) spike_count_2 <= spike_count_2 + 1;
            if (spike_i[3]) spike_count_3 <= spike_count_3 + 1;
            if (spike_i[4]) spike_count_4 <= spike_count_4 + 1;
            if (spike_i[5]) spike_count_5 <= spike_count_5 + 1;
            if (spike_i[6]) spike_count_6 <= spike_count_6 + 1;
            if (spike_i[7]) spike_count_7 <= spike_count_7 + 1;
            if (spike_i[8]) spike_count_8 <= spike_count_8 + 1;
            if (spike_i[9]) spike_count_9 <= spike_count_9 + 1;
        end
    end

endmodule