`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"
`timescale 1ns/1ns

module memory_control_tb;
parameter PERIOD = 20;
logic CLK = 1, nRST;

always #(PERIOD/2) CLK++;

cache_control_if ccif();
cpu_ram_if crif();

  assign ccif.ramload = crif.ramload;
  assign ccif.ramstate = crif.ramstate;
  assign crif.ramstore = ccif.ramstore;
  assign crif.ramaddr = ccif.ramaddr;
  assign crif.ramWEN = ccif.ramWEN;
  assign crif.ramREN = ccif.ramREN;

test PROG(CLK,nRST,ccif);

memory_control DUT(CLK,nRST,ccif);
ram DUTT(CLK,nRST,crif);

endmodule
program test(
	input logic CLK,
	output logic nRST,
	cache_control_if ccif
	);

task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    //ccif.dstore = 0;
    ccif.daddr = 0;
    ccif.dWEN = 0;
    ccif.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      ccif.daddr = i << 2;
      ccif.dREN = 1;
      repeat (4) @(posedge CLK);
      if (ccif.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,ccif.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),ccif.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //ccif.dstore = 0;
      ccif.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask


	initial begin
	#5
	nRST = 0;
	#20;
	#20;
	nRST = 1;
	ccif.iREN = 0;
	ccif.dREN = 0;
	ccif.dWEN = 0;
	ccif.iaddr = 0;
	ccif.daddr = 0;

	#20;
	$display("iwait test1");
	@(negedge CLK)
	ccif.iREN = 1'b1;
	ccif.dWEN = 1'b0;
	ccif.dREN = 1'b0;
	ccif.iaddr = 32'b00000000000000000000000000000011;
	#20;


	#20;
	#20;
	@(negedge CLK)
	ccif.iREN = 1'b0;
	ccif.dREN = 1'b1;
	ccif.daddr = 32'b00000000000000000000000000000000;
	ccif.dWEN = 1'b0;
	#20;
	#20;
	#20;

	// first write
	@(negedge CLK)
	ccif.iREN = 1'b0;
	ccif.dREN = 1'b0;
	ccif.dWEN = 1'b1;
	ccif.dstore = 32'b00000000000000000000011000000111;
	ccif.daddr = 32'b00000000000000000000000000000000;
	#20;
	ccif.dWEN = 1'b0;
	#20;
	#20;
	#20;
	#20;
	#100;
	ccif.iREN = 1'b0;
	ccif.dREN = 1'b0;
	ccif.dWEN = 1'b1;
	ccif.dstore = 32'h1234;
	ccif.daddr = 32'b00000000000000000000000000000100;
	#100;
	ccif.dWEN = 1'b0;
	#50;
	#20;
	@(negedge CLK)
	ccif.iREN = 1'b0;
	ccif.dREN = 1'b1;
	ccif.dWEN = 1'b0;
	ccif.daddr = 32'b00000000000000000000000000000000;
	#20;
	ccif.dREN = 1'b0;
	#20;
	#20;
	$display("test2");
	ccif.iREN = 1'b1;
	ccif.dREN = 1'b0;
	ccif.dWEN = 1'b1;
	ccif.iaddr = 32'b00000000000000000000000000000001;
	ccif.daddr = 32'b00000000000000000000000000001000;
	ccif.dstore = 32'h00ff;
	#100;
	ccif.iREN = 1'b0;
	dump_memory();
$finish;
end
 




  endprogram