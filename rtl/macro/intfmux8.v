////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : intfmux8.v
// Description  : mux 8,7,6,5,4,3,2,1 for FPGA intergration
//
// Author       : tdhcuong@HW-TDHCUONG
// Created On   : Thu Oct 21 16:32:20 2004
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// HELP
//
// --------------------MUX 4-1--------------------
// - should select synclk: 155Mhz
//
// - MAXTS : number of time slot synclk to hold transmit data
//          6 : line clock      : synclk/6 = 25Mhz
//              setup time      : 6 synclk
//              length of cable : using jt is shorter than 1m
//                                using jb is shorter than 0.3m
//          
//          7 : line clock      : synclk/7 = 22Mhz
//              setup time      : 3 synclk
//              length of cable : using jt is shorter than 1m
//                                using jb is shorter than 0.3m
//
// - BITTS = 3 (time slot counter 3 bit)
// - Using front plane : should MAXTS = 6
// - Using back plane  : should MAXTS = 7
//
// --------------------MUX 3-1--------------------
// - should select synclk: 155Mhz (can use 116Mhz)
//
// - MAXTS : number of time slot synclk to hold transmit data
//          9 : line clock      : synclk/9 = 17Mhz
//              setup time      : 4 synclk
//              length of cable : using jt is shorter than 1m
//                                using jb is shorter than 0.4m
//          
//          10 : line clock      : synclk/10 = 15Mhz
//               setup time      : 2 synclk
//               length of cable : using jt is shorter than 1m
//                                 using jb is shorter than 0.4m
//          more...
//
// - BITTS = 4 (time slot counter 4 bit)
// - should MAXTS = 9
//
// --------------------MUX 2-1--------------------
// - should select synclk: 155Mhz (can use 116Mhz or lower)
//
// - MAXTS : number of time slot synclk to hold transmit data
//          13 : line clock      : synclk/13 = 12Mhz
//               setup time      : 6 synclk
//               length of cable : using jt is shorter than 1m
//                                 using jb is shorter than 0.6m
//          
//          14 : line clock      : synclk/14 = 11Mhz
//               setup time      : 3 synclk
//               length of cable : using jt is shorter than 1m
//                                 using jb is shorter than 0.8m
//          more...
//
// - BITTS = 4 (time slot counter 4 bit)
// - should MAXTS = 13
//
// --------------------MUX 1-1--------------------
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MUX
//            ____________________________                               ________
// iclk   ___|                            |_____________________________|
//          _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _  
// synclk _| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |
//                ___                                                       ___
// posdet _______|   |_____________________________________________________|   |___
//                    _________  _________  _________  ________________________
// odat   XXXXXXXXXXX<__bus0___><__bus1___><__bus2___><______bus3______________>
//                    _________
// osyn   ___________|         |________________________________________________
//
////////////////////////////////////////////////////////////////////////////////

module intfmux8
    (
     rst_,
     synclk,    // high clock for capturing data (155.52Mhz)
     
     iclk,      // clk data 4.86Mhz
     idat,      // MSB first

     odat,      // data out
     osyn       // 
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter   LINEBIT = 1;            // Bit of data after MUX
parameter   MUX     = 4;            // Mux 4, 3, or 2
parameter   BITTS   = 3;            // Bit of time slot counter
parameter   MAXTS   = 6;            // Number of time slot synclk to hold transmit data

// not change parameter
parameter   DATABIT = LINEBIT*MUX;  // Bit of data before MUX
parameter   NULL    = (9-MUX)*LINEBIT;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input                rst_;
input                synclk;

input                iclk;
input [DATABIT-1:0]  idat;

output [LINEBIT-1:0] odat;
output               osyn;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

// iclk detect posedge
reg [2:0]   shfdet;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) shfdet <= 3'd0;
    else shfdet <= {shfdet[1:0],iclk};
    end

wire    posdet;
assign  posdet = shfdet == 3'b011;

//wire    posdet1,posdet2;
//fflopx #(2) regposdet(synclk,rst_,{posdet,posdet1},{posdet1,posdet2});

wire    capture;
assign  capture = posdet;

reg [BITTS-1:0] cntts;
wire    endcntts;
assign  endcntts = cntts == (MAXTS-1);

always @(posedge synclk or negedge rst_)
    begin
    if     (!rst_)    cntts <= {BITTS{1'b0}};
    else if(capture)  cntts <= {BITTS{1'b0}};
    else if(endcntts) cntts <= {BITTS{1'b0}};
    else              cntts <= cntts + 1'b1;
    end

reg [2:0] cntph;
wire      endcntph;
assign    endcntph = cntph == (MUX-1);

always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) cntph <= 3'd0;
    else if(capture)  cntph <= 3'd0;
    else if(endcntph) cntph <= MUX-1;
    else if(endcntts) cntph <= cntph + 1'b1;
    end

wire [9*LINEBIT-1:0] idatpro;
assign               idatpro = {idat,{NULL{1'b0}}};

reg [LINEBIT-1:0] odat;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) odat <= {LINEBIT{1'b0}};
    else if(capture)           odat <= idatpro[(9*LINEBIT-1):(8*LINEBIT)];
    else if(endcntts)
        begin
        if     (endcntph)      odat <= odat;
        else if(cntph == 3'd0) odat <= idatpro[(8*LINEBIT-1):(7*LINEBIT)];
        else if(cntph == 3'd1) odat <= idatpro[(7*LINEBIT-1):(6*LINEBIT)];
        else if(cntph == 3'd2) odat <= idatpro[(6*LINEBIT-1):(5*LINEBIT)];
        else if(cntph == 3'd3) odat <= idatpro[(5*LINEBIT-1):(4*LINEBIT)];
        else if(cntph == 3'd4) odat <= idatpro[(4*LINEBIT-1):(3*LINEBIT)];
        else if(cntph == 3'd5) odat <= idatpro[(3*LINEBIT-1):(2*LINEBIT)];
        else if(cntph == 3'd6) odat <= idatpro[(2*LINEBIT-1):(1*LINEBIT)];
        end
    end

reg     osyn;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) osyn <= 1'b0;
    else if(capture)  osyn <= 1'b1;
    else if(endcntts) osyn <= 1'b0;
    end

endmodule 
