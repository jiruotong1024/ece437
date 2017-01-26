`include "control_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
`timescale 1ns/1ns

module control_unit_tb;
parameter PERIOD = 20;
logic CLK = 1, nRST;

always #(PERIOD/2) CLK++;

control_unit_if cuif();

test PROG (CLK,nRST,cuif);
control_unit DUT(cuif);

endmodule

program test(
	input logic CLK,
	output logic nRST,
	control_unit_if cuif
	);

initial begin
#5;
cuif.instruction = 32'h00340100;
@(negedge CLK);
cuif.instruction = 32'h00340200;
@(negedge CLK);
cuif.instruction = 32'h003C07DE;
@(negedge CLK);
cuif.instruction = 32'h008C2300;
@(negedge CLK);
cuif.instruction = 32'h00AC4300;
@(negedge CLK);
cuif.instruction = 32'h008C2400;

$finish;
end

endprogram






