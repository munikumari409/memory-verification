`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "common.sv"
`include "memory.v"
`include "mem_intrf.sv"
`include "mem_tx.sv"
`include "mem_cov.sv"
`include "mem_dvr.sv"
`include "mem_mon.sv"
`include "mem_sqr.sv"
`include "mem_agent.sv"
`include "mem_sbd.sv"
`include "mem_env.sv"
`include "seq_lib.sv"
`include "test_lib.sv"
module top;
   //1.clk and rst declaration
   bit clk,rst;
   //2.clk and rst generation
   always #5 clk=~clk;
   
  //3.interface instantiation
  mem_intrf pif(clk,rst);
  //4.dut instantiation
  memory mem_dut(.clk_i(pif.clk_i),
                 .rst_i(pif.rst_i),
				 .wr_rd_i(pif.wr_rd_i),
				 .addr_i(pif.addr_i),
				 .wdata_i(pif.wdata_i),
				 .valid_i(pif.valid_i),
				 .rdata_o(pif.rdata_o),
				 .ready_o(pif.ready_o)
				 );
  //5.assertion instantiation

  //6.pass the interface handle to dvr and mon using configdb.
  initial begin
      uvm_config_db#(virtual mem_intrf)::set(null,"*.mem_agent_h.*","MEM_PIF",pif);
  end
                
   //applying and releasing rst
   initial begin
      rst=1;
	  repeat(2)@(posedge clk);
		 pif.wr_rd_i=0;
		 pif.wdata_i=0;
		 pif.addr_i=0;
         pif.valid_i=0;
		 rst=0;
   end
   //7.calling run test
   initial begin
      run_test("mem_full_wr_rd_test");
   end
endmodule
