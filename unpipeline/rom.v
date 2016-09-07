module rom
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=128)
(
	input [(ADDR_WIDTH-1):0] i_addr,
	output [(DATA_WIDTH-1):0] o_data
);

reg [DATA_WIDTH-1:0] memory [0:ADDR_WIDTH-1];


assign o_data = memory[i_addr];

endmodule

module testbench_rom();
  
  localparam DATA_WIDTH = 32, ADDR_WIDTH = 8;
  
  reg [ADDR_WIDTH-1:0] i_addr;
  wire [DATA_WIDTH-1:0] o_data;
  
  rom #(.DATA_WIDTH (DATA_WIDTH),.ADDR_WIDTH (ADDR_WIDTH)) r(i_addr, o_data);
  initial $readmemh("G:/CourseWorkMIPS/backup1/rom_init.dat", r.memory);
  
  
  initial i_addr = {ADDR_WIDTH{1'b0}};
  
endmodule
