`default_nettype none

// Generates 8 bit random values between (31-0), as top 3 bits are forced (0)
// 8 output ports for weights

module weights #(
    parameter WIDTH_P = 4,
    parameter SEED = 4'b1010
) (
    input clk_i, 
    input rst_ni,
    output [WIDTH_P-1:0] weight_0,
    output [WIDTH_P-1:0] weight_1,
    output [WIDTH_P-1:0] weight_2,
    output [WIDTH_P-1:0] weight_3,
    output [WIDTH_P-1:0] weight_4,
    output [WIDTH_P-1:0] weight_5,
    output [WIDTH_P-1:0] weight_6,
    output [WIDTH_P-1:0] weight_7
);
    
    wire [3:0] random_weight;   
    lfsr #(
        .SEED(SEED)
    ) random_weights (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .random_value(random_weight)
    );

    // Capped weights at 3 bits for space constraint
    assign weight_0 = random_weight[2:0];
    assign weight_1 = {random_weight[1:0], random_weight[3]};
    assign weight_2 = {random_weight[2:1], random_weight[0]};
    assign weight_3 = {random_weight[3:1]};
    assign weight_4 = {random_weight[3], random_weight[2:1]};
    assign weight_5 = {random_weight[1], random_weight[3], random_weight[2]};
    assign weight_6 = {random_weight[2], random_weight[1], random_weight[0]};
    assign weight_7 = {random_weight[0], random_weight[2], random_weight[3]};

    // THIS DID NOT FIT ON THE TT 1x1 TILE SPACE
    // assign weight_0 = random_weight;
    // assign weight_1 = {random_weight[1:0], random_weight[3:2]};
    // assign weight_2 = {random_weight[2:1], random_weight[0], random_weight[3]};
    // assign weight_3 = {random_weight[3:1], random_weight[3]};
    // assign weight_4 = {random_weight[3], random_weight[0], random_weight[2:1]};
    // assign weight_5 = {random_weight[1], random_weight[0], random_weight[3], random_weight[2]};
    // assign weight_6 = {random_weight[2], random_weight[1], random_weight[3], random_weight[0]};
    // assign weight_7 = {random_weight[0], random_weight[2], random_weight[1], random_weight[3]};


    // moght change to 16 bit random for more randomness first 4 splitting into 4 bits each, then flip around bits for second 4 
    // assign weight_0 = {4'b0, random_weight[3:0]};
    // assign weight_1 = {4'b0, random_weight[7:4]};
    // assign weight_2 = {4'b0, random_weight[11:8]};
    // assign weight_3 = {4'b0, random_weight[15:12]};
    // assign weight_4 = {4'b0, random_weight[12:10], random_weight[5:2], random_weight[14:13]};
    // assign weight_5 = {4'b0, random_weight[9:6], random_weight[1:0], random_weight[11:10]};
    // assign weight_6 = {4'b0, random_weight[12:11], random_weight[7:6], random_weight[15:13], random_weight[7]};
    // assign weight_7 = {4'b0, random_weight[2:0], random_weight[6], random_weight[15:14], random_weight[8:7]};
    
endmodule