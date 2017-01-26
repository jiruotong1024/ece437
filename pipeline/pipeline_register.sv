`include "pipeline_register_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module pipeline_register (
	input logic CLK,
	input logic nRST,
	pipeline_register_if prif
	);


//IF
logic [31:0] IF_Instr;
logic [31:0] IF_next_pc;
logic IF_pc_en;
//ID
logic ID_pc_en;
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
 logic[31:0] ID_rdat1;
 logic [31:0] ID_rdat2;
 logic [31:0] ID_Instr;
 logic [31:0] ID_signExt;
 //EX
 logic EX_pc_en;
 logic [31:0] EX_next_pc;
 logic EX_MemtoReg;
 logic EX_MemWrite; 
 logic [31:0] EX_rdat2;
 logic [4:0] EX_Wsel;
logic [31:0] EX_aluOutput;
logic [31:0] EX_Nextpc;
logic [2:0] EX_Jump_addr;
logic EX_Jump;
logic EX_RWEN;
logic EX_halt;
logic [31:0] EX_branch_addr;
logic EX_zero;
logic [31:0] EX_Jorjal_addr;
logic [31:0] EX_rdat1;
//Mem
logic [2:0] Mem_Jump_addr;
logic [31:0] Mem_next_pc;
logic Mem_pc_en;
logic [31:0] Mem_data;
logic [31:0] Mem_aluOutput;
logic [4:0] Mem_Dst;
logic Mem_MemtoReg;
logic Mem_RWEN;
logic Mem_halt;

//halt
logic final_halt;

always_ff @(posedge CLK, negedge nRST)begin
if(nRST == 0)begin
//IF
IF_Instr <= 0;
IF_next_pc <= 0;
IF_pc_en <= 0;
//ID

 ID_pc_en <= 0;
 ID_next_pc <= 0;
 ID_RegDst <= 0;
 ID_ALUSrc <= 0;
 ID_MemtoReg <= 0;
 ID_Branch <= 0;
 ID_Jump <= 0;
 ID_ExtOp <= 0;
 ID_ALUop <= ALU_SLL;
 ID_RWEN <= 0;
 ID_halt <= 0;
 ID_jump_addr <= 0;
 ID_src_addr <= 0;
 ID_MemWrite <= 0;
 ID_rdat1 <= 0;
 ID_rdat2 <= 0;
 ID_signExt <= 0;
 ID_Instr <= 0;

 //EX
 EX_pc_en <= 0;
 EX_next_pc <= 0;
 EX_MemtoReg <= 0;
 EX_MemWrite <= 0;
 EX_rdat2 <= 0;
 EX_Wsel <= 0;
 EX_aluOutput <= 0;
 EX_Nextpc <= 0;
 EX_Jump_addr <= 0;
 EX_Jump <= 0;
 EX_RWEN <= 0;
 EX_halt <= 0;
 EX_branch_addr <= 0;
 EX_zero <= 0;
 EX_Jorjal_addr <= 0;
 EX_rdat1 <= 0;

 //Mem
 Mem_Jump_addr <= 0;
 Mem_next_pc <= 0;
 Mem_pc_en <= 0;
 Mem_data <= 0;
 Mem_aluOutput <= 0;
 Mem_Dst <= 0;
 Mem_MemtoReg <= 0;
 Mem_RWEN <= 0;
 Mem_halt <= 0;

 //halt
 final_halt <= 0;

end
else if(prif.branch_token == 1)begin
 //IF
 IF_Instr <= 0;
 IF_next_pc <= 0;
 IF_pc_en <= 0;
 //ID
 ID_pc_en <= 0;
 ID_next_pc <= 0;
 ID_RegDst <= 0;
 ID_ALUSrc <= 0;
 ID_MemtoReg <= 0;
 ID_Branch <= 0;
 ID_Jump <= 0;
 ID_ExtOp <= 0;
 ID_ALUop <= ALU_SLL;
 ID_RWEN <= 0;
 ID_halt <= 0;
 ID_jump_addr <= 0;
 ID_src_addr <= 0;
 ID_MemWrite <= 0;
 ID_rdat1 <= 0;
 ID_rdat2 <= 0;
 ID_signExt <= 0;
 ID_Instr <= 0;
//EX
 EX_pc_en <= 0;
 EX_next_pc <= 0;
 EX_MemtoReg <= 0;
 EX_MemWrite <= 0;
 EX_rdat2 <= 0;
 EX_Wsel <= 0;
 EX_aluOutput <= 0;
 EX_Nextpc <= 0;
 EX_Jump_addr <= 0;
 EX_Jump <= 0;
 EX_RWEN <= 0;
 EX_halt <= 0;
 EX_zero <= 0;
 EX_branch_addr <= 0;
 Mem_Jump_addr <= prif.Mem_inJump_addr;
 Mem_next_pc <= prif.Mem_innext_pc;
 Mem_pc_en <= prif.Mem_inpc_en;
 Mem_data <= prif.Mem_indata;
 Mem_aluOutput <= prif.Mem_inaluOutput;
 Mem_Dst <= prif.Mem_inDst;
 Mem_MemtoReg <= prif.Mem_inMemtoReg;
 Mem_RWEN <= prif.Mem_inRWEN;
 Mem_halt <= prif.Mem_inhalt;
 //halt
 final_halt <= prif.infinal_halt;
end
else begin
//IF

IF_Instr <= prif.IF_inInstr;
IF_next_pc <= prif.IF_innext_pc;
IF_pc_en <= prif.IF_inpc_en;
//ID
 ID_pc_en <= prif.ID_inpc_en;
 ID_Instr <= prif.ID_inInstr;
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
 ID_rdat1 <= prif.ID_inrdat1;
 ID_rdat2 <= prif.ID_inrdat2;
 ID_signExt <= prif.ID_inSignExt;

 //EX
 EX_pc_en <= prif.EX_inpc_en;
 EX_next_pc <= prif.EX_innext_pc;
 EX_MemtoReg <= prif.EX_inMemtoReg;
 EX_MemWrite <= prif.EX_inMemWrite;
 EX_rdat2 <= prif.EX_inrdat2;
 EX_Wsel <= prif.EX_inWsel;
 EX_aluOutput <= prif.EX_inaluOutput;
 EX_Nextpc <= prif.EX_inNextpc;
 EX_Jump_addr <= prif.EX_inJump_addr;
 EX_Jump <= prif.EX_inJump;
 EX_RWEN <= prif.EX_inRWEN;
 EX_halt <= prif.EX_inhalt;
 EX_branch_addr <= prif.EX_inbranch_addr;
 EX_zero <= prif.EX_inzero;
 EX_Jorjal_addr <= prif.EX_inJorjal_addr;
 EX_rdat1 <= prif.EX_inrdat1;

 //Mem
 Mem_Jump_addr <= prif.Mem_inJump_addr;
 Mem_next_pc <= prif.Mem_innext_pc;
 Mem_pc_en <= prif.Mem_inpc_en;
 Mem_data <= prif.Mem_indata;
 Mem_aluOutput <= prif.Mem_inaluOutput;
 Mem_Dst <= prif.Mem_inDst;
 Mem_MemtoReg <= prif.Mem_inMemtoReg;
 Mem_RWEN <= prif.Mem_inRWEN;
 Mem_halt <= prif.Mem_inhalt;

  //halt
 final_halt <= prif.infinal_halt;
//if(prif.pipeline_en == 1)begin
//IF_Instr <= 0;
end

end

//IF
assign prif.IF_outInstr = IF_Instr;
assign prif.IF_outnext_pc = IF_next_pc;
assign prif.IF_outpc_en = IF_pc_en;

//ID
assign prif.ID_outpc_en = ID_pc_en;
assign prif.ID_outInstr = ID_Instr;
assign prif.ID_outnext_pc = ID_next_pc;
assign prif.ID_outRegDst = ID_RegDst;
assign prif.ID_outALUSrc = ID_ALUSrc;
assign prif.ID_outMemtoReg = ID_MemtoReg;
assign prif.ID_outBranch = ID_Branch;
assign prif.ID_outJump = ID_Jump;
assign prif.ID_outExtOp = ID_ExtOp;
assign prif.ID_outALUop = ID_ALUop;
assign prif.ID_outRWEN = ID_RWEN;
assign prif.ID_outhalt = ID_halt;
assign prif.ID_outjump_addr = ID_jump_addr;
assign prif.ID_outsrc_addr = ID_src_addr;
assign prif.ID_outMemWrite = ID_MemWrite;
assign prif.ID_outrdat1 = ID_rdat1;
assign prif.ID_outrdat2 = ID_rdat2;
assign prif.ID_outSignExt = ID_signExt;



//EX
assign prif.EX_outpc_en = EX_pc_en;
assign prif.EX_outnext_pc = EX_next_pc;
assign prif.EX_outMemtoReg = EX_MemtoReg;
assign prif.EX_outMemWrite = EX_MemWrite;
assign prif.EX_outrdat2 = EX_rdat2;
assign prif.EX_outWsel = EX_Wsel;
assign prif.EX_outaluOutput = EX_aluOutput;
assign prif.EX_outNextpc = EX_Nextpc;
assign prif.EX_outJump_addr = EX_Jump_addr;
assign prif.EX_outJump = EX_Jump;
assign prif.EX_outRWEN = EX_RWEN;
assign prif.EX_outhalt = EX_halt;
assign prif.EX_outbranch_addr = EX_branch_addr;
assign prif.EX_outzero = EX_zero;
assign prif.EX_outJorjal_addr = EX_Jorjal_addr;
assign prif.EX_outrdat1 = EX_rdat1;

 //Mem
assign prif.Mem_outJump_addr = Mem_Jump_addr;
assign prif.Mem_outnext_pc = Mem_next_pc;
assign prif.Mem_outpc_en = Mem_pc_en;
assign prif.Mem_outdata = Mem_data;
assign prif.Mem_outaluOutput = Mem_aluOutput;
assign prif.Mem_outDst = Mem_Dst;
assign prif.Mem_outMemtoReg = Mem_MemtoReg;
assign prif.Mem_outRWEN = Mem_RWEN;
assign prif.Mem_outhalt = Mem_halt;

//halt
assign prif.outfinal_halt = final_halt;
endmodule