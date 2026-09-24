class mem_cov extends uvm_subscriber#(mem_tx);
   //1.factory registration
   `uvm_component_utils(mem_cov)
   mem_tx tx;
    covergroup mem_cg;
       WR_RD_CP:
	       coverpoint tx.wr_rd;
	   ADDR_CP:
	       coverpoint tx.addr;
	   WR_RD_X_ADDR:
	        cross WR_RD_CP,ADDR_CP;
   endgroup

     //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
	 mem_cg=new();
   endfunction

   //4.common phases
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
    

   function void write(mem_tx t);
      $cast(tx,t);
	  mem_cg.sample();
   endfunction
endclass

