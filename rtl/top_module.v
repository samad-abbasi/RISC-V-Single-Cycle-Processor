`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 04:53:05 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
 input clk,rst,
 output wire [31:0] pc,
 output wire [31:0] inst
    );
    


  
    wire[31:0]adder1_mux1;
    wire[31:0]adder2_mux1;
    wire CU_pcsrc_mux1;
    wire[31:0]mux1_pc;
    
   mux_2x1 m1 (.a(adder1_mux1),.b(adder2_mux1),.y(mux1_pc),.s(CU_pcsrc_mux1));  //need to add s with pcsrc of cu
   
    wire[31:0] pc_adder1;
   adder a1 (.A(pc_adder1),.B(32'd4), .sum(adder1_mux1));
   
    wire[31:0]Extend_out_adder2;
    adder a2 (.A(pc_adder1),.B(Extend_out_adder2), .sum(adder2_mux1));
//   module pc_32bit( clk,rst,prev_value,count

//   );
    pc_32bit p1 (.clk(clk), .rst(rst), .prev_value(mux1_pc), .count(pc_adder1));
    
    

    wire[31:0]IM_out;
    INST_MEM  IM1(.PC(pc_adder1), .Instruction_Code(IM_out));
    wire [1:0]CU_ImmSrc_Extend;
     Imm_Gen  IG_1(.instruction(IM_out), .immediate_output(Extend_out_adder2), .ImmSrc(CU_ImmSrc_Extend));
    
//    module REG_FILE(
// input [4:0] read_reg_num1,
// input [4:0] read_reg_num2,
// input [4:0] write_reg,   A\3
// input [31:0] write_data,  WD3
// output [31:0] read_data1,
// output [31:0] read_data2,
// input regwrite,  WE#
// input clock,
// input reset
//    );
    wire[31:0]mux3_reg_file ;  //mux3 to reg wd3
    wire CU_RegWrite_reg_file; //CU to WE@ of REg File
    
    wire[31:0]read_data1_wire;   //wire for RegFile data1
    wire[31:0]read_data2_wire;    //wire for RegFile data2
   
   
    REG_FILE RF_1(.clock(clk), .reset(rst), 
                .read_reg_num1(IM_out[19:15]), .read_reg_num2(IM_out[24:20]), .write_reg(IM_out[11:7]),
                .write_data(mux3_reg_file),
                .read_data1(read_data1_wire), .read_data2(read_data2_wire), .regwrite(CU_RegWrite_reg_file));
   
   wire[31:0]mux2_ALU ;
   wire ALUSrc_mux2;    //cu to mux2
    mux_2x1 m2 (.a(read_data2_wire),.b(Extend_out_adder2),.y(mux2_ALU),.s(ALUSrc_mux2));


  wire[2:0]ALUControl_ALU;
  wire[31:0]ALU_out;   // to dm and mx3
  wire zero_CU;  //alu to control unit zero
 ALU ALU_1 (.in1(read_data1_wire), .in2(mux2_ALU),.alu_control(ALUControl_ALU), 
            .result(ALU_out),.zero_flag(zero_CU));


wire[31:0]DM_mux3;
wire CU_MemWrite_DM;
//mem_write = WE
data_mem DM_1 (.clk(clk), .mem_write(CU_MemWrite_DM),.address(ALU_out), 
            .data_in(read_data2_wire),.data_out(DM_mux3));

//module mux_3x1 (
//    input  [1:0]  s,
//    input  [31:0] d0,
//    input  [31:0] d1,
//    input  [31:0] d2,
//    output reg [31:0] out
//);
   wire [1:0]CU_ResultSrc_mux3;    
   mux_3x1 m4 (.d0(ALU_out),.d1(DM_mux3),.d2(adder1_mux1),.s(CU_ResultSrc_mux3),.out(mux3_reg_file));


//module control_unit(
//    input  [6:0] op,
//    input  [2:0] funct3,
//    input        funct7_5,
//    input        Zero,
//    output       PCSrc,
//    output [1:0] ResultSrc,
//    output       MemWrite,
//    output       ALUSrc,
//    output [1:0] ImmSrc,
//    output       RegWrite,
//    output [2:0] ALUControl
//);
assign pc   = pc_adder1;
assign inst = IM_out;
control_unit CU1(.op(IM_out[6:0]),.funct3(IM_out[14:12]),.funct7_5(IM_out[30]),
                 .Zero(zero_CU),.PCSrc(CU_pcsrc_mux1),.RegWrite(CU_RegWrite_reg_file),
                 .ImmSrc(CU_ImmSrc_Extend),.ResultSrc(CU_ResultSrc_mux3),
                 .MemWrite(CU_MemWrite_DM),.ALUControl(ALUControl_ALU),
                 .ALUSrc(ALUSrc_mux2)
                  );


endmodule
