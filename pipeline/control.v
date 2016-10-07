module control(i_instrCode,
               i_bubble, 
               o_regDst,
               o_jump, 
               o_beq,
			         o_bne,
               o_memToReg,
               o_aluOp,
               o_memWrite,
               o_memRead,
               o_aluSrc_op2,
               o_regWrite,
               o_extOp,
               o_unknown_command
               );

localparam OP_RTYPE = 6'h0, OP_ADDI = 6'h8, OP_ADDIU = 6'h9;
localparam OP_LUI = 6'b001111, OP_ORI = 6'b001101, OP_XORI = 6'b001110;
localparam OP_ANDI = 6'b001100;
localparam OP_LW = 6'h23, OP_SW = 6'h2B;
localparam OP_BEQ = 6'h4, OP_J = 6'h2, OP_BNE = 6'h5;  
localparam OP_COP0 = 6'b010000;  
  
input         [5:0]  i_instrCode; 
input                i_bubble; 
output    reg        o_regDst;
output    reg        o_jump; 
output    reg        o_beq;
output	  reg        o_bne;
output    reg        o_memToReg;
output    reg [5:0]  o_aluOp;
output    reg        o_memWrite;
output    reg        o_memRead;
output    reg        o_aluSrc_op2;
output    reg        o_regWrite;
output    reg        o_extOp;
output    reg        o_unknown_command;

always @(i_instrCode, i_bubble) begin
    o_regDst        = 1'b0;
    o_regWrite      = 1'b0;
    o_aluSrc_op2    = 1'b0;
    o_beq           = 1'b0;
		o_bne	          = 1'b0;
    o_jump	        = 1'b0;
    o_memWrite      = 1'b0;
    o_memToReg      = 1'b0;
    o_aluOp         = i_instrCode;
    o_extOp         = 1'b0;
    o_memRead       = 1'b0;
    o_unknown_command = 1'b0;

    case(i_instrCode)
      OP_RTYPE: 
        begin
        o_regDst   = 1'b1;
        if (i_bubble) 
          begin
		        o_regWrite = 1'b1;
    		    end
      		end
      OP_ADDI:
      	begin
  		  if (i_bubble) 
          begin
		        o_regWrite     = 1'b1;
      		  o_aluSrc_op2   = 1'b1;
      		  o_extOp        = 1'b1;
    		  end
      	end
  		OP_ADDIU:
  		  begin
      	if (i_bubble) 
          begin
		        o_regWrite    = 1'b1;
      		  o_aluSrc_op2  = 1'b1;
      		  o_extOp       = 1'b1;
    		  end
      	end
      OP_LUI:
        begin
        if (i_bubble)
          begin
            o_regWrite    = 1'b1;
            o_aluSrc_op2  = 1'b1;
          end
        end
      OP_ORI:
        begin
        if (i_bubble)
          begin
            o_regWrite    = 1'b1;
            o_aluSrc_op2  = 1'b1;
          end
        end
      OP_XORI:
        begin
        if (i_bubble)
          begin
            o_regWrite    = 1'b1;
            o_aluSrc_op2  = 1'b1;
          end
        end
      OP_ANDI:
        begin
        if (i_bubble)
          begin
            o_regWrite    = 1'b1;
            o_aluSrc_op2  = 1'b1;
          end
        end
  	  OP_LW:
	      begin
      	if (i_bubble) 
          begin
      		  o_regWrite    = 1'b1;
      		  o_aluSrc_op2  = 1'b1;
      		  o_memToReg    = 1'b1;
      		  o_extOp       = 1'b1;
      		  o_memRead     = 1'b1;
    		  end
      	end
  	  OP_SW:
	      begin
      	if (i_bubble) 
          begin
      		  o_aluSrc_op2   = 1'b1;
      		  o_memWrite     = 1'b1;
      		  o_extOp        = 1'b1;
      		end
      	end
  	  OP_J:
	     	begin
      	if (i_bubble) 
          begin
      		  o_jump	    = 1'b1;
    		  end
      	end
  	  OP_BEQ:
      	begin
      	if (i_bubble) 
          begin     		  
      		  o_beq      = 1'b1;     		
      		end
      	end
      OP_BNE:
      	begin
      	if (i_bubble) 
          begin
			      o_bne	     = 1'b1;
      		end
      	end
      OP_COP0:
        begin
          if (i_bubble) 
            o_regWrite    = 1'b1;
        end
      default:
        begin
          o_unknown_command = 1'b1;
        end
  	endcase
end	
endmodule

        