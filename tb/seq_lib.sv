class mem_base_seq extends uvm_sequence#(mem_tx);
   `uvm_object_utils(mem_base_seq)
   function new(string name="");
      super.new(name);
   endfunction

  mem_tx tx_t;
   task pre_body();
      `uvm_info(" mem_base_seq","from prebody",UVM_NONE)
   endtask

   task post_body();
      `uvm_info(" mem_base_seq","from postbody",UVM_NONE)
   endtask


endclass

class mem_one_wr_one_rd_seq extends mem_base_seq;
   `uvm_object_utils(mem_one_wr_one_rd_seq)
   function new(string name="");
      super.new(name);
   endfunction

  mem_tx tx_t;
   task pre_body();
      super.pre_body();
      `uvm_info(" mem_one_wr_one_rd_seq","from prebody",UVM_NONE)
   endtask
   task body();
      `uvm_info(" mem_one_wr_one_rd_seq","from body",UVM_NONE)

      `uvm_do_with(req,{req.wr_rd==1;})
	   tx_t= new req;//shallow copy
      `uvm_do_with(req,{req.wr_rd==0;
	                     req.addr==tx_t.addr;})

   endtask
   task post_body();
      super.post_body();
      `uvm_info(" mem_one_wr_one_rd_seq","from postbody",UVM_NONE)
   endtask

endclass

class mem_full_wr_rd_seq extends mem_base_seq;
   `uvm_object_utils(mem_full_wr_rd_seq)
   function new(string name="");
      super.new(name);
   endfunction

//declare a addr local to this seq
rand bit[`ADDR_WIDTH-1:0] addr_DA[];

//1.constraints
//size of the DA
  constraint addr_DA_size{
    addr_DA.size==`DEPTH;
  }
  constraint addr_DA_unique{
    unique {addr_DA};
  }


  task pre_body();
      super.pre_body();
	  this.randomize();
      `uvm_info(" mem_full_wr_rd_seq",$sformatf("random unique addr=%p",this.addr_DA),UVM_NONE)
   endtask
   task body();
      `uvm_info(" mem_full_wr_rd_seq","from body wr_tx's",UVM_NONE)
	 for(int i=0;i<`DEPTH;i++)begin
        `uvm_do_with(req,{req.wr_rd==1; 
		             req.addr==addr_DA[i];})
	 end
      `uvm_info(" mem_full_wr_rd_seq","from body rd_tx's",UVM_NONE)

     for(int i=0;i<`DEPTH;i++)begin

	    `uvm_do_with(req,{req.wr_rd==0;
		             req.addr==addr_DA[i];
					 req.wdata==0;})
	 end

   endtask
   task post_body();
       super.post_body();
       `uvm_info(" mem_full_wr_rd_seq","from postbody",UVM_NONE)
   endtask

endclass
