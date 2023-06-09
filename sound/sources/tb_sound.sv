`timescale 1ns/1ps

module tb_sound();
	logic clk, rstn, aud_en;
	logic aud_pwm;


	sound_artyx sound(
	.CLK100MHZ(clk),//input CLK100MHZ,
	.BTNC(rstn),//input BTNC,
	.SW(aud_en),//input [0:0]SW,
	.AUD_PWM(aud_pwm)//output AUD_PWM
);

	always #10 clk=~clk;
    
	task waitin(input integer num_clk);
		integer i;
		for(i = 0; i<num_clk; i=i+1) begin
			@(posedge clk);

		end
		

	endtask
    

	initial begin
		clk=0;
		aud_en=0;
		rstn=1'bx;
		waitin(10000);
		rstn=1;
		waitin(1000);
		
		waitin(300);
		rstn=0;
		waitin(1000);
		aud_en=1;
		
		


	end

endmodule