module bin2pwm_32bit(
	input clk,
	input aud_en,
	input rstn,
	input [31:0] data_i,
	output pwm
		);


	logic [9:0] cntr;
	logic [7:0] duty [3:0];
	assign {duty[3], duty[2],duty[1], duty[0]} = {data_i[31:24], data_i[23:16], data_i[15:8], data_i[7:0]} ;

	always@(posedge clk or negedge rstn) begin
		    
			cntr<=(aud_en&&(rstn)) ? cntr + 1 : 0;
            
	end


	assign pwm = aud_en ? (cntr[7:0]<=duty[cntr[9:8]]) : 0;

endmodule