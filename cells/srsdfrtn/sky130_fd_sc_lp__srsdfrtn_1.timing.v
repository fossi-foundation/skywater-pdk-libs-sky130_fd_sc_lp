/*
 * Copyright 2020 The SkyWater PDK Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
*/


`ifndef SKY130_FD_SC_LP__SRSDFRTN_1_TIMING_V
`define SKY130_FD_SC_LP__SRSDFRTN_1_TIMING_V

/**
 * srsdfrtn: Scan flop with sleep mode, inverted reset, inverted
 *           clock, single output.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_dff_nr_pp_pkg_sn/sky130_fd_sc_lp__udp_dff_nr_pp_pkg_sn.v"
`include "../../models/udp_mux_2to1/sky130_fd_sc_lp__udp_mux_2to1.v"

`celldefine
module sky130_fd_sc_lp__srsdfrtn_1 (
    Q      ,
    CLK_N  ,
    D      ,
    SCD    ,
    SCE    ,
    RESET_B,
    SLEEP_B
);

    // Module ports
    output wire Q      ;
    input  wire CLK_N  ;
    input  wire D      ;
    input  wire SCD    ;
    input  wire SCE    ;
    input  wire RESET_B;
    input  wire SLEEP_B;

    // Module supplies
    supply1 KAPWR;
    supply1 VPWR ;
    supply0 VGND ;
    supply1 VPB  ;
    supply0 VNB  ;

    // Local signals
    wire RESET          ;
    wire mux_out        ;
    wire buf_Q          ;
    reg  notifier       ;
    wire D_delayed      ;
    wire SCD_delayed    ;
    wire SCE_delayed    ;
    wire RESET_B_delayed;
    wire CLK_N_delayed  ;
    wire awake          ;
    wire cond0          ;
    wire cond1          ;
    wire cond2          ;
    wire cond3          ;
    wire cond4          ;

    //                                    Name       Output   Other arguments
    not                                   not0      (RESET  , RESET_B_delayed                                                    );
    sky130_fd_sc_lp__udp_mux_2to1         mux_2to10 (mux_out, D_delayed, SCD_delayed, SCE_delayed                                );
    sky130_fd_sc_lp__udp_dff$NR_pp$PKG$sN dff0      (buf_Q  , mux_out, CLK_N_delayed, RESET, SLEEP_B, notifier, KAPWR, VGND, VPWR);
    assign awake = ( ( SLEEP_B === 1'b1 ) && awake );
    assign cond0 = ( ( RESET_B_delayed === 1'b1 ) && awake );
    assign cond1 = ( ( SCE_delayed === 1'b0 ) && cond0 && awake );
    assign cond2 = ( ( SCE_delayed === 1'b1 ) && cond0 && awake );
    assign cond3 = ( ( D_delayed !== SCD_delayed ) && cond0 && awake );
    assign cond4 = ( ( RESET_B === 1'b1 ) && awake );
    bufif1                                bufif10   (Q      , buf_Q, VPWR                                                        );

specify
(negedge RESET_B => (Q +: RESET_B ) ) = 0:0:0;  // delay is tris
(negedge CLK_N => (Q : CLK_N ) ) = (0:0:0,0:0:0); // delays are tris,tfall
$recrem ( posedge RESET_B , negedge CLK_N , 0:0:0, 0:0:0, notifier , awake , awake , RESET_B_delayed , CLK_N_delayed ) ;
$setuphold ( negedge CLK_N , posedge D , 0:0:0, 0:0:0, notifier , cond1 , cond1 , CLK_N_delayed , D_delayed ) ;
$setuphold ( negedge CLK_N , negedge D , 0:0:0, 0:0:0, notifier , cond1 , cond1 , CLK_N_delayed , D_delayed ) ;
$setuphold ( negedge CLK_N , posedge SCD , 0:0:0, 0:0:0, notifier , cond2 , cond2 , CLK_N_delayed , SCD_delayed ) ;
$setuphold ( negedge CLK_N , negedge SCD , 0:0:0, 0:0:0, notifier , cond2 , cond2 , CLK_N_delayed , SCD_delayed ) ;
$setuphold ( negedge CLK_N , posedge SCE , 0:0:0, 0:0:0, notifier , cond3 , cond3 , CLK_N_delayed , SCE_delayed ) ;
$setuphold ( negedge CLK_N , negedge SCE , 0:0:0, 0:0:0, notifier , cond3 , cond3 , CLK_N_delayed , SCE_delayed ) ;
$width (posedge CLK_N &&& cond4 , 1.0:1.0:1.0, 0, notifier);
$width (negedge CLK_N &&& cond4 , 1.0:1.0:1.0, 0, notifier);
$width (negedge RESET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
$width (posedge RESET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__SRSDFRTN_1_TIMING_V
