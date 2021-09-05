module k2red
(
    //clk,
    //rst,
    c,
    cred
);

//////////

//Based on K2RED algorithm 2 https://eprint.iacr.org/2021/563.pdf

/////////

parameter WID=24;
parameter WID2 = WID/2;

input [WID-1:0] c;
output [WID2-1:0] cred;

wire [15:0] ch;
wire [7:0] cl;

assign cl = c[7:0];
assign ch = c[23:8];

wire [15:0] subrs1;//rs = result
wire [15:0] addrs1;
wire [15:0] firstrs;

wire null1; //carry
//pre-shifting before add

wire [15:0] clx8;
wire [15:0] clx4;

assign clx8 = cl << 3;
assign clx4 = cl << 2;

//done shift

// first addition layer

full_sub #(16) ifullsub1 (clx8,ch,subrs1,null);
fulladder2f #(16) ifulladder2f1 (clx2,cl,addrs1);

//second addtion
fulladder2f #(16) ifulladder2f2 (subrs1,addrs1,firstrs);

//////second layer of shifting
wire [7:0] clp;
wire [7:0] chp;

assign chp = firstrs[15:8];
assign clp = firstrs[7:0];

//pre-shifting 2

wire [11:0] clpx8;
wire [11:0] clpx4;

assign clpx8 = clp << 3;
assign clpx4 = clp << 2;

/////second layer of addtion
wire [15:0] subrs2;//rs = result
wire [15:0] addrs2;
wire [15:0] finalrs;

wire null2; //carry

full_sub #(12) ifullsub2 (clpx8,chp,subrs2,null2);
fulladder2f #(12) ifulladder2f2 (clpx2,clp,addrs2);

//second addtion
fulladder2f #(12) ifulladder2f2 (subrs2,addrs2,finalrs);

assign cred = finalrs;

endmodule