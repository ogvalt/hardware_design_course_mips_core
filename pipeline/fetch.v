module fetch(i_clk, i_rst_n, i_execute, i_pcsrc, 
             i_pcWrite, o_fetch_pc, o_fetch_instr);
  
  input i_clk;
  input i_rst_n; //active zero level
  input i_pcsrc; //mux control
  input i_pcWrite;
  
  input  [31:0] i_execute; // out of nextPC
  
  output reg [31:0] o_fetch_pc; //input for nextPC and PC
  output reg [31:0] o_fetch_instr; //instraction fetch
  
  wire [31:0] i_pc; //input previously addr
  wire [31:0] fetch_pc;
  wire [31:0] fetch_instr;
  
  pc PC(i_clk, i_rst_n, i_pc, i_pcWrite, fetch_pc); 
  mux2in1 PCSOURCE (fetch_pc, i_execute, i_pcsrc, i_pc);// mux source of addr of pc
  rom ROM(fetch_pc, fetch_instr);

  always @(*) begin
     o_fetch_pc    = fetch_pc;
     o_fetch_instr = fetch_instr;
  end

endmodule
