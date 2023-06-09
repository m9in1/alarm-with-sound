module watch_bindec(
	input 				clk,
	//input               clk_disp,
	input 				rstn,
	input [3:0] 		hourdec_init,
	input [3:0] 		hourone_init,
	input [3:0]			mindec_init,
	input [3:0] 		minone_init,

	output logic [3:0] 	hourdec_now,
	output logic [3:0] 	hourone_now,
	output logic [3:0]	mindec_now,
	output logic [3:0] 	minone_now

	//input 				tim_over,
	//output logic		tim_en,

	//output logic 		CA,CB,CC,CD,CE,CF,CG,
	//output logic [7:0]	AN

);


	

	logic [5:0] counter_sec;

	logic [3:0] counter_sec_one;
	logic [3:0] counter_sec_dec;

	logic [3:0] counter_min_one;

	logic [5:0] counter_min;

	/*always@(negedge rstn) begin:init
		hourdec_now <= hourdec_init;
		hourine_now <= hourdec_init;
		mindec_now <= mindec_init;
		minone_now <= minone_init;
		tim_en <= 1;
		counter_sec <= 0;
	end:init*/



	/*always@(posedge clk) begin
		if(tim_over) begin
			tim_en<=1;
			if(counter_sec==59) begin
				counter_sec<=0;
				if(min_now==59) begin
					min_now<=0;
					if(hour_now==23) hour_now<=0;
					else hour_now<=hour_now+1;
				end else min_now<=min_now+1;
			end else begin
				counter_sec<=counter_sec+1;

			end

		end
	end*/






	always@(posedge clk or negedge rstn) begin
		if(rstn) begin

				if(counter_sec<59) begin

					counter_sec <= counter_sec+1;

				end else begin

					counter_sec <= 0;

					if(minone_now<9) begin

						minone_now <= minone_now + 1;

					end else begin
						minone_now <= 0;
						if(mindec_now<5) begin

							mindec_now <= mindec_now + 1; 

						end else begin
							mindec_now <= 0;
							if(hourone_now==3&&hourdec_now==2) begin
								hourone_now <= 0;
								hourdec_now <= 0;
							end else begin
								if(hourone_now<9) begin
									hourone_now <= hourone_now + 1;
								end else begin
									hourone_now <= 0;
									hourdec_now <= hourdec_now + 1;
								end
							end
						end
					end
				end

		end else begin
			hourdec_now <= hourdec_init;
			hourone_now <= hourone_init;
			mindec_now <= mindec_init;
			minone_now <= minone_init;
			//tim_en <= 1;
			counter_sec <= 0;

		end
	end






    

//	logic [3:0] num_now;

//	display7 disp(
//		.num(num_now), 
//		.*
//		);

//	typedef enum logic [1:0] {
//		MINONE,
//		MINDEC,
//		HOURONE,
//		HOURDEC
//	} states;

//	states state, nextstate;


//	always@(posedge clk_disp or negedge rstn) begin:state_reg
//		state<=rstn ? nextstate : MINONE;
//	end:state_reg


//	always_comb begin
//	    AN[7:4]<=1;
//		case(state)
//			MINONE: begin	
//				AN[0:0] = 0;
//				AN[3:1] = 1;
//				num_now = minone_now;
//				nextstate = MINDEC;
//			end

//			MINDEC: begin
//				AN[1:1] = 0;
//				AN[0:0] = 1;
//				AN[3:2] = 1;
//				num_now = mindec_now;
//				nextstate = HOURONE;

//			end

//			HOURONE: begin
//				AN[2:2] = 0;
//				AN[1:0] = 1;
//				AN[3:3] = 1;
//				num_now = hourone_now;
//				nextstate = HOURDEC;
//			end

//			HOURDEC: begin
//				AN[2:0] = 1;
//				AN[3:3] = 0;
//				num_now = hourdec_now;
//				nextstate = MINDEC;

//			end
//        endcase

	//end


endmodule