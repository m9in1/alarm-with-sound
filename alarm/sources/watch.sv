module watch(
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

);

reg [2:0] decsec_cntr;
reg [3:0] sec_cntr;
reg [19:0] pls_cntr;
reg[3:0] decms_cntr;
reg [3:0] edms_cntr;
// reg [18:0] pls_cntr;
// reg [3:0] edms_cntr;
// reg[3:0] decms_cntr;
// reg [3:0] sec_cntr;
// reg [2:0] decsec_cntr;





initial pls_cntr<=20'b0;
initial edms_cntr<=4'b0;
initial decms_cntr<=4'b0;
initial sec_cntr<=4'b0;
initial decsec_cntr<=3'b0;





wire hofsecpas = (pls_cntr==20'd999999);

always@(posedge clk or negedge rstn) begin
	if(!rstn) begin
		pls_cntr<=0;
		edms_cntr<=0;
		decms_cntr<=0;
		sec_cntr<=0;
		decsec_cntr<=0;
		
		hourdec_now<=hourdec_init;
		hourone_now<=hourone_init;
		mindec_now<=mindec_init;
		minone_now<=minone_init;
		
	end else begin
		if(hofsecpas) begin
			if(hofsecpas) begin
				pls_cntr<=0;
				
				if(edms_cntr==9) begin
					edms_cntr<=0;
					if(decms_cntr==9) begin
						decms_cntr<=0;
						if(sec_cntr==9)begin 
							sec_cntr<=0;
							if(decsec_cntr==5) begin
							     decsec_cntr<=0;
							     if(minone_now==9) begin
							         minone_now<=0;
							         if(mindec_now==5) begin
							             mindec_now<=0;
							             if(hourone_now==9) begin
							                 hourone_now<=0;
							                 if(hourdec_now==2) begin
							                     hourdec_now<=0;
							                 end else begin
							                     hourdec_now<=hourdec_now+1;
							                 end
							             end else begin
							                 //hourone_now<=hourone_now+1;
							                 if(hourdec_now==2&&hourone_now==3) begin
							                     hourone_now<=0;
							                     hourdec_now<=0;
							                 end else hourone_now<=hourone_now+1;
							             end
							         end else begin
							             mindec_now<=mindec_now+1;
							         end
							     end else begin
							         minone_now<=minone_now+1;
							     end
							     
							     
							end
							else begin
							     decsec_cntr<=decsec_cntr+1;
							end
						end else begin
						  sec_cntr<=sec_cntr+1;
						  
						end
					end else begin
					   decms_cntr<=decms_cntr+1;
					   
					end
				end else begin 
				    edms_cntr<=edms_cntr+1;
				
				end
				
			end  else begin
				pls_cntr<=pls_cntr;
			end
			
		end else begin
				pls_cntr<=pls_cntr+1;
		end
		
		
	end

end

//always@(ms_cntr) begin
//	
//end

//hex(sec_cntr,decsec_cntr,edms_cntr,decms_cntr,hex0[6:0],hex1[6:0], hex2[6:0], hex3[6:0]);


endmodule