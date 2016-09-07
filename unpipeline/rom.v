module rom ( i_addr, o_data );

	parameter DATA_WIDTH=32; 
	parameter ADDR_WIDTH=128;

	input [(ADDR_WIDTH-1):0] i_addr;
	output [(DATA_WIDTH-1):0] o_data;

	reg [DATA_WIDTH-1:0] memory [0:ADDR_WIDTH-1];

	assign o_data = memory[i_addr];

endmodule
