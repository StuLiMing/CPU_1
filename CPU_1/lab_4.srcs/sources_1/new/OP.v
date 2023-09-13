//OP
`define CAL  6'b000000     
`define SW   6'b101011
`define LW   6'b100011   
`define BNE  6'b000101
`define J    6'b000010

//func
`define ADD 6'b100000
`define SUB 6'b100010
`define AND 6'b100100
`define OR  6'b100101
`define XOR 6'b100110
`define SLT 6'b101010       
`define SLL 6'b000000       
`define MOVZ 6'b001010

`define iscal_flag 5
`define issll_flag 4
`define issw_flag 3
`define islw_flag 2
`define isbne_flag 1
`define isj_flag 0