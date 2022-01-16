module mem_gen7 (clk, addr, wr_ena, data);
parameter DATA_WIDTH = 48;
input clk;
input [4:0] addr;
input wr_ena;
output [DATA_WIDTH-1:0] data;
reg [DATA_WIDTH-1:0] data;
always@(posedge clk) begin
 case (addr)
0: data <= {12'd1942,12'd1531,12'd2824,12'd2318};
1: data <= {12'd1374,12'd2320,12'd2263,12'd830};
2: data <= {12'd2296,12'd182,12'd422,12'd3105};
3: data <= {12'd358,12'd2032,12'd432,12'd1642};
4: data <= {12'd2523,12'd1341,12'd65,12'd3247};
5: data <= {12'd2922,12'd1215,12'd1355,12'd707};
6: data <= {12'd2665,12'd239,12'd122,12'd2839};
7: data <= {12'd1266,12'd3116,12'd53,12'd3224};
8: data <= {12'd1343,12'd2203,12'd1209,12'd1685};
9: data <= {12'd1251,12'd1554,12'd1229,12'd1637};
10: data <= {12'd1868,12'd1185,12'd1137,12'd1073};
11: data <= {12'd1018,12'd1514,12'd1246,12'd1190};
12: data <= {12'd1969,12'd863,12'd823,12'd2135};
13: data <= {12'd1216,12'd857,12'd2061,12'd683};
14: data <= {12'd437,12'd1423,12'd853,12'd304};
15: data <= {12'd761,12'd2007,12'd912,12'd2218};
16: data <= {12'd604,12'd2646,12'd2324,12'd1051};
17: data <= {12'd1487,12'd3155,12'd3080,12'd2979};
18: data <= {12'd2224,12'd2236,12'd1344,12'd2192};
19: data <= {12'd2293,12'd380,12'd3176,12'd906};
20: data <= {12'd2349,12'd3132,12'd1391,12'd2866};
21: data <= {12'd1511,12'd1753,12'd1407,12'd475};
22: data <= {12'd1651,12'd150,12'd366,12'd2096};
23: data <= {12'd1495,12'd3328,12'd1117,12'd1200};
24: data <= {12'd2429,12'd3049,12'd549,12'd474};
25: data <= {12'd1214,12'd2422,12'd2555,12'd1797};
26: data <= {12'd1044,12'd720,12'd3184,12'd2048};
27: data <= {12'd1580,12'd813,12'd291,12'd2859};
28: data <= {12'd1944,12'd2755,12'd1912,12'd275};
29: data <= {12'd1775,12'd2460,12'd3151,12'd3054};
30: data <= {12'd552,12'd1265,12'd2262,12'd187};
31: data <= {12'd163,12'd1683,12'd1277,12'd672};
    default : data <= 0;
    endcase
end
endmodule