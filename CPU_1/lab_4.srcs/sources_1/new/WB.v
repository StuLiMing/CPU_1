`timescale 1ns / 1ps
`include "OP.v"

module WB(
    input           movz_flag,
    input[31:0]     alu_output,
    input[31:0]     dmem_out,
    input[5:0]      control,
    output[31:0]    WB_data
    );
    
    assign WB_data = control[`iscal_flag]|control[`issll_flag]?           alu_output:
                     control[`islw_flag]?                                dmem_out:
                                                                        32'b0;

endmodule
