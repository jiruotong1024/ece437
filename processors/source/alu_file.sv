`include "alu_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module alu_file
(
	input logic CLK,
	alu_file_if afi
	);

logic [32:0] final_answer;

assign afi.zero = (final_answer == 0)? 1 : 0;
assign afi.negative = (final_answer[31] == 1)? 1:0;
assign afi.output_port = final_answer[31:0];

always_comb  begin
		final_answer = 32'b00000000000000000000000000000000;
		afi.overflow = 0;
		//shift left
		if (afi.ALUOP == ALU_SLL) begin
			final_answer = afi.port_a << afi.port_b;
			afi.overflow = 0;
		end
		//shift right
		if (afi.ALUOP == 4'b0001) begin
			final_answer = afi.port_a >> afi.port_b;
			afi.overflow = 0;
		end
		//add
		if (afi.ALUOP == 4'b0010) begin
			final_answer = $signed(afi.port_a) + $signed(afi.port_b);
			afi.overflow = (final_answer[32:31] == 2'b10 | final_answer[32:31] == 2'b01)? 1:0;
		end
		//sub
		if (afi.ALUOP == 4'b0011) begin
			final_answer = $signed(afi.port_a)-$signed(afi.port_b);
			afi.overflow = (afi.port_a[31] ^ afi.port_b[31]) & (afi.port_a[31] ^ final_answer[31]);
		end
		//and
		if (afi.ALUOP == 4'b0100) begin
			final_answer = afi.port_a & afi.port_b;
			afi.overflow = 0;
		end
		//or
		if (afi.ALUOP == 4'b0101) begin
			final_answer = afi.port_a | afi.port_b;
			afi.overflow = 0;
		end
		//xor
		if (afi.ALUOP == 4'b0110) begin
			final_answer = afi.port_a ^ afi.port_b;
			afi.overflow = 0;
		end
		//xnor
		if (afi.ALUOP == 4'b0111) begin
			final_answer = ~(afi.port_a | afi.port_b);
			afi.overflow = 0;
		end
		//set less than
		if (afi.ALUOP == 4'b1010) begin
			final_answer = ($signed(afi.port_a) < $signed(afi.port_b))? 1 : 0;
			afi.overflow = 0;
		end
		//set less than unsigned
		if (afi.ALUOP == 4'b1011) begin
			final_answer = (afi.port_a < afi.port_b)? 1 : 0;
			afi.overflow = 0;
		end
    end
endmodule
