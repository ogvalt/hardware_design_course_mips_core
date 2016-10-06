module hazard ( i_idEx, i_exMem,i_memWb, i_memRead, i_idExregWrite, i_exMemregWrite, 
                i_memWbregWrite,
               i_Rs, i_Rt, o_forwardA, o_forwardB,
               o_bubble, o_pcwrite, o_idIfwrite);
  
  input       [4:0] i_idEx;
  input       [4:0] i_exMem;
  input       [4:0] i_memWb;
  input             i_memRead;
  input             i_idExregWrite;
  input             i_exMemregWrite;
  input             i_memWbregWrite;
  input       [4:0] i_Rs;
  input       [4:0] i_Rt;
  
  output reg  [1:0] o_forwardA;
  output reg  [1:0] o_forwardB;
  output reg        o_bubble;
  output reg        o_pcwrite;
  output reg        o_idIfwrite;
  
  /*assign o_forwardA = ((i_Rs==i_idEx)&(i_idEx!=0)&i_idExregWrite)?(2'b01):
                      (((i_Rs==i_exMem)&(i_exMem!=0)&i_exMemregWrite)?(2'b10):
                      (((i_Rs==i_memWb)&(i_memWb!=0)&i_memWbregWrite))?(2'b11):(2'b00));*/
  
  always @(*)
    begin 
      // forwarding
      if((i_Rs==i_idEx)&(i_idEx!=0)&i_idExregWrite)
        o_forwardA <= 2'b01;
      else if((i_Rs==i_exMem)&(i_exMem!=0)&i_exMemregWrite)
        o_forwardA <= 2'b10;
      else if((i_Rs==i_memWb)&(i_memWb!=0)&i_memWbregWrite)
        o_forwardA <= 2'b11;
      else 
        o_forwardA <= 2'b00;
        
      if((i_Rt==i_idEx)&(i_idEx!=0)&i_idExregWrite)
        o_forwardB <= 2'b01;
      else if((i_Rt==i_exMem)&(i_exMem!=0)&i_exMemregWrite)
        o_forwardB <= 2'b10;
      else if((i_Rt==i_memWb)&(i_memWb!=0)&i_memWbregWrite)
        o_forwardB <= 2'b11;
      else
        o_forwardB <= 2'b00;
        
      //pipeline stall
      if ((i_memRead==1)&(i_idEx!=0)&((i_idEx==i_Rs)|(i_idEx==i_Rt)))
        begin
          o_bubble    <= 1'b0;
          o_pcwrite   <= 1'b0;
          o_idIfwrite <= 1'b0;
        end
      else
        begin
          o_bubble    <= 1'b1;
          o_pcwrite   <= 1'b1;
          o_idIfwrite <= 1'b1;
        end
    end

endmodule
