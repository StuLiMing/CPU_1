`timescale 1ns / 1ps
`include "OP.v"
module cpu (
    input clk , // clock, 100MHz
    input rst_n , // active low

    // debug signals
    output[31:0]        debug_wb_pc , 
    output              debug_wb_rf_wen,
    output[4:0]         debug_wb_rf_addr,
    output[31:0]        debug_wb_rf_wdata
    );

    wire[31:0]  inst;          
    wire[15:0]  offset;
    wire[25:0]  instr_index;
    wire[31:0]  pc;       

    // control sign
    wire[5:0] control;
    wire[5:0] func;
    wire regs_w_en;
    

    wire[4:0]  addrA;
    wire[4:0]  addrB;
    wire[4:0]  addrC;
    wire[31:0]  A;
    wire[31:0]  B;
    wire[31:0]  WB_data;
    wire[31:0]  alu_output;
    wire[31:0]  dmem_out;


    assign debug_wb_pc=pc<<2;
    assign debug_wb_rf_wen=regs_w_en;
    assign debug_wb_rf_addr=addrC;
    assign debug_wb_rf_wdata=WB_data;

    IMEM IMEM1(
        .imem_addr(pc[7:0]), 
        .imem_out(inst)
    );

    DMEM DMEM1(
        .clk(clk),
        .dmem_addr(alu_output[7:0]),
        .control(control),
        .dmem_in(B),
        .dmem_out(dmem_out)
    );

    ID ID1(
        .inst(inst),
        .offset(offset),
        .instr_index(instr_index),      
        .addrA(addrA),
        .addrB(addrB),
        .addrC(addrC),
        .func(func),
        .control(control)
    );

    WB WB1(
        .movz_flag(movz_flag),
        .alu_output(alu_output),
        .dmem_out(dmem_out),
        .control(control),
        .WB_data(WB_data)
    );

    alu alu1(
        .func(func),
        .A(A),
        .B(B),
        .offset(offset),
        .control(control),
        .alu_output(alu_output),
        .movz_flag(movz_flag),
        .regs_w_en(regs_w_en)
    );

    PC PC1(
        .clk(clk), 
        .rst_n(rst_n), 
        .control(control),
        .instr_index(instr_index),
        .alu_output(alu_output),
        .offset(offset),
        .pc(pc)
    );


    regs regs1(
        .clk(clk),
        .regs_w_en(regs_w_en),
        .regs_r_addr_1(addrA),
        .regs_r_addr_2(addrB),
        .regs_w_addr(addrC),
        .regs_w_data(WB_data),            
        .regs_r_data_1(A),
        .regs_r_data_2(B)
    );
endmodule
