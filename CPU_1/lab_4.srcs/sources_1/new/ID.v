`timescale 1ns / 1ps
`include "OP.v"
module ID(
    input[31:0]     inst,
    output[15:0]    offset,
    output[25:0]    instr_index,

    output[4:0]    addrA,
    output[4:0]    addrB,
    output[4:0]    addrC,              
    //control sign
    output[5:0]     func,
    output[5:0]     control
    );
    
    reg tmp;
    always @(*) begin
        case (inst[5:0])
            `ADD,`SUB,`AND,`OR,`XOR,`SLT,`MOVZ:tmp=1;
            default:tmp=0; 
        endcase
    end

    assign func=inst[5:0];

    
    assign iscal_flag=(inst[31:26]==`CAL)&(tmp)&(inst[10:6]==0);
    assign issll_flag=(inst[31:26]==`CAL)&(inst[5:0]==`SLL);
    assign issw_flag=inst[31:26]==`SW;
    assign islw_flag=inst[31:26]==`LW;
    assign isbne_flag=inst[31:26]==`BNE;
    assign isj_flag=inst[31:26]==`J;
    assign control[5:0]={iscal_flag,issll_flag,issw_flag,islw_flag,isbne_flag,isj_flag};

    wire[4:0] rs=(iscal_flag|isbne_flag)?inst[25:21]:0;
    wire[4:0] rt=(iscal_flag|issll_flag|issw_flag|islw_flag|isbne_flag)?inst[20:16]:0;
    wire[4:0] rd=(issll_flag|iscal_flag)?inst[15:11]:0;
    wire[4:0] sa=issll_flag?inst[10:6]:0;
    wire[4:0] base=(issw_flag|islw_flag)?inst[25:21]:0;
    assign offset=(isbne_flag|(issw_flag|islw_flag))?inst[15:0]:0;
    assign instr_index=isj_flag?inst[25:0]:0;

    //addrA == rs,sa,base
    //addrB == rt
    //addrC == rt(when lw),rd
    assign addrA= (iscal_flag|isbne_flag)?rs:
                      issll_flag?sa:
                      (issw_flag|islw_flag)?base:0;

    assign addrB= (iscal_flag|issll_flag|issw_flag|isbne_flag)?rt:0;
    assign addrC= (islw_flag)?rt:
                  (iscal_flag|issll_flag)?rd:0;

endmodule
