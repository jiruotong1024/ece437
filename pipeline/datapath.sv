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
`include "pipeline_register_if.vh"
`include "hazard_unit_if.vh"


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
  logic [31:0] new_rdat2;

  logic pc_EN;
  word_t pc;
  word_t next_pc;
  word_t new_pc;
  logic next_halt;
  logic halt_register;
  logic [31:0] branch_addr;


  control_unit_if cuif();
  control_unit CU(cuif);
  register_file_if rfif();
  register_file RF(CLK,nRST,rfif);
  alu_file_if afif();
  alu_file ALU(CLK,afif);
  request_unit_if ruif();
  request_unit RU(CLK,nRST,ruif);
  pipeline_register_if prif();
  pipeline_register PR(CLK,nRST,prif);
  hazard_unit_if huif();
  hazard_unit HU(huif);


  assign new_rdat2 = (huif.hazard_type_b == 3'b010) ? prif.EX_outaluOutput : ((huif.hazard_type_b == 3'b100) ? rfif.wdat : prif.ID_outrdat2);
  assign pc_EN = (dpif.ihit == 1 && dpif.dhit == 0) ? 1 : 0;
  assign ruif.MemtoReg = prif.EX_outMemtoReg;
  assign dpif.imemREN = ruif.imemREN;//???
  assign dpif.dmemREN = prif.EX_outMemtoReg;//??
  assign dpif.dmemWEN = prif.EX_outMemWrite;//????
  assign dpif.imemaddr = pc;
  assign dpif.dmemstore = prif.EX_outrdat2;
  //assign dpif.dmemstore = (huif.hazard_type_b == 3'b010) ? prif.EX_outaluOutput : ((huif.hazard_type_b == 3'b100) ? rfif.wdat : prif.EX_outrdat2);
  assign ruif.MemWrite = prif.EX_outMemWrite;
  assign dpif.dmemaddr = prif.EX_outaluOutput;
  assign cuif.instruction = prif.IF_outInstr;
  
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
  assign rfif.rsel1 = prif.IF_outInstr[25:21];
  assign rfif.rsel2 = prif.IF_outInstr[20:16];
  assign prif.pipeline_en = dpif.dhit;
/*
  assign pc_EN = dpif.ihit;
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
*/
//start pipeline
//IF
  assign prif.IF_inInstr = (huif.hazard_type_a == 3'b001 | huif.hazard_type_a == 3'b011 | huif.hazard_type_b == 3'b001 | huif.hazard_type_b == 3'b011 | dpif.dhit == 1) ? 0 : dpif.imemload;
  assign prif.IF_innext_pc = (huif.hazard_type_a == 3'b001 | huif.hazard_type_a == 3'b011 | huif.hazard_type_b == 3'b001 | huif.hazard_type_b == 3'b011) ? pc : next_pc;
  assign prif.IF_inpc_en = pc_EN;

//ID
assign prif.ID_inpc_en = prif.IF_outpc_en;
assign prif.ID_innext_pc = prif.IF_outnext_pc;
assign prif.ID_inRegDst = cuif.RegDst;
assign prif.ID_inALUSrc = cuif.ALUSrc;
assign prif.ID_inMemtoReg = cuif.MemtoReg;
assign prif.ID_inBranch = cuif.Branch;
assign prif.ID_inJump = cuif.Jump;
assign prif.ID_inExtOp = cuif.ExtOp;
assign prif.ID_inALUop = cuif.ALUop;
assign prif.ID_inRWEN = cuif.RWEN;
assign prif.ID_inhalt = cuif.halt;
assign prif.ID_injump_addr = cuif.jump_addr;
assign prif.ID_insrc_addr = cuif.src_addr;
assign prif.ID_inMemWrite = cuif.MemWrite;
assign prif.ID_inrdat1 = rfif.rdat1;
assign prif.ID_inrdat2 = rfif.rdat2;
assign prif.ID_inInstr = prif.IF_outInstr;
assign prif.ID_inSignExt = {(prif.IF_outInstr[15] == 1)? 16'hffff : 16'h0000,prif.IF_outInstr[15:0]};

