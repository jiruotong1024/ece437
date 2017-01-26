/*
  alu file interface
*/
`ifndef ALU_FILE_IF_VH
`define ALU_FILE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_file_if;
  // import types
  import cpu_types_pkg::*;
  aluop_t ALUOP;
  word_t port_a, port_b, output_port;
  logic zero,overflow,negative;
  
  // alu file ports
  modport af (
    input   port_a, port_b, ALUOP,
    output  negative, zero, overflow, output_port
  );
  // alu file tb
  modport tb (
    output   port_a, port_b, ALUOP,
    input  negative, zero, overflow, output_port
  );
endinterface

`endif //ALU_FILE_IF_VH
