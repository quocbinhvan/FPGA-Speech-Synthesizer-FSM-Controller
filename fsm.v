// File: fsm.v
// This is the FSM module for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator timestep should be (1 ps here).

`timescale 1 ns / 1 ps

module fsm (
    output reg        busy,
    input  wire       period_expired,
    input  wire       data_arrived,
    input  wire       val_match,
    output reg        load_ptrs,
    output reg        increment,
    output reg        sample_capture,
    input  wire       clk
);

    reg [2:0] state, next_state;

    localparam IDLE      = 3'd0,
               LOAD      = 3'd1,
               WAIT_EXP  = 3'd2,
               INCR      = 3'd3,
               ROM_WAIT1 = 3'd4,
               ROM_WAIT2 = 3'd5,
               CAPTURE   = 3'd6;

    // State register
    always @(posedge clk)
    begin
        state <= next_state;
    end

    // Next-state logic and output logic
    always @(*)
    begin
        // Default outputs
        busy           = 1'b0;
        load_ptrs      = 1'b0;
        increment      = 1'b0;
        sample_capture = 1'b0;
        next_state     = state;

        case (state)
            IDLE:
            begin
                busy = 1'b0;
                if (data_arrived)
                    next_state = LOAD;
            end

            LOAD:
            begin
                busy      = 1'b1;
                load_ptrs = 1'b1;
                next_state = WAIT_EXP;
            end

            WAIT_EXP:
            begin
                busy = 1'b1;
                if (period_expired)
                    next_state = INCR;
            end

            INCR:
            begin
                busy      = 1'b1;
                increment = 1'b1;
                next_state = ROM_WAIT1;
            end

            ROM_WAIT1:
            begin
                busy = 1'b1;
                next_state = ROM_WAIT2;
            end

            ROM_WAIT2:
            begin
                busy = 1'b1;
                next_state = CAPTURE;
            end

            CAPTURE:
            begin
                busy           = 1'b1;
                sample_capture = 1'b1;
                if (val_match)
                    next_state = IDLE;
                else
                    next_state = WAIT_EXP;
            end

            default:
            begin
                busy       = 1'b0;
                next_state = IDLE;
            end
        endcase
    end
endmodule
