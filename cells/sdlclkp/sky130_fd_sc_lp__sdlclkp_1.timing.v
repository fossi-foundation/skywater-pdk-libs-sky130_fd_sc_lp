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


`ifndef SKY130_FD_SC_LP__SDLCLKP_1_TIMING_V
`define SKY130_FD_SC_LP__SDLCLKP_1_TIMING_V

/**
 * sdlclkp: Scan gated clock.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_dlatch_p_pp_pg_n/sky130_fd_sc_lp__udp_dlatch_p_pp_pg_n.v"

`celldefine
module sky130_fd_sc_lp__sdlclkp_1 (
    GCLK,
    SCE ,
    GATE,
    CLK
);

    // Module ports
    output wire GCLK;
    input  wire SCE ;
    input  wire GATE;
    input  wire CLK ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire m0              ;
    wire m0n             ;
    wire clkn            ;
    wire CLK_delayed     ;
    wire SCE_delayed     ;
    wire GATE_delayed    ;
    wire SCE_gate_delayed;
    reg  notifier        ;

    //                                    Name     Output            Other arguments
    not                                   not0    (m0n             , m0                                          );
    not                                   not1    (clkn            , CLK_delayed                                 );
    nor                                   nor0    (SCE_gate_delayed, GATE_delayed, SCE_delayed                   );
    sky130_fd_sc_lp__udp_dlatch$P_pp$PG$N dlatch0 (m0              , SCE_gate_delayed, clkn, notifier, VPWR, VGND);
    and                                   and0    (GCLK            , m0n, CLK_delayed                            );

specify
(CLK +=> GCLK) = (0:0:0,0:0:0);                         // delays are tris,tfall
$width (posedge CLK , 0:0:0, 0, notifier);
$width (negedge CLK , 0:0:0, 0, notifier);
$setuphold ( posedge CLK , posedge SCE , 0:0:0, 0:0:0, notifier , , , CLK_delayed , SCE_delayed ) ;
$setuphold ( posedge CLK , negedge SCE , 0:0:0, 0:0:0, notifier , , , CLK_delayed , SCE_delayed ) ;
$setuphold ( posedge CLK , posedge GATE , 0:0:0, 0:0:0, notifier , , , CLK_delayed , GATE_delayed ) ;
$setuphold ( posedge CLK , negedge GATE , 0:0:0, 0:0:0, notifier , , , CLK_delayed , GATE_delayed ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__SDLCLKP_1_TIMING_V
