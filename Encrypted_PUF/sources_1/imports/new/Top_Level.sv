`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 05:56:23 PM
// Design Name: 
// Module Name: Top_Level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Level(
    input logic [7:0] challenge,
    input logic enable,
    output logic led,
    input logic rst 
);

logic output_bit;

logic [28:0] count; 
 

Ring_Oscillator RO (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(enable), .OUT(output_bit)); 

always_ff @(posedge output_bit) begin

    if(rst) begin 
        count <= 1;
        led <= 1;
     end
     
     if(count == 0) begin
        led <= ~led;     
     end
     
     count <= count + 1; 
     
end

endmodule
