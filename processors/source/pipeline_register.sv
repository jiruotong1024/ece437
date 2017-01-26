`include "pipeline_registers_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module pipeline_registers (
	input logic CLK,
	input logic nRST,
	pipeline_registers_if prif
	);
//IF
logic [31:0] IF_Instr;
logic [31:0] IF_next_pc;
//ID
logic [31:0] ID_next_pc;
logic ID_RegDst;
logic ID_ALUSrc;
logic ID_MemtoReg;
logic ID_Branch;
logic ID_Jump;
logic ID_ExtOp;
aluop_t ID_ALUop;
logic ID_RWEN;
logic ID_halt;
logic [2:0] ID_jump_addr;
logic [2:0] ID_src_addr;
logic ID_MemWrite;

always_ff @(posedge CLK, negedge nRST)begin
if(nRST == 0)begin
//IF
IF_Instr <= 0;
IF_next_pc <= 0;
//ID
 ID_next_pc <= 0;
 ID_RegDst <= 0;
 ID_ALUSrc <= 0;
 ID_MemtoReg <= 0;
 ID_Branch <= 0;
 ID_Jump <= 0;
 ID_ExtOp <= 0;
 ID_ALUop <= 0;
 ID_RWEN <= 0;
 ID_halt <= 0;
 ID_jump_addr <= 0;
 ID_src_addr <= 0;
 ID_MemWrite <= 0;
end
else begin
//IF
IF_Instr <= prif.IF_inInstr;
IF_next_pc <= prif.IF_innext_pc;
//ID
 ID_next_pc <= prif.ID_innext_pc;
 ID_RegDst <= prif.ID_inRegDst;
 ID_ALUSrc <= prif.ID_inALUSrc;
 ID_MemtoReg <= prif.ID_inMemtoReg;
 ID_Branch <= prif.ID_inBranch;
 ID_Jump <= prif.ID_inJump;
 ID_ExtOp <= prif.ID_inExtOp;
 ID_ALUop <= prif.ID_inALUop;
 ID_RWEN <= prif.ID_inRWEN;
 ID_halt <= prif.ID_inhalt;
 ID_jump_addr <= prif.ID_injump_addr;
 ID_src_addr <= prif.ID_insrc_addr;
 ID_MemWrite <= prif.ID_inMemWrite;
//do not know what need to do at here
end
//IF
assign prif.IF_outInstr = IF_Instr;
assign prif.IF_outnext_pc = IF_next_pc;


//ID
assign prif.ID_outnext_pc = ID_next_pc;
assign prif.ID_outRegDst <= ID_RegDst;
assign prif.ID_outALUSrc <= ID_ALUSrc;
assign prif.ID_outMemtoReg <= ID_MemtoReg;
assign prif.ID_touBranch <= ID_Branch;
assign prif.ID_outJump <= ID_Jump;
assign prif.ID_outExtOp <= ID_ExtOp;
assign prif.ID_outALUop <= ID_ALUop;
assign prif.ID_outRWEN <= ID_RWEN;
assign prif.ID_outhalt <= ID_halt;
assign prif.ID_outjump_addr <= ID_jump_addr;
assign prif.ID_outsrc_addr <= ID_src_addr;
assign prif.ID_outMemWrite <= ID_MemWrite;
