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


`ifndef SKY130_FD_SC_LP__SRSDFSTP_1_TIMING_PP_V
`define SKY130_FD_SC_LP__SRSDFSTP_1_TIMING_PP_V

/**
 * srsdfstp: Scan flop with sleep mode, inverted set, non-inverted
 *           clock, single output.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_mux_2to1/sky130_fd_sc_lp__udp_mux_2to1.v"
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"
`include "../../models/udp_dff_ps_pp_pkg_sn/sky130_fd_sc_lp__udp_dff_ps_pp_pkg_sn.v"

`celldefine
module sky130_fd_sc_lp__srsdfstp_1 (
    Q      ,
    CLK    ,
    D      ,
    SCD    ,
    SCE    ,
    SET_B  ,
    SLEEP_B,
    KAPWR  ,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);

    // Module ports
    output wire Q      ;
    input  wire CLK    ;
    input  wire D      ;
    input  wire SCD    ;
    input  wire SCE    ;
    input  wire SET_B  ;
    input  wire SLEEP_B;
    input  wire KAPWR  ;
    input  wire VPWR   ;
    input  wire VGND   ;
    input  wire VPB    ;
    input  wire VNB    ;

    // Local signals
    wire SET              ;
    wire mux_out          ;
    wire buf_Q            ;
    reg  notifier         ;
    wire D_delayed        ;
    wire SCD_delayed      ;
    wire SCE_delayed      ;
    wire SET_B_delayed    ;
    wire CLK_delayed      ;
    wire awake            ;
    wire cond0            ;
    wire cond1            ;
    wire cond2            ;
    wire cond3            ;
    wire cond4            ;
    wire pwrgood_pp0_out_Q;

    //                                    Name         Output             Other arguments
    not                                   not0        (SET              , SET_B_delayed                                                  );
    sky130_fd_sc_lp__udp_mux_2to1         mux_2to10   (mux_out          , D_delayed, SCD_delayed, SCE_delayed                            );
    sky130_fd_sc_lp__udp_dff$PS_pp$PKG$sN dff0        (buf_Q            , mux_out, CLK_delayed, SET, SLEEP_B, notifier, KAPWR, VGND, VPWR);
    assign awake = ( ( SLEEP_B === 1'b1 ) && awake );
    assign cond0 = ( ( SET_B_delayed === 1'b1 ) && awake );
    assign cond1 = ( ( SCE_delayed === 1'b0 ) && cond0 && awake );
    assign cond2 = ( ( SCE_delayed === 1'b1 ) && cond0 && awake );
    assign cond3 = ( ( D_delayed !== SCD_delayed ) && cond0 && awake );
    assign cond4 = ( ( SET_B === 1'b1 ) && awake );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG    pwrgood_pp0 (pwrgood_pp0_out_Q, buf_Q, VPWR, VGND                                              );
    buf                                   buf0        (Q                , pwrgood_pp0_out_Q                                              );

specify
(negedge SET_B => (Q -: SET_B ) ) = 0:0:0;  // delay is tris
(posedge CLK => (Q : CLK ) ) = (0:0:0,0:0:0); // delays are tris,tfall
$recrem ( posedge SET_B , posedge CLK , 0:0:0, 0:0:0, notifier , awake , awake , SET_B_delayed , CLK_delayed ) ;
$setuphold ( posedge CLK , posedge D , 0:0:0, 0:0:0, notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , negedge D , 0:0:0, 0:0:0, notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , posedge SCD , 0:0:0, 0:0:0, notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , negedge SCD , 0:0:0, 0:0:0, notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , posedge SCE , 0:0:0, 0:0:0, notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$setuphold ( posedge CLK , negedge SCE , 0:0:0, 0:0:0, notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$width (posedge CLK &&& cond4 , 1.0:1.0:1.0, 0, notifier);
$width (negedge CLK &&& cond4 , 1.0:1.0:1.0, 0, notifier);
$width (negedge SET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
$width (posedge SET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__SRSDFSTP_1_TIMING_PP_V
