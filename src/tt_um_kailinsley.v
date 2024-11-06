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
    assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    assign uio_out = 0;
    assign uio_oe  = 0;

    // List all unused inputs to prevent warnings
    wire _unused = ena;

    // Parameters for the LIF module
    localparam THRESHOLD = 8'd128;
    localparam THRESHOLD_INC = 8'd5;
    localparam THRESHOLD_DEC = 8'd1;
    localparam THRESHOLD_MIN = 8'd75;

    // Internal wires for LIF module
    wire [7:0] state_o;
    wire spike_o;
  
    wire [7:0] weight_i, synapse_o;
    assign weight_i = 8'd2;

    synapse #() synpase_edge (
        .clk_i(clk),
        .rst_ni(rst_n),
        .data_i(ui_in),
        .weight_i(weight_i),
        .data_o(synapse_o)
    );
    
    // Instantiate the LIF module
    lif #(
        .THRESHOLD(THRESHOLD),
        .THRESHOLD_INC(THRESHOLD_INC),
        .THRESHOLD_DEC(THRESHOLD_DEC),
        .THRESHOLD_MIN(THRESHOLD_MIN)
    ) lif_inst (
        .clk_i(clk),
        .rst_ni(rst_n),
        .current(synapse_o),
        .state_o(state_o),
        .spike_o(spike_o)
    );



endmodule