//EX
assign prif.EX_inpc_en = prif.ID_outpc_en;
assign prif.EX_innext_pc = prif.ID_outnext_pc;
assign prif.EX_inMemtoReg = prif.ID_outMemtoReg;
assign prif.EX_inMemWrite = prif.ID_outMemWrite;
assign prif.EX_inrdat2 = (huif.hazard_type_b == 3'b010) ? prif.EX_outaluOutput : ((huif.hazard_type_b == 3'b100) ? rfif.wdat : prif.ID_outrdat2);
assign prif.EX_inaluOutput = afif.output_port;
assign prif.EX_inRWEN = prif.ID_outRWEN;
assign prif.EX_inhalt = prif.ID_outhalt;
assign prif.EX_inWsel = (prif.ID_outRegDst == 1)? prif.ID_outInstr[15:11] : prif.ID_outInstr[20:16];
assign prif.EX_inbranch_addr = (((prif.ID_outInstr[15] == 0) ? {16'h0000, prif.ID_outInstr[15:0]} : {16'hffff, prif.ID_outInstr[15:0]}) << 2) + prif.ID_outnext_pc;
 //prif.ID_outnext_pc + ({16'h0000,prif.ID_outInstr[15:0]} << 2);
assign prif.EX_inzero = afif.zero;
assign prif.EX_inJump = prif.ID_outJump;
assign prif.EX_inJump_addr = prif.ID_outjump_addr;
assign prif.EX_inJorjal_addr = {prif.ID_outnext_pc[31:28],prif.ID_outInstr[25:0],2'b00};
assign prif.EX_inrdat1 = prif.ID_outrdat1;

 
//MEM
assign prif.Mem_inJump_addr = prif.EX_outJump_addr;
assign prif.Mem_innext_pc = prif.EX_outnext_pc;
assign prif.Mem_inpc_en = prif.EX_outpc_en;
assign prif.Mem_indata = dpif.dmemload;
assign prif.Mem_inaluOutput = prif.EX_outaluOutput;
assign prif.Mem_inDst = prif.EX_outWsel;
assign prif.Mem_inMemtoReg = prif.EX_outMemtoReg;
assign prif.Mem_inRWEN = prif.EX_outRWEN;
assign prif.Mem_inhalt = prif.EX_outhalt;

//halt
assign prif.infinal_halt = prif.Mem_outhalt;

//hazard unit
assign huif.ID_RegRs = prif.ID_outInstr[25:21];
assign huif.EX_RegRd = (prif.EX_outRWEN == 1) ? prif.EX_outWsel : 0;
assign huif.Mem_RegRd = (prif.Mem_outRWEN == 1) ? prif.Mem_outDst : 0;
assign huif.lw = prif.EX_outMemtoReg;
assign huif.ID_RegRt = prif.ID_outInstr[20:16];
assign huif.lw_later = prif.Mem_outMemtoReg & prif.EX_outMemtoReg;
assign dpif.halt = halt_register;
assign next_halt = prif.Mem_outhalt;


  always_comb begin
  rfif.wdat = 0;
 // dpif.halt = 0;
  //register
  rfif.WEN = 0;
  if (prif.Mem_outMemtoReg == 1)begin
      rfif.WEN = prif.Mem_outRWEN;
  end
  if(prif.Mem_outMemtoReg == 0)begin
  rfif.WEN = prif.Mem_outRWEN;
  end
  rfif.wsel = prif.Mem_outDst;
  if(prif.Mem_outJump_addr == 3'b100)begin //|| prif.Mem_outJump_addr == 3'b010)begin
  rfif.wsel = 5'b11111;
  rfif.WEN = 1;
  rfif.wdat = prif.Mem_outnext_pc;
  end
  //else begin
  //rfif.wsel = 0;
  /*prif.EX_inWsel = 0;
  if (prif.ID_outRegDst == 1)begin
    //rfif.wsel = prif.IF_outInstr[15:11];
    prif.EX_inWsel = prif.ID_outInstr[15:11];
  end
  if (prif.ID_outRegDst == 0)begin
    prif.EX_inWsel = prif.ID_outInstr[20:16];
    //rfif.wsel = prif.IF_outInstr[20:16];
  end*/
  //rfif.wdat = 0;
  else begin
  if(prif.Mem_outMemtoReg == 1)begin
    rfif.wdat = prif.Mem_outdata;
  end
  if(prif.Mem_outMemtoReg == 0)begin
    rfif.wdat = prif.Mem_outaluOutput;
  end
  end

  //end
  //alu
 
  afif.ALUOP = prif.ID_outALUop;
  afif.port_a = prif.ID_outrdat1;
  if(huif.hazard_type_a == 3'b010 || huif.hazard_type_a == 3'b011)begin
  afif.port_a = prif.EX_outaluOutput;
  end
  if(huif.hazard_type_a == 3'b100 || huif.hazard_type_a == 3'b011)begin
  afif.port_a = rfif.wdat;
  end
  if(huif.hazard_type_a == 3'b001)begin
  afif.port_a = prif.Mem_indata;
  end
  afif.port_b = 0;
  if(prif.ID_outALUSrc == 0)begin
  afif.port_b = prif.ID_outrdat2;
  if(huif.hazard_type_b == 3'b010 || huif.hazard_type_b == 3'b011)begin
  afif.port_b = prif.EX_outaluOutput;
  end
  if(huif.hazard_type_b == 3'b100 || huif.hazard_type_b == 3'b011)begin
  afif.port_b = rfif.wdat;
  end
  if(huif.hazard_type_b == 3'b001)begin
  afif.port_b = prif.Mem_indata;
  end
end

  if(prif.ID_outALUSrc == 1)begin
    if(prif.ID_outsrc_addr == 3'b001)begin
      afif.port_b = {(prif.ID_outInstr[15] == 1)? 16'hffff : 16'h0000,prif.ID_outInstr[15:0]};//signext
    end
    if(prif.ID_outsrc_addr == 3'b010)begin
      afif.port_b = {16'h0000,prif.ID_outInstr[15:0]};//zeroext
    end
    if(prif.ID_outsrc_addr == 3'b011)begin
      afif.port_b = {prif.ID_outInstr[15:0],16'h0000};//lui
      afif.port_a = 0;
    end
    if(prif.ID_outsrc_addr == 3'b100)begin
      afif.port_b = {24'h000000,3'b000,prif.ID_outInstr[10:6]};//shamt not sure
    end
  end





  //if (prif.outfinal == 1)begin
  //dpif.halt = 1;
  //end
  end

always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0)begin
    pc <= 32'h000000;
  end
  else begin
    if(dpif.dhit == 0 && dpif.ihit == 1)begin
      pc <= next_pc;
      end
    if(dpif.dhit == 1)begin
    pc <= pc;
    end
    end

if(!nRST)begin
halt_register <= 0;
end
else begin
if(next_halt)begin
halt_register <= next_halt;
end
  end
end
  always_comb begin
next_pc = pc+4;
  prif.branch_token = 0;
  if (prif.EX_outJump == 1)begin//
  if(prif.EX_outJump_addr == 3'b001)begin//JR
    next_pc = prif.EX_outrdat1;
    prif.branch_token = 1;
  end
  if(prif.EX_outJump_addr == 3'b010)begin//J
    next_pc = prif.EX_outJorjal_addr;
    prif.branch_token = 1;
  end
  if(prif.EX_outJump_addr == 3'b100)begin//JAL
    next_pc = prif.EX_outJorjal_addr;
    prif.branch_token = 1;
  end
end
if(prif.EX_outJump == 0)begin
  if(prif.EX_outJump_addr == 3'b101)begin//beq
    if(prif.EX_outzero == 1)begin
      next_pc = prif.EX_outbranch_addr;
      prif.branch_token = 1;
  end
  else begin
  next_pc = pc+4;
  end
  end
  if(prif.EX_outJump_addr == 3'b110)begin//BNEQ
   if(prif.EX_outzero == 0)begin
      
      next_pc = prif.EX_outbranch_addr;
      prif.branch_token = 1;
  end
  else begin
  next_pc = pc+4;
  end
  end
end
end



endmodule
