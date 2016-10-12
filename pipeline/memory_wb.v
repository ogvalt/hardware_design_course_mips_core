module memory_writeback (i_clk, i_rst_n, i_WB,
                         i_data, i_Rw, o_data, o_Rw, o_WB);
  input wire         i_clk, i_rst_n;
  input wire  [31:0] i_data;
  input wire  [ 4:0] i_Rw;
  input wire         i_WB;
  
  output reg  [31:0] o_data;
  output reg  [ 4:0] o_Rw;
  output reg         o_WB;
  
  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_data <= 0;
      o_Rw   <= 0;
      o_WB   <= 0;
    end
    else begin
      o_data <= i_data;
      o_Rw   <= i_Rw;
      o_WB   <= i_WB;
    end
  end
endmodule 
