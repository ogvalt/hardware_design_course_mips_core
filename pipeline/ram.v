module ram(i_clk, i_addr, i_data, i_we, o_data);

	parameter MEM_WIDTH = 128; 

	input			i_clk, i_we;
	input   [31:0]  i_addr;
	input   [31:0]  i_data;
	output  [31:0]  o_data;

	reg [31:0] mem [0:MEM_WIDTH];

	assign o_data = (!i_we) ? mem[i_addr] : 32'b0;

	always @(posedge i_clk) begin
	  if (i_we)
	    mem[i_addr] <= i_data;
	end
  
endmodule