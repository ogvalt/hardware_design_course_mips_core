module cop0 (	i_clk, 
				i_rst_n,
				i_arithmetic_overflow,
				i_unknown_command,
				i_unknown_func,
				i_external_interrupt,
				i_data,
				i_address,
				i_pc_to_epc_from_execute,
				i_pc_to_epc_from_decode,
                i_pc_to_epc_from_fetch,
				i_mtc0,
				i_eret,

				o_epc_to_pc,
				o_exeption,
				o_handler_address,
				o_data
				);

parameter 		STATUS_ADDR = 12, CAUSE_ADDR = 13, EPC_ADDR = 14;

input 					i_clk, 
						i_rst_n;
input 					i_arithmetic_overflow, 
						i_unknown_command, 
						i_unknown_func,
						i_external_interrupt;
input 					i_mtc0;	// 
input 					i_eret; 

input 		[31:0]		i_pc_to_epc_from_execute,
						i_pc_to_epc_from_decode,
                		i_pc_to_epc_from_fetch;
input 		[31:0]		i_data;
input 		[4:0]		i_address;

output 	reg	[31:0]		o_epc_to_pc;
output 	reg				o_exeption;
output 	reg [31:0]		o_handler_address;
output 	reg [31:0]		o_data;

reg	 		[31:0]		epc, cause, status;
reg 					interrupt_processing; 
reg  		[31:0]		pc_to_epc;
reg			[31:0] 		handler_address;

wire 					epc_we;	// write enable for epc

assign 		epc_we =(i_arithmetic_overflow & status[8] |
					(i_unknown_command | i_unknown_func) & status[9] |
					i_external_interrupt & status[10]) & status[0] & 
					!interrupt_processing;

/*
	For different type of exception we need 
	to use different sources of PC, for example:
	if arithmetic overflow occurs we need to write
	into epc value that is equal of PC value in execution stage.
	Arithmetic overflow - execution
	Unknown command / function - decode
	External interrup - fetch
*/

always @(*) begin : pc_source 
	case(1'b1)
		i_external_interrupt:
			pc_to_epc = i_pc_to_epc_from_fetch;
		i_unknown_func | i_unknown_command:
			pc_to_epc = i_pc_to_epc_from_decode;
		i_arithmetic_overflow:
			pc_to_epc = i_pc_to_epc_from_execute;
		default:
			pc_to_epc = 0;
	endcase 
end

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		epc <= 0;
		handler_address <= 32'h5;
	end else begin
		if (epc_we) begin
			epc <= pc_to_epc;	
		end	
	end
end

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		cause	<= 0;
		status	<= 32'b0001_0000_0001;
	end else begin
		if(i_mtc0 & i_address == STATUS_ADDR) 
			status <= i_data;
		if(i_mtc0 & i_address == CAUSE_ADDR) 
			cause  	<= i_data;
		else begin
			if(epc_we)
				cause 	<= { 29'b0, i_arithmetic_overflow, 
				i_unknown_func | i_unknown_command, i_external_interrupt };
		end
	end
end

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		interrupt_processing <= 0;
	end else begin
		if(i_eret)
			interrupt_processing <= 1'b0;
		if(epc_we)
			interrupt_processing <= 1'b1;
	end
end

always @(*) begin 
	case(i_address)
		STATUS_ADDR:	o_data 	= status;
		CAUSE_ADDR: 	o_data	= cause;
		EPC_ADDR: 		o_data	= epc;
		default:		o_data 	= 0;
	endcase // i_address

	o_epc_to_pc 		= epc;
	o_exeption 			= epc_we;
	o_handler_address 	= handler_address;
end

endmodule