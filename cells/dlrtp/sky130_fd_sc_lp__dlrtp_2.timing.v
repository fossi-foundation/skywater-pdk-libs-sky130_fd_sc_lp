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


`ifndef SKY130_FD_SC_LP__DLRTP_2_TIMING_V
`define SKY130_FD_SC_LP__DLRTP_2_TIMING_V

/**
 * dlrtp: Delay latch, inverted reset, non-inverted enable,
 *        single output.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_dlatch_pr_pp_pg_n/sky130_fd_sc_lp__udp_dlatch_pr_pp_pg_n.v"

`celldefine
module sky130_fd_sc_lp__dlrtp_2 (
    Q      ,
    RESET_B,
    D      ,
    GATE
);

    // Module ports
    output Q      ;
    input  RESET_B;
    input  D      ;
    input  GATE   ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire RESET          ;
    reg  notifier       ;
    wire cond0          ;
    wire D_delayed      ;
    wire GATE_delayed   ;
    wire RESET_delayed  ;
    wire RESET_B_delayed;
    wire buf_Q          ;

    //                                     Name     Output  Other arguments
    not                                    not0    (RESET , RESET_B_delayed                                     );
    sky130_fd_sc_lp__udp_dlatch$PR_pp$PG$N dlatch0 (buf_Q , D_delayed, GATE_delayed, RESET, notifier, VPWR, VGND);
    assign cond0 = ( RESET_B_delayed === 1'b1 );
    buf                                    buf0    (Q     , buf_Q                                               );

specify
(negedge RESET_B => (Q +: RESET_B ) ) = (0:0:0,0:0:0);  // delay is tfall
(D +=> Q ) = (0:0:0,0:0:0);  // delays are tris,tfall
(posedge GATE => (Q : GATE ) ) = (0:0:0,0:0:0); // delays are tris,tfall
$width ( posedge GATE &&& (RESET_B===1'b1) , 0:0:0, 0, notifier);
$width ( negedge GATE &&& (RESET_B===1'b1) , 0:0:0, 0, notifier);
$recrem ( posedge RESET_B , negedge GATE , 0:0:0, 0:0:0, notifier , , , RESET_B_delayed , GATE_delayed ) ;
$setuphold ( negedge GATE , posedge D , 0:0:0, 0:0:0, notifier , , cond0 , GATE_delayed , D_delayed ) ;
$setuphold ( negedge GATE , negedge D , 0:0:0, 0:0:0, notifier , , cond0 , GATE_delayed , D_delayed ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__DLRTP_2_TIMING_V
