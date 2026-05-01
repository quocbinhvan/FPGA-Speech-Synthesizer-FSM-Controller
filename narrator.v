// File: narrator.v
// This is the top level design for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator timestep should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module narrator (
  input  wire        clk,
  output wire        speaker
  );

  // Create a test circuit to exercise the chatter
  // module, rather than using switches and a
  // button.
  
  reg   [6:0] counter = 0;
  reg   [5:0] data;
  wire        write;
  wire        busy;

  always @(posedge clk) if (!busy) counter <= counter + 1;

  always @*
  begin
    case (counter[6:2])
      // ALAN = AE + LL + AX + NN1 + Pause
        0:  data = 6'h1a; // AE
        1:  data = 6'h2d; // LL
        2:  data = 6'h0f; // AX
        3:  data = 6'h0b; // NN1
        4:  data = 6'h03; // PA4
    
        // TON = TT2 + OW + NN1 + Pause 200ms
        5:  data = 6'h0d; // TT2
        6:  data = 6'h35; // OW
        7:  data = 6'h0b; // NN1
        8:  data = 6'h04; // PA5
    
        // QUOC = KK1 + WW + AO + KK1 + Pause
        9:  data = 6'h2a; // KK1
        10: data = 6'h2e; // WW
        11: data = 6'h17; // AO
        12: data = 6'h2a; // KK1
        13: data = 6'h03; // PA4
    
        // BINH = BB1 + IH + NN1 + Pause
        14: data = 6'h1c; // BB1
        15: data = 6'h0c; // IH
        16: data = 6'h0b; // NN1
        17: data = 6'h03; // PA4
    
        // VAN = VV + AE + NN1 + Pause 200ms
        18: data = 6'h23; // VV
        19: data = 6'h1a; // AE
        20: data = 6'h0b; // NN1
        21: data = 6'h04; // PA5
      default: data = 6'h04;
    endcase
  end

  assign write = (counter[1:0] == 2'b00);
  
  // Instantiate the chatter module, which is
  // driven by the test circuit.

  chatter chatter_inst (
    .data(data),
    .write(write),
    .busy(busy),
    .clk(clk),
    .speaker(speaker)
  );

endmodule
