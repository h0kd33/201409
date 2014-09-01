module mux_if1_no_default(input i0, i1, i2, i3,  input [1:0] sel, output reg o);
 always@(i0 or i1 or i2 or i3 or sel) begin
  if (sel == 2'b00)
     o = i0;
  else if (sel == 2'b01)
     o = i1;
  else if (sel == 2'b10)
     o = i2;
  else if (sel == 2'b11)
     o = i3;
 end
endmodule
