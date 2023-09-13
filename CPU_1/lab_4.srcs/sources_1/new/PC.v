`timescale 1ns / 1ps
`include "OP.v"

module PC(
    input           clk,
    input           rst_n,
    input[5:0]      control,
    input[15:0]     offset,
    input[25:0]     instr_index,
    input[31:0]     alu_output,
    output[31:0]    pc
    );
    reg[31:0]   pc_reg;
    wire[31:0]  npc=pc_reg+1;
    always @(posedge clk) begin
        if(~rst_n)pc_reg<=0;
        else if(control[`isbne_flag])pc_reg<=alu_output?({{16{offset[15]}},offset}+npc):npc;
        else if(control[`isj_flag])pc_reg<={npc[31:26],instr_index};
        else    pc_reg<=npc;
    end
    assign pc=pc_reg;
endmodule


