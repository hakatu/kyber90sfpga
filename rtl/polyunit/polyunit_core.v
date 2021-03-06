module polyunit_core(
    clk,
    rst,
    
    data_in,
    data_out, //NTT RAM

    mode,//see param
    run,
    done
);
////////////////////////////
parameter WID   = 12;
parameter RDWID = WID*4; //RAM DATAWID
parameter ADDWID = 5;//32 address ram

//poly statemachine
localparam          POLYWID     = 3;
localparam          P_IDLE      = 3'd0;
localparam          P_NTT       = 3'd1;//
localparam          P_INTT      = 3'd2;//
localparam          P_BYPASS    = 3'd3;//
localparam          P_DATAIN    = 3'd4;//

//mode param
localparam          MODEWID     = 2;
localparam          M_DATAIN    = 2'd0;
localparam          M_NTT       = 2'd1;//
localparam          M_INTT      = 2'd2;//
localparam          M_BYPASS    = 2'd3;//

//buffer delay
localparam          BUFFERDELAY = 3;//

//STEP WID
localparam STEPWID = 3; //8'th step

//WAIT WID
localparam WAITCLOCK = 16; //16' clock
localparam WAITWID = 1>>(WAITCLOCK);
////////////////////////////
input    clk;
input    rst;
    
input [RDWID-1:0] data_in;
input [RDWID-1:0] data_out; //NTT RAM

input [1:0] mode;//mode of operation
input run;

output done;
//////////////////////////////////////
//define
wire [RDWID-1:0] buf_data;
wire but_sel1,but_sel2,but_sel3,but_sel4;
wire [ADDWID-1:0] addr_mem1,addr_mem2,addr_mem3;

wire [RDWID-1:0] rdo;
wire [ADDWID-1:0] rda;

wire [RDWID-1:0] wdi;
wire [ADDWID-1:0] wda; 
wire we;

wire romnext;
reg  [ADDWID-1:0] romaddcnt;

wire ramnext;//read
reg  [ADDWID-1:0] ramaddcnt;

wire wramnext;//write
reg  [ADDWID-1:0] wramaddcnt;

wire stepflag;
reg [STEPWID-1:0] stepcnt;

wire waitflag;
reg [WAITWID-1:0] waitcnt;

////////////////////////////////////
//POLY FSM
reg [POLYWID-1:0] poly_state;

wire      polyisdone; 

assign    polyisdone = ramaddcnt == 5'b11111;

wire      polyisrun; 

assign    polyisrun = run;

wire      polyisidle; 

assign    polyisidle = poly_state == P_IDLE;

wire      polyisntt; 

assign    polyisntt = poly_state == P_NTT;

wire      polyisintt; 

assign    polyisintt = poly_state == P_INTT;

wire      polyisbypass; 

assign    polyisbypass = poly_state == P_BYPASS;

wire      polyisdatain; 

assign    polyisdatain = poly_state == P_DATAIN;

wire      modeisntt; 

assign    modeisntt = mode == M_NTT;

wire      modeisintt; 

assign    modeisintt = mode == M_INTT;

wire      modeisbypass; 

assign    modeisbypass = mode == M_BYPASS;

wire      modeisdatain; 

assign    modeisdatain = mode == M_DATAIN;

always@(posedge clk)
    begin
    if(rst)
        begin
        poly_state <= P_IDLE;
        end
    else
        begin
        if(polyisrun & polyisidle & modeisntt)
            begin
            poly_state <= P_NTT;            
            end
        else if(polyisrun & polyisidle & modeisintt)
            begin
            poly_state <= P_INTT;    
            end
        else if(polyisrun & polyisidle & modeisbypass)
            begin
            poly_state <= P_BYPASS;     
            end
        else if(polyisrun & polyisidle & modeisdatain)
            begin
            poly_state <= P_BYPASS;     
            end
        else if(polyisdone & !polyisidle)
            begin
            poly_state <= P_IDLE;     
            end
        else //default state because the sun
            begin
            poly_state <= poly_state;     
            end
        end
    end

assign romnext = (!polyisidle & !polyisdatain) & stepflag; //not data in?
assign ramnext = (!polyisidle & !polyisdatain) & stepflag;

wire wramnextcond1;
assign wramnextcond1 = stepflag & waitflag; //wait for first butt

wire wramnextcond2;
assign wramnextcond2 = polyisdatain; // dont need step // 32 clocks

assign wramnext =  wramnextcond1 || wramnextcond2;

////////////////////////////
//address counter
//ROM
always @(posedge clk) begin
    if(rst)
    begin
        romaddcnt <= 0;
    end
    else
    begin
        if(romnext)
        romaddcnt <= romaddcnt + 1;
        else if(polyisidle)
        romaddcnt <= 0;
        else
        romaddcnt <= romaddcnt;
    end
