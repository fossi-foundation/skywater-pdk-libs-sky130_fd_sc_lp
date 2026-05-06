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


`ifndef SKY130_FD_SC_LP__ISOLATCH_TIMING_PP_V
`define SKY130_FD_SC_LP__ISOLATCH_TIMING_PP_V

/**
 * isolatch: ????.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_isolatch_pp_pkg_sn/sky130_fd_sc_lp__udp_isolatch_pp_pkg_sn.v"

`celldefine
module sky130_fd_sc_lp__isolatch (
    Q      ,
    D      ,
    SLEEP_B,
    KAPWR  ,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);

    // Module ports
    output wire Q      ;
    input  wire D      ;
    input  wire SLEEP_B;
    input  wire KAPWR  ;
    input  wire VPWR   ;
    input  wire VGND   ;
    input  wire VPB    ;
    input  wire VNB    ;

    // Local signals
    wire buf_Q          ;
    wire SLEEP_B_delayed;
    wire D_delayed      ;
    reg  notifier       ;

    //                                      Name          Output  Other arguments
    sky130_fd_sc_lp__udp_isolatch_pp$PKG$sN isolatch_pp0 (buf_Q , D_delayed, SLEEP_B_delayed, notifier, KAPWR, VGND, VPWR);
    buf                                     buf0         (Q     , buf_Q                                                  );

specify
(D +=> Q ) = (0:0:0,0:0:0);  // delays are tris,tfall
(posedge SLEEP_B => (Q +: D ) ) = (0:0:0,0:0:0); // delays are tris,tfall
$width (posedge SLEEP_B , 0:0:0, 0, notifier);
$width (negedge SLEEP_B , 0:0:0, 0, notifier);
$setuphold ( negedge SLEEP_B , posedge D , 0:0:0, 0:0:0, notifier , , , SLEEPB_delayed , D_delayed ) ;
$setuphold ( negedge SLEEP_B , negedge D , 0:0:0, 0:0:0, notifier , , , SLEEPB_delayed , D_delayed ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__ISOLATCH_TIMING_PP_V
