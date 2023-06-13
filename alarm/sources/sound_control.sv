module sound_control(
	input clk,
	input rstn,
	input bud_on,
	input off_bud,
	input [3:0] hourdec_bud, hourone_bud, mindec_bud, minone_bud,
	input [3:0] hourdec_now, hourone_now, mindec_now, minone_now,
	output logic aud_en
	//,output logic bud_state 

	);




	always@(posedge clk or negedge rstn) begin

		if(!rstn) begin

		end else begin
			if({hourdec_now,hourone_now,mindec_now,minone_now}=={hourdec_bud, 
				    hourone_bud, mindec_bud, minone_bud}) begin

				if(bud_on) begin

					if(off_bud) aud_en<=0;
					else		aud_en<=1;

				end

			end

		end

	end

	/*always@(posedge clk or negedge rstn) begin
		if(rstn) begin
		  if({hourdec_now,hourone_now,mindec_now,minone_now}=={hourdec_bud, 
				    hourone_bud, mindec_bud, minone_bud}) begin
                if(bud_state) begin
					bud_state<=counter_sec<2 ? 1 : 0;
					aud_en<=1;
					counter_sec<=counter_sec+1;
				end else begin
					aud_en<=0;
					counter_sec<=0;
				end
			end else bud_state<=bud_on;




		end else begin
			bud_state<=bud_on;
			aud_en<=0;
			counter_sec<=0;

		end*/

	end


endmodule