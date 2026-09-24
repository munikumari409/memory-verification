class mem_tx extends uvm_sequence_item;
   rand bit wr_rd;
   rand bit[`DATA_WIDTH-1:0] wdata;
        bit[`DATA_WIDTH-1:0] rdata;
   rand bit[`ADDR_WIDTH-1:0] addr;

   `uvm_object_utils_begin(mem_tx)
       `uvm_field_int(wr_rd,UVM_ALL_ON)
       `uvm_field_int(wdata,UVM_ALL_ON)
       `uvm_field_int(rdata,UVM_ALL_ON)
       `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_object_utils_end

   function new(string name="");
       super.new(name);
   endfunction
endclass
