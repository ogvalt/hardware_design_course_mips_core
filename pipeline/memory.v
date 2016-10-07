module memory (i_clk, i_rst_n, i_alu, i_data, i_memWrite, i_memToReg, o_data);
  
  input wire         i_clk;
  input wire         i_rst_n;
  
  input wire  [31:0] i_alu;
  input wire  [31:0] i_data;
  
  input wire         i_memWrite, i_memToReg;
  
  output wire [31:0] o_data;
  
  wire        [31:0] data;
   
  ram RAM(i_clk, i_alu, i_data, i_memWrite, data);                
  mux2in1 MEMTOREG(i_alu, data, i_memToReg, o_data);
 
endmodule
