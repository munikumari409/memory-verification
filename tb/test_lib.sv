class mem_base_test extends uvm_test;
   `uvm_component_utils(mem_base_test)

   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction

   mem_env mem_env_h;

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  mem_env_h=mem_env::type_id::create("mem_env_h",this);
   endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
       uvm_top.print_topology();
   endfunction

endclass
class mem_one_wr_one_rd_test extends mem_base_test;
   //1.factory registration
   `uvm_component_utils(mem_one_wr_one_rd_test)
   //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction
  
   task run_phase(uvm_phase phase);
      //1.instantiate the seq
	  mem_one_wr_one_rd_seq seq_h;
	  //2.allocate memory
	  seq_h=mem_one_wr_one_rd_seq::type_id::create("seq_h",this);
	  //3.raise objection
	  phase.raise_objection(this);
	  //4.mapping seq to sqr
	  seq_h.start(mem_env_h.mem_agent_h.mem_sqr_h);
	  //5.set drqin time and drop the objection
	  phase.phase_done.set_drain_time(this,100);
	  phase.drop_objection(this);
   endtask

   function void check_phase(uvm_phase phase);
      `uvm_info("mem_one_wr_one_rd_test","from check phase",UVM_NONE)
   endfunction
   
   function void extract_phase(uvm_phase phase);
      `uvm_info("mem_one_wr_one_rd_test","from extract phase",UVM_NONE)
   endfunction


endclass

class mem_full_wr_rd_test extends mem_base_test;
   //1.factory registration
   `uvm_component_utils(mem_full_wr_rd_test)
   //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction
   int match_count;
   int miss_match_count;
   int test_sts;
  
   task run_phase(uvm_phase phase);
	  mem_full_wr_rd_seq full_seq_h;
	  full_seq_h=mem_full_wr_rd_seq::type_id::create("full_seq_h",this);
	  phase.raise_objection(this);
	  full_seq_h.start(mem_env_h.mem_agent_h.mem_sqr_h);
	  phase.phase_done.set_drain_time(this,200);
	  phase.drop_objection(this);
   endtask

  function void extract_phase(uvm_phase phase);
      `uvm_info("mem_full_wr_rd_test","from extract phase",UVM_NONE)
	  match_count=mem_env_h.mem_sbd_h.match_count;
      miss_match_count=mem_env_h.mem_sbd_h.miss_match_count;
   endfunction

   function void check_phase(uvm_phase phase);
      `uvm_info("mem_full_wr_rd_test","from check phase",UVM_NONE)
	    if(`DEPTH==match_count&&miss_match_count==0)begin
	      test_sts=1;
	    end
	    else test_sts=0;
    endfunction

   function void report_phase(uvm_phase phase);
      if(test_sts==1)begin
	     `uvm_info("mem_full_wr_rd_test","############ TEST PASSED ##########",UVM_NONE)
	  end
	  else begin
	     `uvm_error("mem_full_wr_rd_test",$sformatf("match_count=%h miss_match_count=%h",match_count,miss_match_count))
		 `uvm_info("mem_full_wr_rd_test","############ TEST FAILED ##########",UVM_NONE)

	  end
   endfunction


endclass
