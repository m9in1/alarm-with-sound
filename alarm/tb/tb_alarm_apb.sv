`timescale 1ns / 1ps

`define NUM_TO_DISP 32'h0000
`define RESET 32'h0004


`define TIME_INIT_ADDR 32'h0
`define TIME_ALARM_ADDR 32'h4
`define TIME_NOW_ADDR 32'h8
`define ALARM_OFF_ADDR 32'hc

module tb_alarm_apb ();

  ////////////////
  // Parameters //
  ////////////////

  // Clock period
  parameter real CLK_PERIOD = 5;  // 100Mhz

  // Test timeout (clock periods)
  parameter TEST_TIMEOUT = 100000;


  ////////////////////
  // Design signals //
  ////////////////////

  logic             pclk_i;
  logic             presetn_i;
  logic [31:0]      paddr_i;
  logic             psel_i;
  logic             penable_i;
  logic             pwrite_i;
  logic [ 3:0][7:0] pwdata_i;
  logic [ 3:0]      pstrb_i;
  logic             pready_o;
  logic [31:0]      prdata_o;
  logic             pslverr_o;

  logic aud_pwm;


  /////////
  // DUT //
  /////////

  apb_alarm DUT (
      .pclk_i   (pclk_i),
      .presetn_i(presetn_i),
      .paddr_i  (paddr_i),
      .psel_i   (psel_i),
      .penable_i(penable_i),
      .pwrite_i (pwrite_i),
      .pwdata_i (pwdata_i),
      .pstrb_i  (pstrb_i),
      .pready_o (pready_o),
      .prdata_o (prdata_o),
      .pslverr_o(pslverr_o),

      .aud_pwm(aud_pwm)



  
  );

  // Clock
  initial begin
    pclk_i = 1'b0;
    forever begin
      #(CLK_PERIOD / 2) pclk_i = ~pclk_i;
    end
  end

  ///////////
  // Tasks //
  ///////////

  
  // APB

  task automatic exec_apb_write_trans(input bit [31:0] paddr, input bit [31:0] pwdata,
                                      input bit [3:0] pstrb, input bit pslverr);
    // Setup phase
    paddr_i  <= paddr;
    psel_i   <= 1'b1;
    pwrite_i <= 1'b1;
    pwdata_i <= pwdata;
    pstrb_i  <= pstrb;
    // Access phase
    @(posedge pclk_i);
    penable_i <= 1'b1;
    do begin
      @(posedge pclk_i);
    end while (!pready_o);
    // Check error
    check_pslverr(pslverr_o, pslverr);
    // Save data
    pslverr = pslverr_o;
    // Unset penable
    penable_i <= 1'b0;
  endtask

  task automatic exec_apb_read_trans(input bit [31:0] paddr, output bit [31:0] prdata,
                                     input bit pslverr);
    // Setup phase
    paddr_i  <= paddr;
    psel_i   <= 1'b1;
    pwrite_i <= 1'b0;
    // Access phase
    @(posedge pclk_i);
    penable_i <= 1'b1;
    do begin
      @(posedge pclk_i);
    end while (!pready_o);
    // Check error
    check_pslverr(pslverr_o, pslverr);
    // Save data
    prdata = prdata_o;
    // Unset penable
    penable_i <= 1'b0;
  endtask


  // Checkers

  function void check_pslverr(input bit pslverr, input bit level);
    if (pslverr != level) begin
      $error("PSLVERR = %0b detected but not expected", pslverr);
      $stop();
    end
  endfunction

  // Specific

  // Reset

  task init();
    fork
      begin
        presetn_i <= 1'b0;
        #(5 * CLK_PERIOD);
        presetn_i <= 1'b1;

        exec_apb_write_trans(`TIME_INIT_ADDR, 32'h10000, 4'b1111, 4'b0000);
        #(5 * CLK_PERIOD);
        exec_apb_write_trans(`TIME_INIT_ADDR, 32'h00000, 4'b1111, 4'b0000);
        #(5 * CLK_PERIOD);
        exec_apb_write_trans(`TIME_INIT_ADDR, 32'h10000, 4'b1111, 4'b0000);

      end
      begin
        paddr_i   <= '0;
        psel_i    <= '0;
        penable_i <= '0;
        pwrite_i  <= '0;
        pwdata_i  <= '0;
        pstrb_i   <= '0;
      end
    join
  endtask



  task time_set(input [31:0] time_init_data, output err);
    logic [31:0] time_init_data_post;
    time_init_data_post=time_init_data;
    exec_apb_write_trans(`TIME_INIT_ADDR, time_init_data_post, 4'b1111, err);
    #(5*CLK_PERIOD);
    time_init_data_post[16] = 0;
    exec_apb_write_trans(`TIME_INIT_ADDR, time_init_data_post, 4'b1111, err);
     #(5*CLK_PERIOD);
    time_init_data_post[16] = 1;
    exec_apb_write_trans(`TIME_INIT_ADDR, time_init_data_post, 4'b1111, err);


  endtask

  task alarm_set(input [31:0] alarm_init_data, output err);

    exec_apb_write_trans(`TIME_ALARM_ADDR, alarm_init_data, 4'b1111, err);
   


  endtask

  task time_now( output [31:0] time_now_data, output err);
    exec_apb_read_trans(`TIME_NOW_ADDR, time_now_data, err);

  endtask


  // task get_data(output bit [31:0] data, input bit pslverr);
  //   exec_apb_read_trans(`NUM_TO_DISP, data, pslverr);
  // endtask

  // task set_data(input bit [31:0] data, input bit pslverr);
  //   exec_apb_write_trans(`NUM_TO_DISP, data, 4'b1111, pslverr);
  // endtask

  // Tests

  // task reg_valid_read_write_test(int iterations = 10);
  //   bit [31:0] data_in;
  //   bit [31:0] data_out;
  //   $display("\nStarting valid write/read (%0d iterations)", iterations);
  //   for (int i = 0; i < iterations; i = i + 1) begin
  //     $display("Iteration %0d", i);
  //     foreach (data_in[i]) data_in[i] = $random();
  //     set_data(data_in, 4'b0000);
  //     // get_data(data_out, 4'b0000);
  //     // if (data_in != data_out) begin
  //     //   $error("DATA_IN[WRITE] != DATA_IN[READ]: %h != %h", data_in, data_out);
  //     //   $stop();
  //     // end
  //   end
  // endtask

  // task reg_invalid_read_write_test(int iterations = 10);
  //   bit [31:0] data_in;
  //   $display("\nStarting invalid write/read (%0d iterations)", iterations);
  //   for (int i = 0; i < iterations; i = i + 1) begin
  //     $display("Iteration %0d", i);
  //     foreach (data_in[i]) data_in[i] = $random();
  //     exec_apb_write_trans(`RESET + 4, data_in, 4'b1111, 1'b1);
  //     exec_apb_read_trans(`NUM_TO_DISP, data_in, 1'b1);
  //   end
  // endtask

  typedef enum {
    INIT = 0,
    TIME_SET = 1,
    ALARM_SET = 2,
    TIME_GET = 3
  } tests_names_t;

  tests_names_t curr_test;
  bit [31:0] data_to_reg;
  bit [31:0] reg_to_data;
  bit err_o;
  initial begin
    fork
      begin
        curr_test = INIT;
        init();
        curr_test=TIME_SET;
        #(2*CLK_PERIOD);
        data_to_reg=32'h11052;
        time_set(data_to_reg, err_o);
        #(2*CLK_PERIOD);
        curr_test = TIME_GET;
        time_now(reg_to_data, err_o);
        #(2*CLK_PERIOD);
        curr_test = ALARM_SET;
        alarm_set(32'h11100);
        #(85000 * CLK_PERIOD);
        $display("\nAll tests done");
      end
      begin
        repeat (TEST_TIMEOUT) @(posedge pclk_i);
        $error("\nTest was failed: timeout");
      end
    join_any
    $finish();
  end

endmodule