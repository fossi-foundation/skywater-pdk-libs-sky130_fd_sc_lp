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


`ifndef SKY130_FD_SC_LP__SRDLSTP_1_TIMING_PP_V
`define SKY130_FD_SC_LP__SRDLSTP_1_TIMING_PP_V

/**
 * srdlstp: ????.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_dlatch_psa_pp_pkg_sn/sky130_fd_sc_lp__udp_dlatch_psa_pp_pkg_sn.v"

`celldefine
module sky130_fd_sc_lp__srdlstp_1 (
    Q      ,
    SET_B  ,
    D      ,
    GATE   ,
    SLEEP_B,
    KAPWR  ,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);

    // Module ports
    output wire Q      ;
    input  wire SET_B  ;
    input  wire D      ;
    input  wire GATE   ;
    input  wire SLEEP_B;
    input  wire KAPWR  ;
    input  wire VPWR   ;
    input  wire VGND   ;
    input  wire VPB    ;
    input  wire VNB    ;

    // Local signals
    wire buf_Q        ;
    reg  notifier     ;
    wire D_delayed    ;
    wire GATE_delayed ;
    wire reset_delayed;
    wire SET_B_delayed;
    wire awake        ;
    wire cond0        ;
    wire cond1        ;

    //                                        Name     Output  Other arguments
    sky130_fd_sc_lp__udp_dlatch$PSa_pp$PKG$sN dlatch0 (buf_Q , D_delayed, GATE_delayed, SET_B_delayed, SLEEP_B, notifier, KAPWR, VGND, VPWR);
    assign awake = ( SLEEP_B === 1'b1 );
    assign cond0 = ( awake && ( SET_B_delayed === 1'b1 ) );
    assign cond1 = ( awake && ( SET_B === 1'b1 ) );
    bufif1                                    bufif10 (Q     , buf_Q, VPWR                                                                 );

specify
if ((!GATE)) (negedge SET_B => (Q -: SET_B ) ) = (0:0:0,0:0:0);  // delay is tfall
ifnone ( SET_B -=> Q ) = (0:0:0,0:0:0);
(D +=> Q ) = (0:0:0,0:0:0);  // delays are tris,tfall
(posedge GATE => (Q +: D ) ) = (0:0:0,0:0:0); // delays are tris,tfall
$width ( posedge GATE &&& cond1 , 1.0:1.0:1.0, 0, notifier);
$width ( negedge GATE &&& cond1 , 1.0:1.0:1.0, 0, notifier);
$recrem ( posedge SET_B , negedge GATE , 0:0:0, 0:0:0, notifier , awake , awake , SET_B_delayed , GATE_delayed ) ;
$setuphold ( negedge GATE , posedge D , 0:0:0, 0:0:0, notifier , cond0 , cond0 , GATE_delayed , D_delayed ) ;
$setuphold ( negedge GATE , negedge D , 0:0:0, 0:0:0, notifier , cond0 , cond0 , GATE_delayed , D_delayed ) ;
$width (negedge SET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
$width (posedge SET_B &&& awake , 1.0:1.0:1.0 , 0 , notifier);
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__SRDLSTP_1_TIMING_PP_V
