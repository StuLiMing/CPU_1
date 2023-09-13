`timescale 1ns / 1ps
`include "OP.v"

module DMEM(
    input clk,
    input[7:0] dmem_addr,
    input[31:0] dmem_in,
    output[31:0] dmem_out,
    input[5:0]    control
    );
    wire dmem_wen=control[`issw_flag];
    reg[31:0] dmem_regs[0:255];
    initial begin
        $readmemh("..\\..\\..\\..\\lab4.data\\data_data.txt",dmem_regs);
    end
    always @(posedge clk) begin
        if(dmem_wen)begin
            dmem_regs[dmem_addr]<=dmem_in;
        end
    end

    assign dmem_out=dmem_regs[dmem_addr];

endmodule
