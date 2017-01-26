`include "control_unit_if.vh"
// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module control_unit (
  control_unit_if cuif
);

always_comb begin
cuif.RegDst = 0;
cuif.ALUSrc = 0;
cuif.MemtoReg = 0;
cuif.Branch = 0;
cuif.Jump = 0;
cuif.ExtOp = 0;
cuif.ALUop = ALU_SLL;
cuif.RWEN = 0;
cuif.halt = 0;
cuif.jump_addr = 3'b000; 
cuif.src_addr = 3'b000;
cuif.MemWrite = 0;
if (cuif.instruction[31:26] == RTYPE) begin
	//function code
	if(cuif.instruction[5:0] == SLL)begin
	cuif.ALUop = ALU_SLL;
	cuif.src_addr = 3'b100;//shamt
	cuif.ALUSrc = 1;
	cuif.RegDst = 1;
	cuif.RWEN = 1;
	end
	if(cuif.instruction[5:0] == SRL) begin
	cuif.ALUop = ALU_SRL;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	cuif.src_addr = 3'b100;
	end
	if(cuif.instruction[5:0] == JR) begin
	cuif.Jump = 1;
	cuif.RWEN = 0;
	cuif.jump_addr = 3'b001;//jr
	end
	if(cuif.instruction[5:0] == ADD) begin
	cuif.ALUop = ALU_ADD;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == ADDU)begin
	cuif.ALUop = ALU_ADD;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == SUB)begin
	cuif.ALUop = ALU_SUB;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == SUBU)begin
	cuif.ALUop = ALU_SUB;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == AND)begin
	cuif.ALUop = ALU_AND;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == OR)begin
	cuif.ALUop = ALU_OR;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == XOR)begin
	cuif.ALUop = ALU_XOR;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == NOR)begin
	cuif.ALUop = ALU_NOR;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == SLT)begin
	cuif.ALUop = ALU_SLT;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
	if(cuif.instruction[5:0] == SLTU)begin
	cuif.ALUop = ALU_SLTU;
	cuif.RWEN = 1;
	cuif.RegDst = 1;
	end
end
if (cuif.instruction[31:26] == J)begin
	cuif.Jump = 1;
	cuif.RWEN = 0;
	cuif.jump_addr = 3'b010;
	end
if (cuif.instruction[31:26] == JAL)begin
	cuif.Jump = 1;
	cuif.RWEN = 1;
	cuif.jump_addr = 3'b100;
end
if(cuif.instruction[31:26] == BEQ)begin
	cuif.ALUop = ALU_SUB;
	cuif.RWEN = 0;
	cuif.jump_addr = 3'b101;
	cuif.Branch = 1;
end
if(cuif.instruction[31:26] == BNE)begin
	cuif.ALUop = ALU_SUB;
	cuif.RWEN = 0;
	cuif.jump_addr = 3'b110;
	cuif.Branch = 1;
end
if(cuif.instruction[31:26] == ADDI)begin
	cuif.ALUop = ALU_ADD;
	cuif.ALUSrc = 1;
	cuif.src_addr = 3'b001;
	cuif.RWEN = 1;
end
if(cuif.instruction[31:26] == ADDIU)begin
	cuif.ALUop = ALU_ADD;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b001;//signextimm
end
if(cuif.instruction[31:26] == SLTI)begin
	cuif.ALUop = ALU_SLT;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b001;
end
if(cuif.instruction[31:26] == SLTIU)begin
	cuif.ALUop = ALU_SLT;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b001;
end
if(cuif.instruction[31:26] == ANDI)begin
	cuif.ALUop = ALU_AND;
	cuif.RWEN = 1;
	cuif.ALUSrc = 1;
	cuif.src_addr = 3'b010;//zeroextimm
end
if(cuif.instruction[31:26] == ORI)begin
	cuif.ALUop = ALU_OR;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b010;
end
if(cuif.instruction[31:26] == XORI)begin
	cuif.ALUop = ALU_XOR;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b010;
end
if(cuif.instruction[31:26] == LUI)begin
	cuif.ALUop = ALU_OR;
	cuif.RegDst = 0;
	cuif.ALUSrc = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b011;//for lui
end
if(cuif.instruction[31:26] == LW)begin
	cuif.ALUop = ALU_ADD;
	cuif.ALUSrc = 1;
	cuif.MemtoReg = 1;
	cuif.ExtOp = 1;
	cuif.RWEN = 1;
	cuif.src_addr = 3'b001;
end
if(cuif.instruction[31:26] == SW)begin
	cuif.ALUop = ALU_ADD;
	cuif.ALUSrc = 1;
	cuif.ExtOp = 1;
	cuif.MemWrite = 1;
	cuif.src_addr = 3'b001;
end
if(cuif.instruction[31:26] == HALT)begin
	cuif.halt = 1;
end

end
endmodule









