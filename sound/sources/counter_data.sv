module counter_data(
	input clk,
	input rstn,
	input en,
	output logic [31:0] addr
	);


always@(posedge clk or negedge rstn) begin
	if(rstn&en) 	 addr<=addr + 1;
	else		     addr<=0;

end

endmodule