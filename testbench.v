// File:  testbench.v
// This is the top level testbench for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator timestep should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module testbench;

  // Generate a free running 100 MHz clock
  // signal to mimic what is on the board
  // provided for prototyping.

  reg clk;

  always
  begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  wire speaker;
  
  initial
  begin
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    #40000000;  // allow it to run
    $display("Simulation is over, check the waveforms.");
    $stop;
  end

  narrator my_narrator (
    .clk(clk),
    .speaker(speaker)
  );

endmodule
