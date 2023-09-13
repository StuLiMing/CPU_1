`timescale 1ns / 1ps
`include "OP.v"

module alu(
    input[5:0]          func,         
    input[31:0]         A,           
    input[31:0]         B,  
    input[15:0]         offset,   
    input[5:0]          control, 
    output[31:0]    alu_output,        
    output              movz_flag,
    output              regs_w_en   
    );

    wire[31:0] add_result;
    wire[31:0] sub_result;
    wire[31:0] and_result;
    wire[31:0] or_result;
    wire[31:0] xor_result;
    wire[31:0] slt_result; 
    wire[31:0] sll_result;      

    assign add_result=A+B;
    assign sub_result=A-B;
    assign and_result=A&B;
    assign or_result=A|B;
    assign xor_result=A^B;
    assign slt_result=(A<B)?32'b1:32'b0;
    assign sll_result=B<<A;
    assign movz_flag=(func==`MOVZ)&(B==32'b0);
    assign regs_w_en=~((func==`MOVZ)&B)&(control[`iscal_flag]|control[`issll_flag]|control[`islw_flag]);

    reg[31:0] alu_output_reg;
    always @(*) begin
        if(control[`islw_flag]|control[`issw_flag])begin
            alu_output_reg<=(A+{{18{offset[15]}},offset>>2});
        end
        else if(control[`isbne_flag]) begin
            alu_output_reg<=~(A==B);
        end
        else begin
            case (func)
                `ADD:alu_output_reg<=add_result;
                `SUB:alu_output_reg<=sub_result;
                `AND:alu_output_reg<=and_result;
                `OR:alu_output_reg<=or_result;
                `XOR:alu_output_reg<=xor_result;
                `SLT:alu_output_reg<=slt_result;
                `SLL:alu_output_reg<=sll_result;
                `MOVZ:alu_output_reg<=A;
                default:alu_output_reg<=32'b0;
            endcase
        end

    end

    assign alu_output=alu_output_reg;


endmodule
