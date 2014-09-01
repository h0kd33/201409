module mux_case (input i0, i1, i2, i3,  input [1:0] sel, output reg o);
 always@(i0 or i1 or i2 or i3 or sel) begin
  case (sel)
    2'b00   : o = i0;
    2'b01   : o = i1;
    2'b10   : o = i2;
    default : o = i3;
  endcase
 end
endmodule
 