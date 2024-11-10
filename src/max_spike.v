`default_nettype none

module max_spike(
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

    always @(*) begin
        // Initialize predicted_digit to 0
        predicted_digit = 4'd0;

        // Compare all spike counts and find the maximum spike count
        if (spike_count_1 > spike_count_0) begin
            predicted_digit = 4'd1;
        end
        if (spike_count_2 > spike_count_0 && spike_count_2 > spike_count_1) begin
            predicted_digit = 4'd2;
        end
        if (spike_count_3 > spike_count_0 && spike_count_3 > spike_count_1 && spike_count_3 > spike_count_2) begin
            predicted_digit = 4'd3;
        end
        if (spike_count_4 > spike_count_0 && spike_count_4 > spike_count_1 && spike_count_4 > spike_count_2 && spike_count_4 > spike_count_3) begin
            predicted_digit = 4'd4;
        end
        if (spike_count_5 > spike_count_0 && spike_count_5 > spike_count_1 && spike_count_5 > spike_count_2 && spike_count_5 > spike_count_3 && spike_count_5 > spike_count_4) begin
            predicted_digit = 4'd5;
        end
        if (spike_count_6 > spike_count_0 && spike_count_6 > spike_count_1 && spike_count_6 > spike_count_2 && spike_count_6 > spike_count_3 && spike_count_6 > spike_count_4 && spike_count_6 > spike_count_5) begin
            predicted_digit = 4'd6;
        end
        if (spike_count_7 > spike_count_0 && spike_count_7 > spike_count_1 && spike_count_7 > spike_count_2 && spike_count_7 > spike_count_3 && spike_count_7 > spike_count_4 && spike_count_7 > spike_count_5 && spike_count_7 > spike_count_6) begin
            predicted_digit = 4'd7;
        end
        if (spike_count_8 > spike_count_0 && spike_count_8 > spike_count_1 && spike_count_8 > spike_count_2 && spike_count_8 > spike_count_3 && spike_count_8 > spike_count_4 && spike_count_8 > spike_count_5 && spike_count_8 > spike_count_6 && spike_count_8 > spike_count_7) begin
            predicted_digit = 4'd8;
        end
        if (spike_count_9 > spike_count_0 && spike_count_9 > spike_count_1 && spike_count_9 > spike_count_2 && spike_count_9 > spike_count_3 && spike_count_9 > spike_count_4 && spike_count_9 > spike_count_5 && spike_count_9 > spike_count_6 && spike_count_9 > spike_count_7 && spike_count_9 > spike_count_8) begin
            predicted_digit = 4'd9;
        end
    end
endmodule
