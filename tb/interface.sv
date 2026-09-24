interface mem_intrf(input logic clk_i,rst_i);
  logic wr_rd_i, valid_i;
  logic [`DATA_WIDTH-1:0] wdata_i;
  logic [`DATA_WIDTH-1:0] rdata_o;
  logic[`ADDR_WIDTH-1:0] addr_i;
  logic ready_o;

  clocking drv_cb@(posedge clk_i);
     default input #0 output #1;
	 output wr_rd_i;
	 output valid_i;
	 output wdata_i;
	 output addr_i;
	 input rdata_o;
	 input ready_o;
  endclocking

  clocking mon_cb@(posedge clk_i);
     default input #0;
	 input wr_rd_i;
	 input valid_i;
	 input wdata_i;
	 input addr_i;
	 input rdata_o;
	 input ready_o;
  endclocking

endinterface
