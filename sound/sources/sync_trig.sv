module sync_trig(
	input clk_all,
	input clk_data,
	input aud_en,
	output logic aud_en_sync 
);



always@(posedge clk_data) begin
	aud_en_sync<=aud_en;
end


endmodule