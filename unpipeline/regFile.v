module regFile(i_clk, 
               i_rst_n,
               i_raddr1, 
               i_raddr2, 
               i_waddr, 
               i_wdata, 
               i_we,
               o_rdata1,
               o_rdata2 
               );
               
input           i_clk, i_we, i_rst_n;
input   [4:0]   i_raddr1, i_raddr2, i_waddr;
input   [31:0]  i_wdata;           
output  [31:0]  o_rdata1, o_rdata2;

reg [31:0] memory [0:31];

assign o_rdata1 = memory[i_raddr1];
assign o_rdata2 = memory[i_raddr2]; 

always @ (posedge i_clk or i_rst_n) begin
  if(i_rst_n) begin
    if(i_we)
      memory[i_waddr] <= i_wdata;  
    memory[0] <= 32'b0;
  end
  else 
    memory[0] <= 32'b0;
end

endmodule
module regFile_testbench();
  reg         i_clk;
  reg  [31:0] instr;
  reg  [31:0] i_wdata;
  reg         i_we;
  wire [31:0] o_rdata1;
  wire [31:0] o_rdata2;
  
  regFile rFIle(i_clk, instr[25:21], instr[20:16], instr[15:11], i_wdata, i_we, o_rdata1, o_rdata2);
  
  initial begin
    i_clk <= 1'b0;
    #1;
    forever #1 i_clk<=~i_clk;
    
  end
  initial begin
    i_we  <= 1'b1;
    instr <= 32'b000000_00000_00000_00001_00000_000000;
    i_wdata <= 4'd4;
    #5;
    i_wdata <= 4'd5;
    instr <= 32'b000000_00000_00000_00010_00000_000000;     
    #2;
    i_we  <= 1'd0;
    #2;
    instr <= 32'b000000_00001_00010_00000_00000_000000;
  end
endmodule
    
  