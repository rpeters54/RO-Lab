`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2023 04:12:10 PM
// Design Name: 
// Module Name: Encrypted_PUF
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


module Encrypted_PUF(
    input [7:0] challenge,
    input [3:0] output_select,
    input start,
    input reset,
    input clk,
    output logic [7:0] response,
    output logic [6:0] sseg,
    output logic [3:0] an,
    output logic valid
    );
   
    logic [15:0] encrypt_in, to_display;
    logic [7:0] prev_challenge = 0;
    logic [127:0] encrypt_out;
    logic resp_done, encrypt_done, resp_enable;
    
    PUF_Wrapper PW (.challenge(challenge), .enable(resp_enable), .reset(reset), .clk(clk), .response(response), .valid(resp_done));
    sha128_simple ESS (.CLK(clk), .DATA_IN(encrypt_in), .RESET(reset), .START(resp_enable), .READY(encrypt_done), .DATA_OUT(encrypt_out));
    sseg_des SSD (.COUNT(to_display), .CLK(clk), .VALID(valid), .DISP_EN(an), .SEGMENTS(sseg));
    
    always_comb begin
        encrypt_in = (challenge << 8) + response;
        valid = resp_done & encrypt_done;
        case(output_select)
            4'd0  : to_display = encrypt_in;
            4'd1  : to_display = encrypt_out[15:0];
            4'd2  : to_display = encrypt_out[31:16];
            4'd3  : to_display = encrypt_out[47:32];
            4'd4  : to_display = encrypt_out[63:48];
            4'd5  : to_display = encrypt_out[79:64];
            4'd6  : to_display = encrypt_out[95:80];
            4'd7  : to_display = encrypt_out[111:96];
            4'd8  : to_display = encrypt_out[127:112];
            default : to_display = 0;
        endcase
    end
    
    always_ff @ (posedge clk) begin
        if (start || (prev_challenge != challenge))
            resp_enable <= 1'b1;
        else
            resp_enable <= 0;
        prev_challenge <= challenge;    
    end
endmodule