end

assign addr_mem1 = romaddcnt;
assign addr_mem2 = romaddcnt;
assign addr_mem3 = romaddcnt; //is to change if they are different

//NTT RAM (READ)


always @(posedge clk) begin
    if(rst)
    begin
        ramaddcnt <= 0;
    end
    else
    begin
        if(ramnext)
        ramaddcnt <= ramaddcnt + 1;
        else if(polyisidle)
        ramaddcnt <= 0;
        else
        ramaddcnt <= ramaddcnt;
    end
end

assign rda = ramaddcnt;

//NTT RAM (WRITE)


always @(posedge clk) begin
    if(rst)
    begin
        wramaddcnt <= 0;
    end
    else
    begin
        if(wramnext)
        wramaddcnt <= wramaddcnt + 1;
        else if(polyisidle)
        wramaddcnt <= 0;
        else
        wramaddcnt <= wramaddcnt;
    end
end

assign wda = wramaddcnt;

//step counter
always @(posedge clk) begin
    if(rst)
    begin
        stepcnt <= 0;
    end
    else
    begin
        if(!polyisidle)
        stepcnt <= stepcnt + 1;
        else if(polyisidle)
        stepcnt <= 0;
        else
        stepcnt <= stepcnt;
    end
end

assign stepflag = stepcnt == 3'b111;//7?

//wait flag generator
//wait counter
always @(posedge clk) begin
    if(rst)
    begin
        waitcnt <= 0;
    end
    else
    begin
        if(!polyisidle & !polyisdatain)
        waitcnt <= waitcnt + 1;
        else if(polyisidle)
        waitcnt <= 0;
        else
        waitcnt <= waitcnt;
    end
end

assign waitflag = waitcnt == WAITCLOCK;

/////////////////////////////
//ROM w00 w10 w11
wire [WID-1:0] w00,w10,w11;

mem_gen1 #(WID) imem_gen1 (clk,addr_mem1,wr_ena,w00);//w00
mem_gen2 #(WID) imem_gen2 (clk,addr_mem2,wr_ena,w10);//w10
mem_gen3 #(WID) imem_gen (clk,addr_mem3,wr_ena,w11);//w11

////////////////////////////
//NTT_RAM

alram112x #(RDWID,ADDWID) ialram112x
    (
     .clkw(clk),//clock write
     .clkr(clk),//clock read
     .rst(clk),
     
     .rdo(rdo),//data from ram
     .ra(rda),//read address
     
     .wdi(wdi),//data to ram
     .wa(wda),//write address
     .we(we) //write enable
     );

assign we = polyisdatain? data_in : buf_data;

/////////////////////////////////
//butter fly //but_sel

wire [WID-1:0] u00,v00,u01,v01;
wire [WID-1:0] u10,v10,u11,v11;
wire [WID-1:0] u21,v20,u20,v21;
wire [WID-1:0] u21buf,v20buf,u20buf,v21buf;

butterfly #(WID) ibutterfly1(
    .clk(clk),
    .rst(rst),

    .a(u00),//input 12-bit
    .b(v00),
    .w(w00),

    .c(u10),
    .d(u11),

    .sel(but_sel1) //mode of operation 1: NTT:0 INTT:1 BYPASS:2
);

butterfly #(WID) ibutterfly2(
    .clk(clk),
    .rst(rst),

    .a(u01),//input 12-bit
    .b(v01),
    .w(w00),

    .c(v10),
    .d(v11),

    .sel(but_sel2) //mode of operation 1: NTT:0 INTT:1 BYPASS:2
);

butterfly #(WID) ibutterfly3(
    .clk(clk),
    .rst(rst),

    .a(u10),//input 12-bit
    .b(v10),
    .w(w10),

    .c(u20),
    .d(u21),

    .sel(but_sel3) //mode of operation 1: NTT:0 INTT:1 BYPASS:2
);

butterfly #(WID) ibutterfly4(
    .clk(clk),
    .rst(rst),

    .a(u11),//input 12-bit
    .b(v11),
    .w(w11),

    .c(v20),
    .d(v21),

    .sel(but_sel4) //mode of operation 1: NTT:0 INTT:1 BYPASS:2
);

ffxkclkx #(BUFFERDELAY,WID) (clk,rst,u20,u20buf);
ffxkclkx #(BUFFERDELAY,WID) (clk,rst,u21,u21buf);
ffxkclkx #(BUFFERDELAY,WID) (clk,rst,v20,v20buf);
ffxkclkx #(BUFFERDELAY,WID) (clk,rst,v21,v21buf);

assign buf_data = {v21,u21,v20,u20};

endmodule