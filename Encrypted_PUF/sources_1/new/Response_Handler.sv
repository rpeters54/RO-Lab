`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 06:57:28 PM
// Design Name: 
// Module Name: Response_Handler
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
//01312D00

module Response_Handler(
    input en,
    input rst,
    input clk,
    input ring_osc,
    output logic [7:0] response, //response to the input challenge
    output logic [3:0] ro_select, //used to select which ro and ro_count register are currently being used
    output logic valid
    );
    
    typedef enum{STANDBY, CLEAR, SELECT, COUNT, STORE, RESPOND}state;
    state PS = STANDBY;
    state NS;
    
    logic clear_ro;
    logic [31:0] register [0:8];
    logic [31:0] ro_count, clk_count;
    /*
    initial begin
        //set select to last ro by default
        ro_select <= 4'd8;
        //set response to zero by default
        response <= 0;
        clk_count <= 0;
    end
    */
    always_ff @ (posedge clk) begin
        //update state on clk edge
        if (rst == 1'b1) begin
            PS <= STANDBY;
            response <= 0;
            valid <= 0;
        end else
            PS <= NS;

        case(PS)
            STANDBY : begin
                ro_select <= 4'd8;
            end
            CLEAR : begin
                valid <= 0;
                for (int i = 0; i < 9; i++) begin
                    register[i] <= 0;
                end
            end
            //increment/clear ro_select
            SELECT : begin
                clk_count <= 0;
                clear_ro <= 1;
                if (ro_select == 4'd8)
                    ro_select <= 0;
                else  
                    ro_select <= ro_select + 1;
            end
            COUNT : begin
                clear_ro <= 0;
                clk_count <= clk_count + 1;
            end
            STORE : begin
                register[ro_select] <= ro_count;
            end
            RESPOND : begin
                valid <= 1;
                for (int i = 0; i < 8; i++) begin
                    response[i] <= (register[i] < register[i+1]);
                end
            end
        endcase
    end
    
    always_ff @ (posedge ring_osc, posedge clear_ro) begin
        if (PS == COUNT)
            ro_count <= ro_count + 1;
        if (clear_ro)
            ro_count <= 0;
    end
    
    always_comb begin
        
        case(PS)
            //In Standby, do nothing until enable is set
            //Move to CLEAR next
            STANDBY : begin
                if (en)
                    NS = CLEAR;
                else
                    NS = STANDBY;
            end
            //In Clear, ro_registers are all cleared
            //Move to SELECT next
            CLEAR : begin
                NS = SELECT;
            end
            //In Select, next ro is selected for counting
            //Move to COUNT next
            SELECT : begin
                NS = COUNT;
            end
            //In Count, wait until clk_count reaches threshold, then:
            //If not all ROs have been counted, return to SELECT
            //Otherwise, move on to calculate response
            COUNT : begin
                if (clk_count >= 32'h0000FFFF) begin
                    NS = STORE;
                end else 
                    NS = COUNT;
            end
            
            STORE : begin
                if (ro_select < 4'd8) begin
                    NS = SELECT;
                end else begin
                    NS = RESPOND;
                end
            end
            //In Respond, Compute a new response given the measured values
            //in all the ro_registers. Return to STANDBY afterward
            RESPOND : begin
                NS = STANDBY;
            end
            //If an error is encountered, default to STANDBY
            default : NS = STANDBY;
        endcase
    end
    
endmodule
