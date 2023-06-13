module top_alarm(
	input clk,
	input rstn,
	input bud_en,
	input off_bud,
	input [3:0] hourdec_init, hourone_init, mindec_init, minone_init,
	output [3:0] hourdec_now, hourone_now, mindec_now, minone_now,
	input [3:0] hourdec_bud, hourone_bud, mindec_bud, minone_bud,
		//output clk_sec_o,
	//output bud_state_o,
	output aud_pwm
		//output CA,CB,CC,CD,CE,CF,CG,
	//output [7:0] AN,
	//output [15:0] led
	);


    //logic cnt_sec;
   
	//logic clk_sec, clk_disp, clk_msec, clk_usec,
	logic aud_en;
    logic [5:0] cnt_sec;
    //assign clk_sec_o = clk_sec;
	watch watch(
		.clk(clk),
		//.clk_disp(clk_disp),//input 				clk,
		.rstn(rstn),//input 				rstn,
		.hourdec_init(hourdec_init),//input [3:0] 		hourdec_init,
		.hourone_init(hourone_init),//input [3:0] 		hourone_init,
		.mindec_init(mindec_init),//input [3:0]			mindec_init,
		.minone_init(minone_init),//input [3:0] 		minone_init,

		.hourdec_now(hourdec_now),//output logic [3:0] 	hourdec_now,
		.hourone_now(hourone_now),//output logic [3:0] 	hourone_now,
		.mindec_now(mindec_now),//output logic [3:0]	mindec_now,
		.minone_now(minone_now)//output logic [3:0] 	minone_now,

		);



	sound_top sound_top(
		.clk(clk),
		.rstn(rstn),
		.aud_en(aud_en),
		.pwm(aud_pwm)
						);


	sound_control sound_control(
		//.clk_sec(clk_sec),
		.clk(clk),
		.rstn(rstn),
		.bud_on(bud_en),
//		.bud_state(bud_state_o),
		.aud_en(aud_en),
		.*
		);



// //usec

// 		clk_div #(
// 		.N(200),
// 		.WIDTH(8)
// 		)
// 	clk_usec_module(
// 		.clk(clk),
// 		.rst_n(rstn),
// 		.o_clk(clk_usec)
// 				);




// //msec				
// 	clk_div #(
// 		//.N(1000), //real
// 		.N(100),   //sim
// 		.WIDTH(11)
// 		)
// 	clk_msec_module(
// 		.clk(clk_usec),
// 		.rst_n(rstn),
// 		.o_clk(clk_msec)
// 				);



// //sec
//     clk_div #(
// 		//.N(1000), //real
// 		.N(1),   //sim
// 		.WIDTH(11)
// 		)
// 	clk_sec_module(
// 		.clk(clk_msec),
// 		.rst_n(rstn),
// 		.o_clk(clk_sec)
				//);
	// div_clk
	// #(.MAX_CNT(1000000000))//00))//????? its working for 100MHZ
	//  sec_cnt(
	// 	.clk(clk),
	// 	.rstn(rstn),
	// 	.clk_sec(clk_sec)
	// 	);	
		
		
	// div_clk
	// #(.MAX_CNT(100))
	//  disp_clk(
	// 	.clk(clk),
	// 	.rstn(rstn),
	// 	.clk_sec(clk_disp)
	// 	);	



	

	

endmodule