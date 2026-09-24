class mem_env extends uvm_env;
   //1.factory registration
   `uvm_component_utils(mem_env)
   //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction
   //3.subclass instantiation
   mem_agent mem_agent_h;
   mem_sbd mem_sbd_h;
   //4.common phases
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  mem_agent_h=mem_agent::type_id::create("mem_agent_h",this);
      mem_sbd_h=mem_sbd::type_id::create("mem_sbd_h",this);

   endfunction
   function void connect_phase(uvm_phase phase);
   //sbd and monitor is connected using tlm 1.0
   mem_agent_h.mem_mon_h.mon_ap_h.connect(mem_sbd_h.analysis_export);
   endfunction
endclass


