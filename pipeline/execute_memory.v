module execute_memory (i_clk, i_rst_n, i_alures, i_busB,
                       i_Rw, i_M, i_WB,
                       o_alures, o_busB, o_Rw,
                       o_M, o_WB);
  
  input wire         i_clk, i_rst_n;
  input wire  [31:0] i_alures;
  input wire  [31:0] i_busB;
  input wire  [ 4:0] i_Rw;
  input wire  [ 1:0] i_M;
  input wire         i_WB;
  
  output reg  [31:0] o_alures;
  output reg  [31:0] o_busB;
  output reg  [ 4:0] o_Rw;
  output reg  [ 1:0] o_M;
  output reg         o_WB;
  
  always @(posedge i_clk or i_rst_n) begin
    if(!i_rst_n) begin
      o_alures <= 0;
      o_busB   <= 0;
      o_Rw     <= 0;
      o_M      <= 0;
      o_WB     <= 0;
    end
    else begin
      o_alures <= i_alures;
      o_busB   <= i_busB;
      o_Rw     <= i_Rw;
      o_M      <= i_M;
      o_WB     <= i_WB;      
    end
  end 
endmodule