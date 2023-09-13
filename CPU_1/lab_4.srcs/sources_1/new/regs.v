`timescale 1ns / 1ps
`include "OP.v"
module regs(
    input         clk,
    input[4:0] regs_r_addr_1,
    input[4:0] regs_r_addr_2,
    input[4:0] regs_w_addr,
    input[31:0] regs_w_data,
    input      regs_w_en,
    output[31:0]      regs_r_data_1,
    output[31:0]      regs_r_data_2
    );

    reg[31:0] Rs[0:31];

    initial begin
        Rs[0]=0;
    end
    
    always @(posedge clk) begin
        if(regs_w_en)begin
            Rs[regs_w_addr]<=regs_w_data;
        end
    end
   
    assign regs_r_data_1=Rs[regs_r_addr_1];
    assign regs_r_data_2=Rs[regs_r_addr_2];
endmodule
