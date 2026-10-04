`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2026 07:27:07 PM
// Design Name: 
// Module Name: tb_top_module
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


module tb_top_module;

    reg clk;
    reg rst;

    wire [31:0] pc;
    wire [31:0] inst;

    top_module uut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .inst(inst)
    );

  
    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 1;

        #10;
        rst = 0;

        $monitor("Time=%0t | PC=%d | INST=%h",
                 $time, pc, inst);

        #100;
        $finish;
    end

endmodule

