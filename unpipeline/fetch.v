module fetch(i_clk, i_rst_n, i_execute, i_pcsrc, o_fetch_pc, o_fetch_instr);
  
  input wire i_clk;
  input wire i_rst_n; //active zero level
  input wire i_pcsrc; //mux control
  
  input wire  [31:0] i_execute; // out of nextPC
  
  output wire [31:0] o_fetch_pc; //input for nextPC and PC
  output wire [31:0] o_fetch_instr; //instraction fetch
  
  wire [31:0] i_pc; //input previously addr
  
  pc PC(i_clk, i_rst_n, i_pc, o_fetch_pc); 
  mux2in1 PCSOURCE (o_fetch_pc, i_execute, i_pcsrc, i_pc);// mux source of addr of pc
  rom ROM(o_fetch_pc, o_fetch_instr);
  

endmodule
