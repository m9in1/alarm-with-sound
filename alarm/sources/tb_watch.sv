`timescale 1ns/1ps

module tb_watch();


	logic clk, rstn;
	//logic [7:0]AN;
	//logic CA,CB,CC,CE,CD,CF,CG;
    logic [15:0] LED;
	top_artyx top(
		.CLK100MHZ(clk),
		.BTNC(rstn),
		.LED(LED)
		);

	task waitin(input integer num_clk);
		integer i;
		for(i = 0; i<num_clk; i=i+1) begin
			@(posedge clk);

		end

	endtask

	always #10 clk=~clk;

	initial begin
		clk = 0;
		rstn =0;
		waitin(2);
		rstn = 1;
		waitin(2);
		rstn = 0;



	end

endmodule