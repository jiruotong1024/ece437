/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  // with caches
  assign ccif.iwait = (ccif.ramstate != ACCESS) ? 1 : ((ccif.iREN == 1) && (ccif.dREN == 0) && (ccif.dWEN == 0)) ? 0 : 1;
  assign ccif.dwait = (ccif.ramstate != ACCESS) ? 1 : ((ccif.dREN == 1) || (ccif.dWEN == 1)) ? 0 : 1;
  always_comb begin
 // ccif.iwait = 0;
  //ccif.dwait = 0;
  ccif.iload = 0;
  ccif.dload = 0;
  ccif.ramaddr = 0;
  ccif.ramWEN = 0;
  ccif.ramREN = 0;

  if (ccif.iREN == 1)begin
    ccif.iload = ccif.ramload;
    end
  if (ccif.dREN == 1 || ccif.dWEN == 1)begin
    ccif.dload = ccif.ramload;
    end
  // with ram
  ccif.ramstore = ccif.dstore;
  if (ccif.iREN == 1)begin
    ccif.ramaddr = ccif.iaddr;
    end
  if(ccif.dREN == 1 || ccif.dWEN == 1)begin
    ccif.ramaddr = ccif.daddr;
    end
    if(ccif.dWEN == 1 && ccif.dREN == 1)begin
  ccif.ramREN = 0;
  ccif.ramWEN = 1;
  end
  if (ccif.dWEN == 1)begin
  ccif.ramWEN = 1;
  ccif.ramREN = 0;
  end
  if(ccif.dWEN == 1 && ccif.iREN == 1)begin
  ccif.ramREN = 0;
  ccif.ramWEN = 1;
  end
  if((ccif.iREN == 1 || ccif.dREN == 1) && ccif.dWEN != 1)begin
  ccif.ramREN = 1;
  ccif.ramWEN = 0;
  end
end
endmodule
