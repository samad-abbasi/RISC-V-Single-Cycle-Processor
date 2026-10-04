`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 04:57:49 PM
// Design Name: 
// Module Name: REG_FILE
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


module REG_FILE(
 input [4:0] read_reg_num1,
 input [4:0] read_reg_num2,
 input [4:0] write_reg,
 input [31:0] write_data,
 output [31:0] read_data1,
 output [31:0] read_data2,
 input regwrite,
 input clock,
 input reset
    );
    
    reg [31:0] reg_memory [31:0];
    integer i; 
 always@(posedge clock or posedge reset) begin
    if(reset) begin
       for (i=0;i<32; i=i+1) begin
          reg_memory[i]<=i;
       end
       end
    else if (regwrite && (write_reg!=0)) begin
    reg_memory[write_reg]<=write_data;
     end
     end
     assign read_data1 = reg_memory[read_reg_num1];
     assign read_data2 = reg_memory[read_reg_num2];
            

endmodule
