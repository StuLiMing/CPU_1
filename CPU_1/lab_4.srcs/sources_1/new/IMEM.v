`timescale 1ns / 1ps
`include "OP.v"
module IMEM(
    input[7:0] imem_addr,
    output[31:0] imem_out
    );
    
    reg[31:0] imem_regs[0:255];

    initial begin
        $readmemh("..\\..\\..\\..\\lab4.data\\data_data.txt",imem_regs);
    end
    assign imem_out=imem_regs[imem_addr];
endmodule
