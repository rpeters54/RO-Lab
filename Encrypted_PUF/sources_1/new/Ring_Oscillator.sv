`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 11:36:42 PM
// Design Name: 
// Module Name: Ring_Oscillator
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


module Ring_Oscillator(
    (* dont_touch = "true" *) input [2:0] SEL,
    (* dont_touch = "true" *) input [2:0] BX,
    (* dont_touch = "true" *) input EN,
    (* dont_touch = "true" *) output logic OUT
    );
    
    (* dont_touch = "true" *) logic [1:0] ab, bc, ca;

    //Ring Oscillator connects three slices in a cycle
    Double_SLICE  a (.IN(ca), .SEL(SEL[0]), .BX(BX[0]), .OUT(ab), .EN(EN));
    Inverting_SLICE  b (.IN(ab), .SEL(SEL[1]), .BX(BX[1]), .OUT(bc));
    Inverting_SLICE  c (.IN(bc), .SEL(SEL[2]), .BX(BX[2]), .OUT(ca));
    (* dont_touch = "true" *) assign OUT = ca;
endmodule
