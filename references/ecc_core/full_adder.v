////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : full_adder.v
// Description  : .
//
// Author       : hungnt@HW-NTHUNG
// Created On   : Tue Nov 06 11:36:51 2018
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

module full_adder
    (
     a,
     b,
     c_i,
     sum,
     c_o
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input a;
input b;
input c_i;

output sum;
output c_o;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

assign sum = a ^ b ^ c_i;
assign c_o = ((a ^ b) & c_i) | (a & b); 

endmodule 
