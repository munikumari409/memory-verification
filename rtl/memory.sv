module memory(clk_i, rst_i, wr_rd_i, addr_i, wdata_i, valid_i, rdata_o, ready_o);

//ports
input clk_i,rst_i,wr_rd_i, valid_i;
input [`DATA_WIDTH-1:0] wdata_i;
output reg [`DATA_WIDTH-1:0] rdata_o;
input [`ADDR_WIDTH-1:0] addr_i;
output reg ready_o;

//memory
reg [`DATA_WIDTH-1:0] mem [`DEPTH-1:0];

integer i;

always@(posedge clk_i) begin
	if(rst_i == 1) begin//active high
		rdata_o = 0;
		ready_o = 0;
		for(i = 0; i<`DEPTH; i=i+1) begin
			mem[i] = 0;	
		end
	end
	else begin
		//check for handshake
		if(valid_i == 1) begin
			ready_o = 1;
			//wr
			if(wr_rd_i == 1) begin
				mem[addr_i] = wdata_i;
			end
			//rd
			else begin
				rdata_o = mem[addr_i];
			end
		end
		else begin
			ready_o = 0;
		end
	end
end
endmodule
