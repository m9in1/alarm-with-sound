module sound_artyx(
	input CLK100MHZ,
	input BTNC,
	input [0:0]SW,
    output [15:0]LED,
	output AUD_PWM
);

logic [15:0] data_rd;

assign LED = data_rd;
sound_top sound_top(
	.clk(CLK100MHZ),
	.rstn(!BTNC),
	.aud_en(SW[0]),
	.pwm(AUD_PWM),
	.data_for_leds(data_rd)	);


endmodule