`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file
(
	input logic CLK, nRST,
	register_file_if new_reg
	);

word_t [31:0] new_register;

always_ff @ (posedge CLK, negedge nRST) begin
	if (nRST == 0) begin
	new_register[31:0] <= 0;
	end
	else begin
		if (new_reg.WEN) begin
			if(new_reg.wsel != 0) begin
			new_register[new_reg.wsel] <= new_reg.wdat;
			end
		end
	end
end

assign new_reg.rdat1 = new_reg.rsel1 ? new_register[new_reg.rsel1] : 0;
assign new_reg.rdat2 = new_reg.rsel2 ? new_register[new_reg.rsel2] : 0;

endmodule
