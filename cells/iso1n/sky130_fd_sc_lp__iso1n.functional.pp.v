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


`ifndef SKY130_FD_SC_LP__ISO1N_FUNCTIONAL_PP_V
`define SKY130_FD_SC_LP__ISO1N_FUNCTIONAL_PP_V

/**
 * iso1n: ????.
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_lp__udp_pwrgood_pp_pg.v"

`celldefine
module sky130_fd_sc_lp__iso1n (
    X      ,
    A      ,
    SLEEP_B,
    VPWR   ,
    KAGND  ,
    VPB    ,
    VNB
);

    // Module ports
    output X      ;
    input  A      ;
    input  SLEEP_B;
    input  VPWR   ;
    input  KAGND  ;
    input  VPB    ;
    input  VNB    ;

    // Local signals
    wire SLEEP                ;
    wire pwrgood_pp0_out_A    ;
    wire pwrgood_pp1_out_SLEEP;

    //                                 Name         Output                 Other arguments
    not                                not0        (SLEEP                , SLEEP_B                                 );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_A    , A, VPWR, KAGND                          );
    sky130_fd_sc_lp__udp_pwrgood_pp$PG pwrgood_pp1 (pwrgood_pp1_out_SLEEP, SLEEP, VPWR, KAGND                      );
    or                                 or0         (X                    , pwrgood_pp0_out_A, pwrgood_pp1_out_SLEEP);

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__ISO1N_FUNCTIONAL_PP_V
