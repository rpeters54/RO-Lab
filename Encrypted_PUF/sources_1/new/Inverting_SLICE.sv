`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 06:19:45 PM
// Design Name: 
// Module Name: Inverting_SLICE
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


module Inverting_SLICE(
    (* dont_touch = "true" *) input [1:0] IN,
    (* dont_touch = "true" *) input SEL,
    (* dont_touch = "true" *) input BX,
    (* dont_touch = "true" *) output logic [1:0] OUT
    );
    
   (* dont_touch = "true" *) logic ac, bc, c_out;
    
    Inverting_LUT a (.IN(IN), .SEL(SEL), .OUT(ac));
    Inverting_LUT b (.IN(IN), .SEL(SEL), .OUT(bc));
    MUX2_1 #(1) c (.ZERO(ac), .ONE(bc), .SEL(BX), .F(c_out));
    
    (* dont_touch = "true" *) assign OUT[0] = c_out;
    (* dont_touch = "true" *) and (OUT[1], OUT[0], OUT[0]);
endmodule
