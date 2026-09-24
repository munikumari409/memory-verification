class mem_mon extends uvm_monitor;
   //1.factory registration
   `uvm_component_utils(mem_mon)
   //2.constructor
   function new(string name="",uvm_component parent);
     super.new(name,parent);
   endfunction
   mem_tx tx;
   virtual mem_intrf vif;
   //uvm analysis port tlm base class declaration
   uvm_analysis_port#(mem_tx) mon_ap_h;
   //4.common phases
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  mon_ap_h=new("new",this);
	   if(uvm_config_db#(virtual mem_intrf)::get(this,"","MEM_PIF",vif)==0)begin
	     `uvm_error("mem_mon","interface handle access is failed in mon class")
	  end

   endfunction
   task run_phase(uvm_phase phase);
      tx=mem_tx::type_id::create("tx");
      forever begin
	     @(vif.mon_cb);
		   if(vif.mon_cb.valid_i && vif.mon_cb.ready_o)begin
		      tx.wr_rd=vif.mon_cb.wr_rd_i;
			  tx.addr=vif.mon_cb.addr_i;
			  if(tx.wr_rd==1) tx.wdata=vif.mon_cb.wdata_i;
			  if(tx.wr_rd==0) tx.rdata=vif.mon_cb.rdata_o;
			  `uvm_info("mon collecting the tx's ",
			          $sformatf("CMD=%s ADDR=%h DATA=%h",tx.wr_rd ? "WR":"RD",tx.addr,tx.wr_rd ? tx.wdata : tx.rdata),UVM_NONE)
              mon_ap_h.write(tx);
		   end

	  end
   endtask
   endclass

