module ram(i_clk, i_addr, i_data, i_we, o_data);

	parameter DATA_WIDTH = 32;

	input                     i_clk, i_we;
	input   [31:0]  		  i_addr;
	input   [DATA_WIDTH-1:0]  i_data;
	output  [DATA_WIDTH-1:0]  o_data;

	reg [DATA_WIDTH-1:0] mem [0:128];

	assign o_data = (!i_we)?(mem[i_addr]):(32'b0);

	always @(posedge i_clk) begin
	  if (i_we)
	    mem[i_addr] <= i_data;
	end
  
endmodule