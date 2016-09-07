module pc(i_clk, i_rst_n, i_pc, o_pc);

input               i_clk, i_rst_n;
input       [31:0]  i_pc;
output  reg [31:0]  o_pc;

always @(posedge i_clk or i_rst_n) begin
      if(i_rst_n) 
        o_pc[31:0] <= i_pc[31:0] + 1;        
      else
        o_pc <= 32'b0;
      end
endmodule

module pc_testbench();
  reg i_clk;
  reg i_rst_n;
  wire [31:0] pc;  
  
  pc PC(i_clk,i_rst_n,pc,pc);
  
  initial begin
    i_clk <= 1'b0;
    forever #1 i_clk<=~i_clk;
  end
  initial begin
    i_rst_n <= 1'b1;
    #3;
    i_rst_n <= 1'b0;
  end
endmodule