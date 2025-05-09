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


`ifndef SKY130_FD_SC_LP__BUSDRIVERNOVLPSLEEP_20_FUNCTIONAL_PP_V
`define SKY130_FD_SC_LP__BUSDRIVERNOVLPSLEEP_20_FUNCTIONAL_PP_V

/**
 * busdrivernovlpsleep: Bus driver, enable gates pulldown only,
 *                      non-inverted sleep input (on kapwr rail).
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

`celldefine
module sky130_fd_sc_lp__busdrivernovlpsleep_20 (
    Z    ,
    A    ,
    TE_B ,
    SLEEP,
    VPWR ,
    VGND ,
    KAPWR,
    VPB  ,
    VNB
);

    // Module ports
    output Z    ;
    input  A    ;
    input  TE_B ;
    input  SLEEP;
    input  VPWR ;
    input  VGND ;
    input  KAPWR;
    input  VPB  ;
    input  VNB  ;

    // Local signals
    wire nor_teb_SLEEP;
     // No contents.
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_LP__BUSDRIVERNOVLPSLEEP_20_FUNCTIONAL_PP_V
