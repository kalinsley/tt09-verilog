/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

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
    // assign uio_out = 0;
    assign uio_oe  = 0;



    // List all unused inputs to prevent warnings
    wire _unused = &{ena, uio_in};

    // Parameters for the LIF module
    localparam THRESHOLD = 8'd128;
    localparam THRESHOLD_INC = 8'd20;
    localparam THRESHOLD_DEC = 8'd1;
    localparam THRESHOLD_MIN = 8'd75;

    localparam NUM_SYNAPSES = 3;
    localparam WIDTH_P = 8;

    // Internal wires for LIF module
    // wire [7:0] state_o;
    wire [NUM_SYNAPSES-1:0] input_spike_o, hidden_spike_o;

    // wire [7:0] weight_i, 
    wire [WIDTH_P-1:0] synapse_o [0:NUM_SYNAPSES-1];
    // wire [WIDTH_P-1:0] hidden_o [0:NUM_SYNAPSES-1];
    // wire [WIDTH_P-1:0] readout_o [0:NUM_SYNAPSES-1];
    wire [WIDTH_P-1:0] output_o [0:NUM_SYNAPSES-1];
    reg [WIDTH_P-1:0] readout_weights_o [0:NUM_SYNAPSES-1];     // these two are randomly assigned weight matrices, where weights are
    reg [WIDTH_P-1:0] synapse_weights_o [0:NUM_SYNAPSES-1];     // width_p bits wide and NUM_SYNAPSES weights are generated
    reg [WIDTH_P-1:0] hidden_weights_o [0:NUM_SYNAPSES-1];
    // reg [WIDTH_P-1:0] neuron_state_o [0:NUM_SYNAPSES-1];
    // reg [WIDTH_P-1:0] hidden_state_o [0:NUM_SYNAPSES-1];

    weights #(
        .NUM_SYNAPSES(NUM_SYNAPSES),
        .WIDTH_P(8),
        .SEED(42)
    ) input_initializer (
        .clk_i(clk),
        .rst_ni(rst_n),
        .weights_o(synapse_weights_o)
    );

    weights #(
        .NUM_SYNAPSES(NUM_SYNAPSES),
        .WIDTH_P(8),
        .SEED(50)
    ) readout_initializer (
        .clk_i(clk),
        .rst_ni(rst_n),
        .weights_o(readout_weights_o)
    );

    weights #(
        .NUM_SYNAPSES(NUM_SYNAPSES),
        .WIDTH_P(8),
        .SEED(60)
    ) hidden_initializer (
        .clk_i(clk),
        .rst_ni(rst_n),
        .weights_o(hidden_weights_o)
    );

    genvar i;
    generate
        for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin : input_layer_synapse
            synapse #() input_layer (
                .clk_i(clk),
                .rst_ni(rst_n),
                .data_i(ui_in),     // ui_in goes in all neurons and is weighted by random values
                .weight_i(8'd99),    // synapse_weights_o[i] 
                .data_o(synapse_o[i])
            );
        end
    endgenerate
    
    generate
        for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin : input_layer_lif
            lif #(
                .THRESHOLD(THRESHOLD),
                .THRESHOLD_INC(THRESHOLD_INC),
                .THRESHOLD_DEC(THRESHOLD_DEC),
                .THRESHOLD_MIN(THRESHOLD_MIN)
            ) input_lif_neuron (
                .clk_i(clk),
                .rst_ni(rst_n),
                .current(synapse_o[i]),         // Feed synapse output to each neuron
                // .state_o(neuron_state_o[i]),    // Output the state for each neuron
                .spike_o(input_spike_o[i])               // Capture spike for each neuron
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin : hidden_layer_lif
            lif #(
                .THRESHOLD(THRESHOLD),
                .THRESHOLD_INC(THRESHOLD_INC),
                .THRESHOLD_DEC(THRESHOLD_DEC),
                .THRESHOLD_MIN(THRESHOLD_MIN)
            ) hidden_lif_neuron (
                .clk_i(clk),
                .rst_ni(rst_n),
                .current(input_spike_o[i] ? 8'd100 : 8'b0),       // hidden_weights_o[i] 
                // .state_o(hidden_state_o[i]),    // Output the state for each neuron
                .spike_o(hidden_spike_o[i])     // Capture spike for each hidden neuron
            );
        end
    endgenerate

    generate
        for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin : output_layer_accumulate
            // CAREFUL!!!
            // accumulator only collects up to 8 bits of data_o, so when 128 + 128 occurs we get back to 0
            accumulator #() output_layer (
                .clk_i(clk),
                .rst_ni(rst_n),
                .data_i(hidden_spike_o[i] ? 8'd75 : 8'b0),       // readout_weights_o[i]
                .data_o(output_o[i])
            );
        end
    endgenerate

    // so now we have this data flow:
        // input 8 bits -> weighted by all synapses -> 1to1 dynamic LIF ->
        // spikes are weighted at readout layer -> readouts are accumulated at accumulator

    integer j;

    reg [WIDTH_P-1:0] max_value; 
    reg [WIDTH_P-1:0] max_index; 
    always @(posedge clk) begin
        if (!rst_n) begin
            max_value <= 0; 
            max_index <= 0;
        end else begin
            max_value <= 0;
            max_index <= 0;
            for (j = 0; j < NUM_SYNAPSES; j = j + 1) begin
                if (output_o[j] > max_value) begin
                    max_value <= output_o[j];
                    max_index <= j[WIDTH_P-1:0]; 
                end
            end
        end
    end
    
    assign uio_out = max_index;
    assign uo_out = max_value;        // assign uo_out to the maximum value from readout layer

endmodule
