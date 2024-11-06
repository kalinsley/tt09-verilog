`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate your top-level module
  tt_um_kailinsley user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period of 10 time units
  end

  // Test procedure
  initial begin
    // Initialize inputs
    rst_n = 0;
    ena = 1; // Assume enable is always high
    ui_in = 0;
    uio_in = 0;

    // Apply reset
    #10;
    rst_n = 1; // Release reset

    // // Test cases
    // // Test Case 1: Input below threshold, expect no spike
    // ui_in = 8'd100; // Below threshold
    // #10;
    // $display("Test Case 1: State: %d, Spike: %b", user_project.state_o, user_project.spike_o); // Assuming state_o and spike_o are accessible

    // // Test Case 2: Input at threshold, expect spike
    // ui_in = 8'd128; // At threshold
    // #10;
    // $display("Test Case 2: State: %d, Spike: %b", user_project.state_o, user_project.spike_o);

    // // Test Case 3: Input above threshold, expect spike
    // ui_in = 8'd150; // Above threshold
    // #10;
    // $display("Test Case 3: State: %d, Spike: %b", user_project.state_o, user_project.spike_o);

    // // Test Case 4: Check state decay
    // ui_in = 8'd0; // No current input
    // #50; // Wait for a few clock cycles
    // $display("Test Case 4: State: %d, Spike: %b", user_project.state_o, user_project.spike_o);

    // // Test Case 5: Input decreases to threshold
    // ui_in = 8'd120; // Below threshold
    // #10;
    // $display("Test Case 5: State: %d, Spike: %b", user_project.state_o, user_project.spike_o);

    // Finalize simulation
    #1000000000;
    $finish;
  end

endmodule
