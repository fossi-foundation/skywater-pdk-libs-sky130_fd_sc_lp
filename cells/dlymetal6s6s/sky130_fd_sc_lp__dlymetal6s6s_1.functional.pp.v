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


`ifndef SKY130_FD_SC_LP__DLYMETAL6S6S_1_FUNCTIONAL_PP_V
`define SKY130_FD_SC_LP__DLYMETAL6S6S_1_FUNCTIONAL_PP_V

/**
 * dlymetal6s6s: 6-inverter delay with output from 6th inverter on
 *               horizontal route.
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"

`celldefine
module sky130_fd_sc_lp__dlymetal6s6s_1 (
    X   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    // Module ports
    output wire X   ;
    input  wire A   ;
    input  wire VPWR;
    input  wire VGND;
    input  wire VPB ;
    input  wire VNB ;

    // Local signals
    wire buf0_out_X       ;
    wire pwrgood_pp0_out_X;

    //                                 Name         Output             Other arguments
    buf                                buf0        (buf0_out_X       , A                     );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_X, buf0_out_X, VPWR, VGND);
    buf                                buf1        (X                , pwrgood_pp0_out_X     );

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__DLYMETAL6S6S_1_FUNCTIONAL_PP_V
