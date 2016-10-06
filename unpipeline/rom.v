module rom ( i_addr, o_data );

	parameter DATA_WIDTH = 32; 
	parameter MEM_WIDTH = 128;

	input [31:0] i_addr;
	output [DATA_WIDTH-1:0] o_data;

	reg [DATA_WIDTH-1:0] memory [0:MEM_WIDTH];

	assign o_data = memory[i_addr];

endmodule
