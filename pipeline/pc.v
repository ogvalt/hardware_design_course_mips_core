module pc(i_clk, i_rst_n, i_pc,i_pcWrite, o_pc);

input               i_clk, i_rst_n, i_pcWrite;
input       [31:0]  i_pc;
output  reg [31:0]  o_pc;

always @(posedge i_clk or i_rst_n) begin
      if(i_rst_n)
       begin 
        if(i_pcWrite)
          o_pc[31:0] <= i_pc[31:0] + 1'b1;
        else
          o_pc[31:0] <= i_pc[31:0];
        end        
      else
        o_pc <= 32'b0;
      end
endmodule
