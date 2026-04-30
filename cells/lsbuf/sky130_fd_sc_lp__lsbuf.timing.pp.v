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


`ifndef SKY130_FD_SC_LP__LSBUF_TIMING_PP_V
`define SKY130_FD_SC_LP__LSBUF_TIMING_PP_V

/**
 * lsbuf: ????.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"

`celldefine
module sky130_fd_sc_lp__lsbuf (
    X      ,
    A      ,
    DESTPWR,
    VPWR   ,
    VGND   ,
    DESTVPB,
    VPB    ,
    VNB
);

    // Module ports
    output wire X      ;
    input  wire A      ;
    input  wire DESTPWR;
    input  wire VPWR   ;
    input  wire VGND   ;
    input  wire DESTVPB;
    input  wire VPB    ;
    input  wire VNB    ;

    // Local signals
    wire pwrgood_pp0_out_A;
    wire buf0_out_X       ;

    //                                 Name         Output             Other arguments
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_A, A, VPWR, VGND            );
    buf                                buf0        (buf0_out_X       , pwrgood_pp0_out_A        );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp1 (X                , buf0_out_X, DESTPWR, VGND);

specify
(A +=> X) = (0:0:0,0:0:0);
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__LSBUF_TIMING_PP_V
