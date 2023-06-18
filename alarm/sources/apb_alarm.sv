module apb_alarm(
	 // Clock
    input logic pclk_i,

    // Reset
    input logic presetn_i,

    // Address
    input logic [31:0] paddr_i,

    // Control-status
    input logic psel_i,
    input logic penable_i,
    input logic pwrite_i,

    // Write
    input logic [31:0]     pwdata_i,
    input logic [3:0]      pstrb_i,

    // Slave
    output logic        pready_o,
    output logic [31:0] prdata_o,
    output logic        pslverr_o,



    output logic aud_pwm

	);

	`define TIME_INIT_ADDR 32'h0
	`define TIME_ALARM_ADDR 32'h4
	`define TIME_NOW_ADDR 32'h8
    `define ALARM_OFF_ADDR 32'hc


	///registers
	logic [31:0] time_init;
	logic [31:0] time_now;
	logic [31:0] time_alarm;

	////
	logic time_rstn, alarm_en, off_alarm;

	logic [3:0] hourdec_init, hourone_init;
	logic [3:0] mindec_init, minone_init;
	logic [3:0] hourdec_now, hourone_now;
	logic [3:0] mindec_now, minone_now;
	logic [3:0] hourdec_alarm, hourone_alarm;
	logic [3:0] mindec_alarm, minone_alarm;

	

	assign {mindec_init, minone_init} = time_init[7:0];
	assign {hourdec_init, hourone_init} = time_init[15:8];

	assign time_now[31:0] = {'0, hourdec_now, hourone_now,
	 mindec_now, minone_now};

	assign {mindec_alarm, minone_alarm} = time_alarm[7:0];
	assign {hourdec_alarm, hourone_alarm} = time_alarm[15:8];

	/////

	top_alarm alarm(
			.clk(pclk_i),//input clk,
			.rstn(time_rstn),//input rstn,
			.bud_en(alarm_en),//input bud_en,
			.aud_pwm(aud_pwm),
            .off_bud(off_alarm),
			.hourdec_bud(hourdec_alarm),
			.hourone_bud(hourone_alarm),
			.mindec_bud(mindec_alarm),
			.minone_bud(minone_alarm),
			.*
			//input [3:0] hourdec_init, hourone_init, mindec_init, minone_init,
			//output logic [3:0] hourdec_now, hourone_now, mindec_now, minone_now,
			//input [3:0] hourdec_bud, hourone_bud, mindec_bud, minone_bud,
			//output bud_state_o,
			//output aud_pwm

		);



	//apb control

	 always_ff @(posedge pclk_i) begin
    pready_o <= psel_i;
  end

  logic psel_prev;


  typedef enum {
    NONE = 0,
    PENABLE = 1,
    PWRITE = 2,
    PSEL_PREV = 3,
    ADDRES = 4,
    READ_ONLY = 5,
    WRITE_ONLY = 6,
    REQUEST = 7,
    MISALIGN = 8
  } pslverr_causes_t;

  logic [2:0] pslverr_status;

  always_comb begin
    pslverr_o <= 0;
    psel_prev <= psel_i;

    pslverr_status <= NONE;

    // Wrong transaction phase

    if (penable_i && ~psel_i) begin
      pslverr_o <= 1;
      pslverr_status <= PENABLE;
    end
    if (pwrite_i && ~psel_i) begin
      pslverr_o <= 1;
      pslverr_status <= PWRITE;
    end
    if (~psel_prev && penable_i) begin
      pslverr_o <= 1;
      pslverr_status <= PSEL_PREV;
    end

    if (paddr_i > `TIME_NOW_ADDR) begin  // Register at the address doesn't exist
      pslverr_o <= 1;
      pslverr_status <= ADDRES;
    end

    // if ((paddr_i <= `RST) && ~pwrite_i && psel_i) begin  // Read from write-only register
    //   pslverr_o <= 1;
    //   pslverr_status <= WRITE_ONLY;
    // end

    if (paddr_i[1:0]) begin  // Misaligned address
      pslverr_o <= 1;
      pslverr_status <= MISALIGN;
    end
  end

  // WRITE REGS
  always_ff @(posedge pclk_i or negedge presetn_i) begin
    if (~presetn_i) begin
      time_rstn <= '0;
      alarm_en <='0;
      time_init   <= '0;
      time_alarm <= '0;
      off_alarm<= '0;
    end else if (psel_i && pwrite_i) begin
      case (paddr_i[11:0])
        // `RSTN_ADDR: begin
        //   alarm_rstn <= pwdata_i;
        //   alarm_en<='0;
        // end
        `ALARM_OFF_ADDR: begin
          off_alarm<=pwdata_i[0];

        end
        `TIME_INIT_ADDR: begin
          time_init <= pwdata_i[15:0];
          time_rstn<=pwdata_i[16];
        end
        `TIME_ALARM_ADDR: begin
        	time_alarm <= pwdata_i[15:0];
        	alarm_en<=pwdata_i[16];

        end
        default: begin
        	//time_rstn <= '1;
     	 	//time_init   <= '0;
      		//time_alarm <= '0;
        end
      endcase
    end
  end


  // READ REGS
  always_ff @(posedge pclk_i or negedge presetn_i) begin
    if (~presetn_i) begin
      prdata_o<='0;
    end else if (psel_i && !pwrite_i) begin
      case (paddr_i[11:0])
        `TIME_NOW_ADDR: begin
        	prdata_o<=time_now;
        end
        default: begin
        	prdata_o <= 32'hebbeb;
        end
      endcase
    end
  end


endmodule