`default_nettype none

module max_spike(
    input clk_i,
    input rst_ni,
    input reg [7:0] spike_count_0,
    input reg [7:0] spike_count_1,
    input reg [7:0] spike_count_2,
    input reg [7:0] spike_count_3,
    input reg [7:0] spike_count_4,
    input reg [7:0] spike_count_5,
    input reg [7:0] spike_count_6,
    input reg [7:0] spike_count_7,
    input reg [7:0] spike_count_8,
    input reg [7:0] spike_count_9,
    output reg [3:0] predicted_digit
);
    reg [7:0] max_count;
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            // Reset max_count to 0 on reset
            max_count <= 8'b0;
        end else begin
            // Compare and update max_count with the highest value
            if (spike_count_0 > max_count) begin
                max_count <= spike_count_0;
                predicted_digit <= 4'd0;
            end
            if (spike_count_1 > max_count) begin
                 max_count <= spike_count_1; 
                 predicted_digit <= 4'd1;
            end
            if (spike_count_2 > max_count) begin
                max_count <= spike_count_2;
                predicted_digit <= 4'd2;
            end
            if (spike_count_3 > max_count) begin
                max_count <= spike_count_3; 
                predicted_digit <= 4'd3;
            end
            if (spike_count_4 > max_count) begin
                max_count <= spike_count_4; 
                predicted_digit <= 4'd4;
            end
            if (spike_count_5 > max_count) begin
                max_count <= spike_count_5; 
                predicted_digit <= 4'd5;
            end
            if (spike_count_6 > max_count) begin
                max_count <= spike_count_6; 
                predicted_digit <= 4'd6;
            end
            if (spike_count_7 > max_count) begin
                max_count <= spike_count_7; 
                predicted_digit <= 4'd7;
            end
            if (spike_count_8 > max_count) begin
                max_count <= spike_count_8; 
                predicted_digit <= 4'd8;
            end
            if (spike_count_9 > max_count) begin
                max_count <= spike_count_9; 
                predicted_digit <= 4'd9;
            end
        end
    end
endmodule
