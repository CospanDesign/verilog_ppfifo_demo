/*
Distributed under the MIT license.
Copyright (c) 2015 Dave McCoy (dave.mccoy@cospandesign.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*
 * Author: David McCoy (dave.mccoy@cospandesign.com)
 * Description:
 *  Test Bench for PPFIFO:
 *    Demonstrates reading and writing to/from a PPFIFO
 *
 * Changes:
 */

`timescale 1ns/1ps

`define CLK_HALF_PERIOD 10
`define CLK_PERIOD (2 * `CLK_HALF_PERIOD)

`define SLEEP_HALF_CLK #(`CLK_HALF_PERIOD)
`define SLEEP_FULL_CLK #(`CLK_PERIOD)

//Sleep a number of clock cycles
`define SLEEP_CLK(x)  #(x * `CLK_PERIOD)



/*
 *  CHANGE THIS VALUE TO TEST CLOCK RATES
 *  NOTE: BE AWARE THAT YOU MIGHT NEED TO ADJUST THE RESET SLEEP PERIOD
 */

`define RD_CLK_HALF_PERIOD 10
`define RD_CLK_PERIOD (2 * `RD_CLK_HALF_PERIOD)



module tb_ppfifo (
);
//local parameters
localparam      DATA_WIDTH  = 32;  //32-bit data
localparam      ADDR_WIDTH  = 4;   //2 ** 4 = 16 positions

//registes/wires
reg   clk       = 0;
reg   rd_clk    = 0;

reg   rst       = 0;


//write side
wire        [1:0]                 write_ready;
wire        [1:0]                 write_activate;
wire        [23:0]                write_fifo_size;
wire                              write_strobe;
wire        [DATA_WIDTH - 1: 0]   write_data;
wire                              starved;

//read side
wire                              read_strobe;
wire                              read_ready;
wire                              read_activate;
wire        [23:0]                read_count;
wire        [DATA_WIDTH - 1: 0]   read_data;

wire                              inactive;



//submodules

//Write Side
ppfifo_source #(
  .DATA_WIDTH                       (DATA_WIDTH         )
) source (
  .clk                              (clk                ),
  .rst                              (rst                ),
  .i_enable                         (1'b1               ),

  //Ping Pong FIFO Interface
  .i_wr_rdy                         (write_ready        ),
  .o_wr_act                         (write_activate     ),
  .i_wr_size                        (write_fifo_size    ),
  .o_wr_stb                         (write_strobe       ),
  .o_wr_data                        (write_data         )
);

//PPFIFO
ppfifo #(
  .DATA_WIDTH                       (DATA_WIDTH         ),
  .ADDRESS_WIDTH                    (ADDR_WIDTH         )
) f (

  //universal input
  .reset                            (rst                ),

  //write side
  .write_clock                      (clk                ),
  .write_ready                      (write_ready        ),
  .write_activate                   (write_activate     ),
  .write_fifo_size                  (write_fifo_size    ),
  .write_strobe                     (write_strobe       ),
  .write_data                       (write_data         ),
  .starved                          (starved            ),

  //read side
  .read_clock                       (rd_clk             ),
  .read_strobe                      (read_strobe        ),
  .read_ready                       (read_ready         ),
  .read_activate                    (read_activate      ),
  .read_count                       (read_count         ),
  .read_data                        (read_data          ),

  .inactive                         (inactive           )
);

//Read Side
ppfifo_sink #(
  .DATA_WIDTH                       (DATA_WIDTH         )
) sink (
  .clk                              (rd_clk             ),
  .rst                              (rst                ),

  //Ping Pong FIFO Interface
  .i_rd_rdy                         (read_ready         ),
  .o_rd_act                         (read_activate      ),
  .i_rd_size                        (read_count         ),
  .o_rd_stb                         (read_strobe        ),
  .i_rd_data                        (read_data          )
);


//asynchronous logic
//synchronous logic

always #`CLK_HALF_PERIOD          clk     = ~clk;
always #`RD_CLK_HALF_PERIOD       rd_clk  = ~rd_clk;

initial begin
  $dumpfile ("design.vcd");
  $dumpvars(0, tb_ppfifo);


  rst                           <= 0;
  `SLEEP_CLK(10);
  rst                           <= 1;
  `SLEEP_CLK(10);
  rst                           <= 0;
end

endmodule
