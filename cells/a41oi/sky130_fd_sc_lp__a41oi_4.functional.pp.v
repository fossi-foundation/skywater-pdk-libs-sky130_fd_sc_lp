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


`ifndef SKY130_FD_SC_LP__A41OI_4_FUNCTIONAL_PP_V
`define SKY130_FD_SC_LP__A41OI_4_FUNCTIONAL_PP_V

/**
 * a41oi: 4-input AND into first input of 2-input NOR.
 *
 *        Y = !((A1 & A2 & A3 & A4) | B1)
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"

`celldefine
module sky130_fd_sc_lp__a41oi_4 (
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    A4  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    // Module ports
    output wire Y   ;
    input  wire A1  ;
    input  wire A2  ;
    input  wire A3  ;
    input  wire A4  ;
    input  wire B1  ;
    input  wire VPWR;
    input  wire VGND;
    input  wire VPB ;
    input  wire VNB ;

    // Local signals
    wire and0_out         ;
    wire nor0_out_Y       ;
    wire pwrgood_pp0_out_Y;

    //                                 Name         Output             Other arguments
    and                                and0        (and0_out         , A1, A2, A3, A4        );
    nor                                nor0        (nor0_out_Y       , B1, and0_out          );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_Y, nor0_out_Y, VPWR, VGND);
    buf                                buf0        (Y                , pwrgood_pp0_out_Y     );

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__A41OI_4_FUNCTIONAL_PP_V
