`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 06:15:42 PM
// Design Name: 
// Module Name: Double_LUT
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


module Double_LUT(
    (* dont_touch = "true" *) input [1:0] IN,
    (* dont_touch = "true" *) input SEL,
    (* dont_touch = "true" *) input EN,
    (* dont_touch = "true" *) output logic OUT
    );
    
    (* dont_touch = "true" *) logic mux_wire;
    (* dont_touch = "true" *) logic [1:0] in_not;
    
    (* dont_touch = "true" *) not (in_not[0], IN[0]);
    (* dont_touch = "true" *) not (in_not[1], IN[1]);
    
    MUX2_1 #(1) m (.ZERO(in_not[0]), .ONE(in_not[1]), .SEL(SEL), .F(mux_wire));
    MUX2_1 #(1) n (.ZERO(1'b0), .ONE(mux_wire), .SEL(EN), .F(OUT));
endmodule
