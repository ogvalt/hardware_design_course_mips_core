module rom ( i_addr, o_data );

	parameter MEM_WIDTH = 128;

	input 	[31:0] i_addr;
	output 	[31:0] o_data;

	reg [31:0] memory [0:MEM_WIDTH];

	assign o_data = memory[i_addr[31:2]];

endmodule
