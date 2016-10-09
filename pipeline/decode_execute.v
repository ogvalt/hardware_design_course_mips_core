module decode_execute(i_clk, i_rst_n, i_mtc0,
                      i_imm, i_busA, i_busB, i_Rw, 
                      i_EX, i_M, i_WB, i_pc,
                      i_exception, 
                      o_imm, o_busA, o_busB, o_Rw,
                      o_EX, o_M, o_WB, o_pc);

  input          i_clk, i_rst_n;                    
                
  input   [25:0] i_imm;
  input   [31:0] i_busA, i_busB;
  input   [ 4:0] i_Rw;
  
  input   [ 8:0] i_EX;
  input   [ 2:0] i_M;
  input          i_WB;
  input   [31:0] i_pc;
  input          i_exception;
  input          i_mtc0;

  output reg  [25:0] o_imm;
  output reg  [31:0] o_busA;
  output reg  [31:0] o_busB;
  output reg  [ 4:0] o_Rw;
  
  output reg  [ 8:0] o_EX;
  output reg  [ 2:0] o_M;
  output reg         o_WB;
  output reg  [31:0] o_pc;
  
  always @(posedge i_clk or i_rst_n) begin
    if(!i_rst_n | i_exception | i_mtc0) begin
      o_imm  <= 0;
      o_busA <= 0;
      o_busB <= 0;
      o_Rw   <= 0;
      o_EX   <= 0;
      o_M    <= 0;
      o_WB   <= 0;
      end
    else begin
      o_imm  <= i_imm;
      o_busA <= i_busA;
      o_busB <= i_busB;
      o_Rw   <= i_Rw;
      o_EX   <= i_EX;
      o_M    <= i_M;
      o_WB   <= i_WB;
      o_pc   <= i_pc;
      end
  
  end
endmodule
    