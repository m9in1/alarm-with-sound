module arty_watch(
	input CLK100MHZ,
	input BTNC,
	input BTNU,
	output [15:0] LED

);

    logic [3:0] 		hourdec_init;
	logic [3:0] 		hourone_init;
	logic [3:0]			mindec_init;
	logic [3:0] 		minone_init;

	logic [3:0] hourdec_now;
	logic [3:0] hourone_now;
	logic [3:0]	mindec_now;
	logic [3:0] minone_now;


/*assign LED[15:6] = 0;
	watch_bindec_fixed secmer(
		.clk(CLK100MHZ),
		.rstn(!BTNU),
		.eds_counter(LED[3:0]),
		.decs_counter(LED[6:4])
		//.decsec_cntr(LED[7:4])//output reg [3:0] sec_cntr,
		//output reg [2:0] decsec_cntr,
		);*/

assign LED[15:15] = 0;
	watch watch(
		.clk(CLK100MHZ),
		.rstn(!BTNC),
		//.en_key(BTNU),
		.sec_cntr(),
		.decsec_cntr(),
		
		.hourdec_init(4'h2),
	    .hourone_init(4'h3),
	    .mindec_init(4'h5),
	    .minone_init(4'h9),
		
		.hourdec_now(LED[15:12]),
		.hourone_now(LED[11:8]),
		.mindec_now(LED[7:4]),
		.minone_now(LED[3:0])
		);
		//output reg [3:0] sec_cntr,
		//output reg [2:0] decsec_cntr,/*/
endmodule