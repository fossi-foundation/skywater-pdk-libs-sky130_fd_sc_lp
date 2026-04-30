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


`ifndef SKY130_FD_SC_LP__SREGSBP_1_TIMING_PP_V
`define SKY130_FD_SC_LP__SREGSBP_1_TIMING_PP_V

/**
 * sregsbp: ????.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_dff_ps_pp_pg_n/sky130_fd_sc_lp__udp_dff_ps_pp_pg_n.v"
`include "../../models/udp_mux_2to1/sky130_fd_sc_lp__udp_mux_2to1.v"

`celldefine
module sky130_fd_sc_lp__sregsbp_1 (
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    SCD  ,
    SCE  ,
    ASYNC,
    VPWR ,
    VGND ,
    VPB  ,
    VNB
);

    // Module ports
    output wire Q    ;
    output wire Q_N  ;
    input  wire CLK  ;
    input  wire D    ;
    input  wire SCD  ;
    input  wire SCE  ;
    input  wire ASYNC;
    input  wire VPWR ;
    input  wire VGND ;
    input  wire VPB  ;
    input  wire VNB  ;

    // Local signals
    wire buf_Q        ;
    wire set          ;
    wire mux_out      ;
    reg  notifier     ;
    wire D_delayed    ;
    wire SCD_delayed  ;
    wire SCE_delayed  ;
    wire ASYNC_delayed;
    wire CLK_delayed  ;
    wire awake        ;
    wire cond0        ;
    wire cond1        ;
    wire cond2        ;
    wire cond3        ;
    wire cond4        ;

    //                                  Name       Output   Other arguments
    not                                 not0      (set    , ASYNC_delayed                                  );
    sky130_fd_sc_lp__udp_mux_2to1       mux_2to10 (mux_out, D_delayed, SCD_delayed, SCE_delayed            );
    sky130_fd_sc_lp__udp_dff$PS_pp$PG$N dff0      (buf_Q  , mux_out, CLK_delayed, set, notifier, VPWR, VGND);
    assign awake = ( VPWR === 1'b1 );
    assign cond0 = ( ( ASYNC_delayed === 1'b1 ) && awake );
    assign cond1 = ( ( SCE_delayed === 1'b0 ) && cond0 );
    assign cond2 = ( ( SCE_delayed === 1'b1 ) && cond0 );
    assign cond3 = ( ( D_delayed !== SCD_delayed ) && cond0 );
    assign cond4 = ( ( ASYNC === 1'b1 ) && awake );
    buf                                 buf0      (Q      , buf_Q                                          );
    not                                 not1      (Q_N    , buf_Q                                          );

specify
( negedge ASYNC => ( Q -: ASYNC ) ) = 0:0:0 ;  // delay is tris
( negedge ASYNC => ( Q_N +: ASYNC ) ) = 0:0:0 ;  // delay is tris
( posedge CLK => ( Q : CLK ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
( posedge CLK => ( Q_N : CLK ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
$recrem ( posedge ASYNC , posedge CLK , 0:0:0 , 0:0:0 , notifier , awake , awake , ASYNC_delayed , CLK_delayed ) ;
$setuphold ( posedge CLK , posedge D , 0:0:0 , 0:0:0 , notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , negedge D , 0:0:0 , 0:0:0 , notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , posedge SCD , 0:0:0 , 0:0:0 , notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , negedge SCD , 0:0:0 , 0:0:0 , notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , posedge SCE , 0:0:0 , 0:0:0 , notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$setuphold ( posedge CLK , negedge SCE , 0:0:0 , 0:0:0 , notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$width ( posedge CLK &&& cond4 , 1.0:1.0:1.0 , 0 , notifier ) ;
$width ( negedge CLK &&& cond4 , 1.0:1.0:1.0 , 0 , notifier ) ;
$width ( negedge ASYNC &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
$width ( posedge ASYNC &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__SREGSBP_1_TIMING_PP_V
