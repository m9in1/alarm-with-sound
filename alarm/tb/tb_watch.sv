`timescale 1ns/1ps

module tb_watch();


	logic clk, rst;
	//logic [7:0]AN;
	//logic CA,CB,CC,CE,CD,CF,CG;
    logic [15:0] LED;
    logic AUD_PWM;
	arty_watch top(
		.CLK100MHZ(clk),
		.BTNC(rst),
		.BTNU(0),
		.LED(LED),
		.AUD_PWM(AUD_PWM)
		);

	task waitin(input integer num_clk);
		integer i;
		for(i = 0; i<num_clk; i=i+1) begin
			@(posedge clk);

		end

	endtask

	always #5 clk=~clk;

	initial begin
		clk = 0;
		rst =0;
		waitin(2);
		rst = 1;
		waitin(2);
		rst = 0;



	end

endmodule