module poly_mod_diff_tb ();
parameter WIDTH = 12;
//////////not functional testbench/////////////////////////
reg [WIDTH-1:0] a,b,c,d;
reg fail;
wire [WIDTH:0] ox;

initial begin
  a = 0;
  b = 0;
  fail = 0;
  #100000 if (!fail) $display ("PASS");
  $stop();
end

poly_mod_diff #(WIDTH) x (.a(a),.b(b),.o(ox));
  defparam x .WIDTH = WIDTH;

always begin
  #50 a = $random;
  b = $random;
  //#50 a = 0;
  //b = 4095;
  c = (a-b); //WARNING CANNOT GET THIS TO WORK CORRECTLY
d = c%3329;
  #50 
  if (ox !== d) begin
    $display ("Mismatch at time %d",$time);
    $display (" ket qua la %d",d," nhung lai tinh ra la %d",ox);
    fail = 1;
  end
end
endmodule
