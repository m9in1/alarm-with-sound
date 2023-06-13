module watch_bindec_wcnt
	#(
		parameter NUM_NSEC = 100,
		parameter NUM_USEC = 1000,
		parameter NUM_MSEC = 1000)

	(
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
	logic [9:0] counter_msec;
	logic [9:0] counter_usec;
	logic [7:0] counter_nsec;


	always@(posedge clk or negedge rstn) begin
		if(rstn) begin
			if(counter_usec<(NUM_NSEC-1)) begin
				counter_nsec<=counter_nsec + 1;

			end else begin
				counter_nsec<=0;
				if(counter_usec<(NUM_USEC-1)) begin
					counter_usec<=counter_usec + 1;

				end else begin
					counter_usec<=0;
					if(counter_msec<(NUM_MSEC-1)) begin
						counter_msec<=counter_msec+1;

					end else begin
						counter_msec<=0
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


					end

				end
			end

		end else begin
			counter_nsec<=0;
			counter_usec<=0;
			counter_msec<=0;
			counter_sec<=0;
			hourdec_now <= hourdec_init;
			hourone_now <= hourone_init;
			mindec_now <= mindec_init;
			minone_now <= minone_init;

		end	

	

	end

	



	// always@(posedge clk or negedge rstn) begin
	// 	if(rstn) begin

	// 			if(counter_sec<59) begin

	// 				counter_sec <= counter_sec+1;

	// 			end else begin

	// 				counter_sec <= 0;

	// 				if(minone_now<9) begin

	// 					minone_now <= minone_now + 1;

	// 				end else begin
	// 					minone_now <= 0;
	// 					if(mindec_now<5) begin

	// 						mindec_now <= mindec_now + 1; 

	// 					end else begin
	// 						mindec_now <= 0;
	// 						if(hourone_now==3&&hourdec_now==2) begin
	// 							hourone_now <= 0;
	// 							hourdec_now <= 0;
	// 						end else begin
	// 							if(hourone_now<9) begin
	// 								hourone_now <= hourone_now + 1;
	// 							end else begin
	// 								hourone_now <= 0;
	// 								hourdec_now <= hourdec_now + 1;
	// 							end
	// 						end
	// 					end
	// 				end
	// 			end

	// 	end else begin
	// 		hourdec_now <= hourdec_init;
	// 		hourone_now <= hourone_init;
	// 		mindec_now <= mindec_init;
	// 		minone_now <= minone_init;
	// 		//tim_en <= 1;
	// 		counter_sec <= 0;

	// 	end
	// end






    




endmodule