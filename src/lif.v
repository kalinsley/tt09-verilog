`default_nettype none

module lif #(
    parameter THRESHOLD = 32,
    // parameter COOLDOWN_PRD = 5'd5,
    parameter THRESHOLD_INC = 2,
    parameter THRESHOLD_DEC = 1,
    parameter THRESHOLD_MIN = 16
) (
    input clk_i,
    input rst_ni,
    input [7:0] current,
    output spike_o
);

    // reg [7:0] state_n;    
    reg [7:0] state_r;
    reg [7:0] variant_threshold;    // variant threshold increments on a spike, continuously decrements otherwise 
    reg spike_n;                    // sequential value of next spike

    // sequential logic to synchronize variant threshold to state
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            /* verilator lint_off WIDTHTRUNC */
            variant_threshold <= THRESHOLD;
            /* verilator lint_on WIDTHTRUNC */
            state_r <= 0;
            spike_n <= 0;
        end else begin
            if (current != 8'b0) begin
                state_r <= current + (state_r >> 1);        // revisit: may need to implement smaller decay rate then 
            end else begin
                state_r <= (state_r - (state_r >> 3));
            end
            
            if (spike_n) begin
                variant_threshold <= variant_threshold + THRESHOLD_INC;
            end else if (variant_threshold > THRESHOLD_MIN) begin
                variant_threshold <= variant_threshold - THRESHOLD_DEC;
            end

            if (state_r >= variant_threshold) begin
                spike_n <= 1;
                state_r <= 0;
            end else begin
                spike_n <= 0;
            end
        end
    end


    assign spike_o = spike_n;

endmodule