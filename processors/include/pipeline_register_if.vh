`ifndef PIPELINE_REGISTER_IF_VH
`define PIPELINE_REGISTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_registers_if;
  // import types
  import cpu_types_pkg::*;

//IF input
logic [31:0] IF_inInstr;
logic [31:0] IF_innext_pc;
//IF output
logic [31:0] IF_outInstr;
logic [31:0] IF_outnext_pc;


//ID input
logic [31:0] ID_innext_pc;
logic ID_inRegDst;
logic ID_inALUSrc;
logic ID_inMemtoReg;
logic ID_inBranch;
logic ID_inJump;
logic ID_inExtOp;
aluop_t ID_inALUop;
logic ID_inRWEN;
logic ID_inhalt;
logic [2:0] ID_injump_addr;
logic [2:0] ID_insrc_addr;
logic ID_inMemWrite;
//ID outputs
logic ID_outnext_pc;
logic ID_outRegDst;
logic ID_outALUSrc;
logic ID_outMemtoReg;
logic ID_outBranch;
logic ID_outJump;
logic ID_outExtOp;
aluop_t ID_outALUop;
logic ID_outRWEN;
logic ID_outhalt;
logic [2:0] ID_outjump_addr;
logic [2:0] ID_outsrc_addr;
logic ID_outMemWrite;


//EX input
logic [4:0] EX_RegDst;
logic EX_zero;
logic [31:0] EX_result;
logic [31:0] EX_wdat;
//EX output
logic

//MEM input
logic [31:0] Mem_indata;


