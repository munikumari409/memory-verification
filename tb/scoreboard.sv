class mem_sbd extends uvm_subscriber#(mem_tx);
    //1.factory registration
   `uvm_component_utils(mem_sbd)
   //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction
   mem_tx tx;
   bit [`DATA_WIDTH-1:0] mem_AA[*];
   int match_count;
   int miss_match_count;

   function void write(mem_tx t);
      $cast(tx,t);
	  if(t.wr_rd==1) mem_AA[t.addr]=t.wdata;
	  else begin
	     if(t.rdata==mem_AA[t.addr]) match_count++;
		 else begin
		   miss_match_count++;
		   `uvm_error("mem_sbd",$sformatf("addr=%h actual data=%h with expected data=%h",t.addr,t.rdata,mem_AA[t.addr]))
		 end
	  end
   endfunction
endclass
