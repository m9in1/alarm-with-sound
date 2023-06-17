`timescale 1ns / 1ps

`define NUM_TO_DISP 32'h0000
`define RESET 32'h0004

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

  // Reset

  task reset();
    fork
      begin
        presetn_i <= 1'b0;
        #(5 * CLK_PERIOD);
        presetn_i <= 1'b1;

        exec_apb_write_trans(`RESET, 32'hffffffff, 4'b1111, 4'b0000);
        #(5 * CLK_PERIOD);
        exec_apb_write_trans(`RESET, 32'b0, 4'b1111, 4'b0000);
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

  task get_data(output bit [31:0] data, input bit pslverr);
    exec_apb_read_trans(`NUM_TO_DISP, data, pslverr);
  endtask

  task set_data(input bit [31:0] data, input bit pslverr);
    exec_apb_write_trans(`NUM_TO_DISP, data, 4'b1111, pslverr);
  endtask

  // Tests

  task reg_valid_read_write_test(int iterations = 10);
    bit [31:0] data_in;
    bit [31:0] data_out;
    $display("\nStarting valid write/read (%0d iterations)", iterations);
    for (int i = 0; i < iterations; i = i + 1) begin
      $display("Iteration %0d", i);
      foreach (data_in[i]) data_in[i] = $random();
      set_data(data_in, 4'b0000);
      // get_data(data_out, 4'b0000);
      // if (data_in != data_out) begin
      //   $error("DATA_IN[WRITE] != DATA_IN[READ]: %h != %h", data_in, data_out);
      //   $stop();
      // end
    end
  endtask

  task reg_invalid_read_write_test(int iterations = 10);
    bit [31:0] data_in;
    $display("\nStarting invalid write/read (%0d iterations)", iterations);
    for (int i = 0; i < iterations; i = i + 1) begin
      $display("Iteration %0d", i);
      foreach (data_in[i]) data_in[i] = $random();
      exec_apb_write_trans(`RESET + 4, data_in, 4'b1111, 1'b1);
      exec_apb_read_trans(`NUM_TO_DISP, data_in, 1'b1);
    end
  endtask

  typedef enum {
    RESET = 0,
    VALID_R_W_TEST = 1,
    INVALID_R_W_TEST = 2,
    DISPLAY_TEST = 3
  } tests_names_t;

  tests_names_t curr_test;
  bit [31:0] disp_num;
  initial begin
    fork
      begin
        curr_test = RESET;
        reset();
        curr_test = VALID_R_W_TEST;
        reg_valid_read_write_test(100);
        curr_test = INVALID_R_W_TEST;
        reg_invalid_read_write_test(20);
        curr_test = DISPLAY_TEST;
        $display("\nStarting display numbers test");
        disp_num = 32'hf514f842;
        exec_apb_write_trans(`NUM_TO_DISP, disp_num, 4'b1111, 4'b0000);
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