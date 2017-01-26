/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_file_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  logic [15:0] SignExtImm;
  logic [15:0] Imm;
  logic [4:0] shamt;

  logic pc_EN;
  word_t pc;
  word_t next_pc;
  word_t new_pc;

  control_unit_if cuif();
  control_unit CU(cuif);
  register_file_if rfif();
  register_file RF(CLK,nRST,rfif);
  alu_file_if afif();
  alu_file ALU(CLK,afif);
  request_unit_if ruif();
  request_unit RU(CLK,nRST,ruif);

  assign cuif.instruction = dpif.imemload;
  assign SignExtImm = (dpif.imemload[15] == 1)? 16'hffff : 16'h0000;
  assign dpif.dmemaddr = afif.output_port;
  assign dpif.imemaddr = pc;
  assign dpif.dmemstore = rfif.rdat2;
  assign pc_EN = dpif.ihit;
  assign ruif.MemtoReg = cuif.MemtoReg;
  assign ruif.MemWrite = cuif.MemWrite;
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
  assign dpif.imemREN = ruif.imemREN;
  assign dpif.dmemREN = ruif.dmemREN;
  assign dpif.dmemWEN = ruif.dmemWEN;
  assign new_pc = pc+4;

  

  always_comb begin

  dpif.halt = 0;
  //register
  rfif.WEN = 0;
  if (cuif.MemtoReg == 1)begin
      rfif.WEN = cuif.RWEN;
  end
  if(cuif.MemtoReg == 0)begin
  rfif.WEN = cuif.RWEN;
  end
  rfif.rsel1 = dpif.imemload[25:21];
  rfif.rsel2 = dpif.imemload[20:16];
  if(cuif.jump_addr == 3'b100 || cuif.jump_addr == 3'b010)begin
  rfif.wsel = 5'b11111;
  rfif.wdat = new_pc;
  end
  else begin
  rfif.wsel = 0;
  if (cuif.RegDst == 1)begin
    rfif.wsel = dpif.imemload[15:11];
  end
  if (cuif.RegDst == 0)begin
    rfif.wsel = dpif.imemload[20:16];
  end
  rfif.wdat = 0;
  if(cuif.MemtoReg == 1)begin
    rfif.wdat = dpif.dmemload;
  end
  if(cuif.MemtoReg == 0)begin
    rfif.wdat = afif.output_port;
  end

  end
  //alu
  afif.ALUOP = cuif.ALUop;
  afif.port_a = rfif.rdat1;
  afif.port_b = 0;
  if(cuif.ALUSrc == 0)begin
  afif.port_b = rfif.rdat2;
  end
  if(cuif.ALUSrc == 1)begin
    if(cuif.src_addr == 3'b001)begin
      afif.port_b = {SignExtImm,dpif.imemload[15:0]};//signext
    end
    if(cuif.src_addr == 3'b010)begin
      afif.port_b = {16'h0000,dpif.imemload[15:0]};//zeroext
    end
    if(cuif.src_addr == 3'b011)begin
      afif.port_b = {dpif.imemload[15:0],16'h0000};//lui
      afif.port_a = 0;
    end
    if(cuif.src_addr == 3'b100)begin
      afif.port_b = {24'h000000,3'b000,dpif.imemload[10:6]};//shamt not sure
    end
  end
  if (cuif.halt == 1)begin
  dpif.halt = 1;
  end
  end

always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0)begin
    pc <= 32'h000000;
  end
  else begin
    if(dpif.ihit == 1 && dpif.dhit == 0)begin
      pc <= next_pc;
      end
    end
  end
  always_comb begin
  //pc logic
    next_pc = new_pc;

  if (cuif.Jump == 1)begin
  if(cuif.jump_addr == 3'b001)begin
    next_pc = rfif.rdat1;
  end
  if(cuif.jump_addr == 3'b010)begin
    next_pc = {new_pc[31:28],dpif.imemload[25:0],2'b00};
  end
  if(cuif.jump_addr == 3'b100)begin
    next_pc = {new_pc[31:28],dpif.imemload[25:0],2'b00};
  end
end
if(cuif.Jump == 0)begin
  if(cuif.jump_addr == 3'b101)begin//bneq
    if(afif.zero == 1)begin
      next_pc = new_pc + ({16'h0000,dpif.imemload[15:0]} << 2);
  end
  else begin
  next_pc = new_pc;
  end
  end
  if(cuif.jump_addr == 3'b110)begin
   if(afif.zero == 0)begin
      next_pc = new_pc + ({16'h0000,dpif.imemload[15:0]} << 2);
  end
  else begin
  next_pc = new_pc;
  end
  end
end
end


endmodule
