module top_artyx(
    input CLK100MHZ, 
	input BTNC, 
	//output CA,CB,CC,CD,CE,CF,CG,
	//output [7:0] AN,
	output [15:0] LED,
	output AUD_PWM
	);
logic clk_sec;
logic [3:0] hourdec_init, hourone_init, mindec_init, minone_init;
logic [3:0] hourdec_now, hourone_now, mindec_now, minone_now;
logic [3:0] hourdec_bud, hourone_bud, mindec_bud, minone_bud;
logic bud_en, bud_state_o;
assign bud_en=1;
assign {hourdec_init, hourone_init, mindec_init, minone_init} = {'0,'0,'0,'0};
assign {hourdec_bud, hourone_bud, mindec_bud, minone_bud} = {'0,'0,'0,'1};
assign {LED[15:12],LED[11:8], LED[7:4], LED[3:0]} = {hourdec_now, hourone_now, mindec_now, minone_now};	
//assign LED[0] = clk_sec;
//assign LED[15:12] = minone_now;
//assign LED[15:1] = 0;
logic rstn;
assign rstn = !BTNC;

	top_alarm alarm(
		.clk(CLK100MHZ),
		.rstn(rstn),
		.hourdec_init(hourdec_init),//input [3:0] 		hourdec_init,
		.hourone_init(hourone_init),//input [3:0] 		hourone_init,
		.mindec_init(mindec_init),//input [3:0]			mindec_init,
		.minone_init(minone_init),//input [3:0] 		minone_init,

		.hourdec_now(hourdec_now),//output logic [3:0] 	hourdec_now,
		.hourone_now(hourone_now),//output logic [3:0] 	hourone_now,
		.mindec_now(mindec_now),//output logic [3:0]	mindec_now,
		.minone_now(minone_now),//output logic [3:0] 	minone_now,
		
		.bud_en(bud_en),
		.hourdec_bud(hourdec_bud),
		.hourone_bud(hourone_bud),
		.mindec_bud(mindec_bud),
		.minone_bud(minone_bud),
		
		.aud_pwm(AUD_PWM)////input [3:0] hourdec_bud, hourone_bud, mindec_bud, minone_bud,
		
	    //.clk_sec_o(clk_sec),//output clk_sec_o,
	    //.bud_state_o(bud_state_o)//output bud_state_o
				);


endmodule