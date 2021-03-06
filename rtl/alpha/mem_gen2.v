module mem_gen2 (clk, addr, wr_ena, data);
parameter DATA_WIDTH = 48;
input clk;
input [4:0] addr;
input wr_ena;
output [DATA_WIDTH-1:0] data;
reg [DATA_WIDTH-1:0] data;
always@(posedge clk) begin
 case (addr)
0: data <= {12'd1580,12'd2921,12'd1963,12'd2307};
1: data <= {12'd605,12'd1339,12'd498,12'd1484};
2: data <= {12'd2075,12'd476,12'd1897,12'd2291};
3: data <= {12'd1216,12'd3070,12'd2930,12'd1310};
4: data <= {12'd1664,12'd374,12'd1356,12'd2175};
5: data <= {12'd852,12'd2480,12'd1383,12'd1326};
6: data <= {12'd886,12'd1477,12'd2925,12'd1249};
7: data <= {12'd2647,12'd1560,12'd1117,12'd2726};
8: data <= {12'd692,12'd2152,12'd1515,12'd2494};
9: data <= {12'd2871,12'd674,12'd1278,12'd901};
10: data <= {12'd2299,12'd741,12'd30,12'd3186};
11: data <= {12'd144,12'd1594,12'd2776,12'd2093};
12: data <= {12'd1653,12'd42,12'd904,12'd2226};
13: data <= {12'd2384,12'd1806,12'd289,12'd1027};
14: data <= {12'd2381,12'd2616,12'd2871,12'd2562};
15: data <= {12'd965,12'd1323,12'd231,12'd1690};
16: data <= {12'd2149,12'd1530,12'd1737,12'd1802};
17: data <= {12'd2034,12'd2475,12'd1356,12'd1158};
18: data <= {12'd660,12'd1624,12'd642,12'd2419};
19: data <= {12'd906,12'd402,12'd2406,12'd1902};
20: data <= {12'd1368,12'd1461,12'd1728,12'd2870};
21: data <= {12'd2752,12'd2435,12'd4,12'd1404};
22: data <= {12'd314,12'd1488,12'd1633,12'd3220};
23: data <= {12'd2832,12'd1281,12'd2984,12'd2133};
24: data <= {12'd1207,12'd1938,12'd1005,12'd1770};
25: data <= {12'd1928,12'd2303,12'd1021,12'd1972};
26: data <= {12'd242,12'd1639,12'd1727,12'd3219};
27: data <= {12'd1236,12'd1477,12'd85,12'd842};
28: data <= {12'd496,12'd2407,12'd103,12'd1891};
29: data <= {12'd3115,12'd1800,12'd329,12'd1261};
30: data <= {12'd2404,12'd2070,12'd2024,12'd2875};
31: data <= {12'd3189,12'd2900,12'd633,12'd1837};
    default : data <= 0;
    endcase
end
endmodule
