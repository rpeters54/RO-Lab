`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 09:09:50 PM
// Design Name: 
// Module Name: PUF_Wrapper
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


module PUF_Wrapper(
    input [7:0] challenge,
    input enable,
    input reset,
    input clk,
    output logic [7:0] response,
    output logic valid
    );
    
    logic ro_in; 
    logic [8:0] ro_out, ro_enable;
    logic [3:0] demux_select;
    
    Ring_Oscillator RO0 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[0]), .OUT(ro_out[0])); 
    Ring_Oscillator RO1 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[1]), .OUT(ro_out[1]));
    Ring_Oscillator RO2 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[2]), .OUT(ro_out[2]));
    Ring_Oscillator RO3 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[3]), .OUT(ro_out[3]));
    Ring_Oscillator RO4 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[4]), .OUT(ro_out[4]));
    Ring_Oscillator RO5 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[5]), .OUT(ro_out[5]));
    Ring_Oscillator RO6 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[6]), .OUT(ro_out[6]));
    Ring_Oscillator RO7 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[7]), .OUT(ro_out[7]));
    Ring_Oscillator RO8 (.SEL(challenge[5:3]), .BX(challenge[2:0]), .EN(ro_enable[8]), .OUT(ro_out[8]));
    
    Response_Handler RH (.en(enable), .rst(reset), .clk(clk), .ring_osc(ro_in), .response(response), .ro_select(demux_select), .valid(valid));
    
    always_comb begin
        ro_in = ro_out[demux_select];
        ro_enable = 9'b1 << demux_select;
    end
    

endmodule
