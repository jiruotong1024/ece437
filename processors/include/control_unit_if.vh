`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"


interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  // access with cpuid on each processor
  parameter CPUS = 1;


  // arbitration
  logic   [CPUS-1:0]  RegDst,ALUSrc,MemtoReg,MemWrite,Branch,Jump,ExtOp,RWEN,halt;
  aluop_t ALUop;
  logic   [2:0] jump_addr;
  logic   [2:0] src_addr;
  word_t instruction;
  modport cu(
	input instruction,
	output RegDst,ALUSrc,MemtoReg,MemWrite,Branch,Jump,ExtOp,ALUop,jump_addr,src_addr,halt
);


endinterface

`endif
