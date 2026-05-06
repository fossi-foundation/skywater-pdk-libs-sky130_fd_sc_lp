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


`ifndef SKY130_FD_SC_LP__AND4_2_FUNCTIONAL_PP_V
`define SKY130_FD_SC_LP__AND4_2_FUNCTIONAL_PP_V

/**
 * and4: 4-input AND.
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"

`celldefine
module sky130_fd_sc_lp__and4_2 (
    X   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    // Module ports
    output wire X   ;
    input  wire A   ;
    input  wire B   ;
    input  wire C   ;
    input  wire D   ;
    input  wire VPWR;
    input  wire VGND;
    input  wire VPB ;
    input  wire VNB ;

    // Local signals
    wire and0_out_X       ;
    wire pwrgood_pp0_out_X;

    //                                 Name         Output             Other arguments
    and                                and0        (and0_out_X       , A, B, C, D            );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_X, and0_out_X, VPWR, VGND);
    buf                                buf0        (X                , pwrgood_pp0_out_X     );

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__AND4_2_FUNCTIONAL_PP_V
