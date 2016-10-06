module fetch_decode(i_clk, i_rst_n, i_rst_nextPC, i_we, i_instr, i_pc, o_instr, o_pc);
  
  input wire         i_clk, i_we, i_rst_n;
  input wire         i_rst_nextPC;
  input wire  [31:0] i_instr;
  input wire  [31:0] i_pc;
  
  output reg  [31:0] o_instr;
  output reg  [31:0] o_pc;
  
  always @(posedge i_clk or i_rst_n) begin
    if(!i_rst_n|i_rst_nextPC) begin
      o_instr <= 32'bx;
      o_pc    <= 0;
    end
    else begin
      if (i_we) begin
         o_instr <= i_instr;
         o_pc    <= i_pc;
       end
    end   
  end
endmodule