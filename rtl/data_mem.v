`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 08:31:29 PM
// Design Name: 
// Module Name: data_mem
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

module data_mem(
input clk,mem_write, //mem_read,  //read and write enable
input [31:0] address, data_in,  //byte address and data to write
output reg [31:0] data_out    //data read
);

//1 KB byte-adressable memory 
reg [7:0] memory [1023:0];
always @(posedge clk) begin 

// WRITE Operation 
    if (mem_write) begin 
        memory[address] <= data_in[7:0];
        memory[address + 1] <= data_in[15:8];
        memory[address + 2] <= data_in[23:16];
        memory[address + 3] <= data_in[31:24];
    end 

// READ Operation 
    else if (!mem_write) begin 
        data_out [7:0] <= memory[address];
        data_out [15:8] <= memory[address + 1];
        data_out [23:16] <= memory[address + 2];
        data_out [31:24] <= memory[address + 3];
    end
     
    
end

endmodule