`default_nettype none

module tt_um_kailinsley (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // All output pins must be assigned. If not used, assign to 0.
    // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    assign uio_out = 0;
    assign uio_oe  = 0;

    // LOCAL PARAMETERS
    localparam WIDTH_P = 3;
    // localparam NUM_INPUT_NEURONS = 8;
    localparam NUM_HIDDEN_NEURONS = 3;
    localparam NUM_OUTPUT_NEURONS = 10;

    localparam THRESHOLD = 16;
    localparam THRESHOLD_INC = 2;
    localparam THRESHOLD_DEC = 1;
    localparam THRESHOLD_MIN = 8;

    // Now we have 8 random weights, stored in wires weight#
    // wire [WIDTH_P-1:0] input_weight_0, input_weight_1, input_weight_2, input_weight_3, 
    //                    input_weight_4, input_weight_5, input_weight_6, input_weight_7;

    wire [WIDTH_P-1:0] hidden_weight_0, hidden_weight_1, hidden_weight_2, 
                       hidden_weight_3, hidden_weight_4, hidden_weight_5;

    wire [WIDTH_P-1:0] output_weight_0, output_weight_1, output_weight_2, output_weight_3, output_weight_4, 
                       output_weight_5, output_weight_6, output_weight_7, output_weight_8, output_weight_9;
    
    // wire [NUM_INPUT_NEURONS-1:0] input_spike_o;
    wire [NUM_HIDDEN_NEURONS-1:0] hidden_spike_o;
    wire [NUM_OUTPUT_NEURONS-1:0] output_spike_o;
    // weights #(
    //     .SEED(4'b1010)
    // ) input_weights_8 (
    //     .clk_i(clk),
    //     .rst_ni(rst_n),
    //     .weight_0(input_weight_0),
    //     .weight_1(input_weight_1),
    //     .weight_2(input_weight_2),
    //     .weight_3(input_weight_3),
    //     .weight_4(input_weight_4),
    //     .weight_5(input_weight_5),
    //     .weight_6(input_weight_6),
    //     .weight_7(input_weight_7)
    // );

    weights #(
        .SEED(4'b1100),
        .WIDTH_P(WIDTH_P)
    ) hidden_weights_8 (
        .clk_i(clk),
        .rst_ni(rst_n),
        .weight_0(hidden_weight_0),
        .weight_1(hidden_weight_1),
        .weight_2(hidden_weight_2),
        .weight_3(hidden_weight_3),
        .weight_4(hidden_weight_4),
        .weight_5(hidden_weight_5),
        .weight_6(output_weight_8),
        .weight_7(output_weight_9)
    );

    weights #(
        .SEED(4'b0011),
        .WIDTH_P(WIDTH_P)
    ) output_weights_8 (
        .clk_i(clk),
        .rst_ni(rst_n),
        .weight_0(output_weight_0),
        .weight_1(output_weight_1),
        .weight_2(output_weight_2),
        .weight_3(output_weight_3),
        .weight_4(output_weight_4),
        .weight_5(output_weight_5),
        .weight_6(output_weight_6),
        .weight_7(output_weight_7)
    );

    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_0 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[0] ? input_weight_0 : 8'b0),.spike_o(input_spike_o[0])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_1 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[1] ? input_weight_1 : 8'b0),.spike_o(input_spike_o[1])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_2 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[2] ? input_weight_2 : 8'b0),.spike_o(input_spike_o[2])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_3 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[3] ? input_weight_3 : 8'b0),.spike_o(input_spike_o[3])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_4 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[4] ? input_weight_4 : 8'b0),.spike_o(input_spike_o[4])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_5 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[5] ? input_weight_5: 8'b0),.spike_o(input_spike_o[5])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_6 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[6] ? input_weight_6 : 8'b0),.spike_o(input_spike_o[6])); 
    // lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    // ) input_lif_7 (.clk_i(clk), .rst_ni(rst_n),.current(ui_in[7] ? input_weight_7 : 8'b0),.spike_o(input_spike_o[7])); 

    // HIDDEN LAYER
    wire [WIDTH_P-1:0] hidden_current_0, hidden_current_1, hidden_current_2;
    wire [WIDTH_P-1:0] output_current_0, output_current_1, output_current_2, output_current_3, output_current_4, 
                       output_current_5, output_current_6, output_current_7, output_current_8, output_current_9;

    // assign hidden_current_0 = input_spike_o & hidden_weight0;
    // assign hidden_current_1 = input_spike_o & hidden_weight1;
    // assign hidden_current_2 = input_spike_o & hidden_weight2;

    assign hidden_current_0 = (ui_in[0] ? hidden_weight_0 : 3'b0) + 
                              (ui_in[1] ? hidden_weight_0 : 3'b0) + 
                              (ui_in[2] ? hidden_weight_0 : 3'b0) + 
                              (ui_in[3] ? hidden_weight_0 : 3'b0) + 
                              (ui_in[4] ? hidden_weight_0 : 3'b0) + 
                              (ui_in[5] ? hidden_weight_0 : 3'b0) +
                              (ui_in[6] ? hidden_weight_0 : 3'b0) +
                              (ui_in[7] ? hidden_weight_0 : 3'b0);

    assign hidden_current_1 = (ui_in[0] ? hidden_weight_1 : 3'b0) + 
                              (ui_in[1] ? hidden_weight_1 : 3'b0) + 
                              (ui_in[2] ? hidden_weight_1 : 3'b0) + 
                              (ui_in[3] ? hidden_weight_1 : 3'b0) + 
                              (ui_in[4] ? hidden_weight_1 : 3'b0) + 
                              (ui_in[5] ? hidden_weight_1 : 3'b0) +
                              (ui_in[6] ? hidden_weight_1 : 3'b0) +
                              (ui_in[7] ? hidden_weight_1 : 3'b0);

    assign hidden_current_2 = (ui_in[0] ? hidden_weight_2 : 3'b0) + 
                              (ui_in[1] ? hidden_weight_2 : 3'b0) + 
                              (ui_in[2] ? hidden_weight_2 : 3'b0) + 
                              (ui_in[3] ? hidden_weight_2 : 3'b0) + 
                              (ui_in[4] ? hidden_weight_2 : 3'b0) + 
                              (ui_in[5] ? hidden_weight_2 : 3'b0) +
                              (ui_in[6] ? hidden_weight_2 : 3'b0) +
                              (ui_in[7] ? hidden_weight_2 : 3'b0);

    lif #( .THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) hidden_lif_0 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, hidden_current_0}),.spike_o(hidden_spike_o[0])); 
    lif #( .THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) hidden_lif_1 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, hidden_current_1}),.spike_o(hidden_spike_o[1])); 
    lif #( .THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) hidden_lif_2 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, hidden_current_2}),.spike_o(hidden_spike_o[2])); 

    // Fully connected computations from hidden layer (3) to output layer (10)
    assign output_current_0 = (hidden_spike_o[0] ? output_weight_0 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_0 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_0 : 3'b0);

    assign output_current_1 = (hidden_spike_o[0] ? output_weight_1 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_1 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_1 : 3'b0);

    assign output_current_2 = (hidden_spike_o[0] ? output_weight_2 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_2 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_2 : 3'b0);

    assign output_current_3 = (hidden_spike_o[0] ? output_weight_3 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_3 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_3 : 3'b0);

    assign output_current_4 = (hidden_spike_o[0] ? output_weight_4 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_4 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_4 : 3'b0);

    assign output_current_5 = (hidden_spike_o[0] ? output_weight_5 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_5 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_5 : 3'b0);

    assign output_current_6 = (hidden_spike_o[0] ? output_weight_6 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_6 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_6 : 3'b0);

    assign output_current_7 = (hidden_spike_o[0] ? output_weight_7 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_7 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_7 : 3'b0);

    assign output_current_8 = (hidden_spike_o[0] ? output_weight_8 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_8 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_8 : 3'b0);

    assign output_current_9 = (hidden_spike_o[0] ? output_weight_9 : 3'b0) + 
                            (hidden_spike_o[1] ? output_weight_9 : 3'b0) + 
                            (hidden_spike_o[2] ? output_weight_9 : 3'b0);


    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_0 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_0}),.spike_o(output_spike_o[0])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_1 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_1}),.spike_o(output_spike_o[1])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_2 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_2}),.spike_o(output_spike_o[2])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_3 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_3}),.spike_o(output_spike_o[3])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_4 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_4}),.spike_o(output_spike_o[4])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_5 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_5}),.spike_o(output_spike_o[5])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_6 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_6}),.spike_o(output_spike_o[6])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_7 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_7}),.spike_o(output_spike_o[7])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_8 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_8}),.spike_o(output_spike_o[8])); 
    lif #(.THRESHOLD(THRESHOLD),.THRESHOLD_INC(THRESHOLD_INC),.THRESHOLD_DEC(THRESHOLD_DEC), .THRESHOLD_MIN(THRESHOLD_MIN)
    ) output_lif_9 (.clk_i(clk), .rst_ni(rst_n),.current({5'b0, output_current_9}),.spike_o(output_spike_o[9])); 

    reg [7:0] spike_count_0, spike_count_1, spike_count_2, spike_count_3, spike_count_4,
              spike_count_5, spike_count_6, spike_count_7, spike_count_8, spike_count_9;
    wire [7:0] spike_count_o;

    spike_counter #(
        .NUM_SPIKES(10),
        .WIDTH_P(8)
    ) spike_counter (
        .clk_i(clk),
        .rst_ni(rst_n),
        .spike_i(output_spike_o),
        .spike_count_0(spike_count_0),
        .spike_count_1(spike_count_1),
        .spike_count_2(spike_count_2),
        .spike_count_3(spike_count_3),
        .spike_count_4(spike_count_4),
        .spike_count_5(spike_count_5),
        .spike_count_6(spike_count_6),
        .spike_count_7(spike_count_7),
        .spike_count_8(spike_count_8),
        .spike_count_9(spike_count_9)
    );

    // // List all unused inputs to prevent warnings
    wire _unused = &{ena, uio_in, hidden_weight_3, hidden_weight_4, hidden_weight_5, 
                     spike_count_1, spike_count_2, spike_count_3, spike_count_4, spike_count_5,
                     spike_count_6, spike_count_7, spike_count_8, spike_count_9};

    // wire _unused = &{ena, uio_in, hidden_weight_3, hidden_weight_4, hidden_weight_5};

    // assign spike_count_o = (uio_in[3:0] == 4'd0) ? spike_count_0 : 
    //                         (uio_in[3:0] == 4'd1) ? spike_count_1 :
    //                         (uio_in[3:0] == 4'd2) ? spike_count_2 :
    //                         (uio_in[3:0] == 4'd3) ? spike_count_3 :
    //                         (uio_in[3:0] == 4'd4) ? spike_count_4 :
    //                         (uio_in[3:0] == 4'd5) ? spike_count_5 :
    //                         (uio_in[3:0] == 4'd6) ? spike_count_6 :
    //                         (uio_in[3:0] == 4'd7) ? spike_count_7 :
    //                         (uio_in[3:0] == 4'd8) ? spike_count_8 :
    //                         (uio_in[3:0] == 4'd9) ? spike_count_9 :
    //                         4'b0;

    assign uo_out = spike_count_0;

endmodule