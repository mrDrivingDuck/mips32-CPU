`timescale 1ns / 1ps
`define rs 25 : 21
`define rt 20 : 16
`define rd 15 : 11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: �ڻ�
// 
// Create Date: 2017/06/18 12:44:56
// Design Name: 
// Module Name: Stall_Control
// Project Name: 
// Target Devices: 
// Tool Versions: 4.0
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Stall_Control(
    input [31:0]IR_D , [31:0]IR_E , [31:0]IR_M ,
    //����D ��E��M�׶ε�ָ��
    input [3:0] user_stall_bus_D ,
    //D�׶������ṩ����
    input [3:0] wrback_stall_bus_E ,
    //E�׶������ṩ����
    input [1:0] wrback_stall_bus_M ,
    //M�׶������ṩ����
    input [1:0] datapath_M_bus ,
    //M�׶�����ͨ·����
    /*
        0 valid_2
        1 load
    */
    output stall_D
    //��������ź�
    );
    wire use_rs_rt0_D ;//D�׶���Ҫ�õ�rs ��rt��ָ���br_rs_rt��, Tuse = 0
    wire use_rs_rt1_D ;//D�׶���Ҫ�õ�rs��rt��ָ�(cal_r | di/mu) , Tuse = 1
    wire use_rs0_D ;//D�׶���Ҫ�õ�rs��ָ���br_rs | br_rs_al | jr_rs | jalr_rs_al����Tuse = 0
    wire use_rs1_D ;//D�׶���Ҫ�õ�rs��ָ�(cal_i | load | store) , Tuse = 1
    
    assign use_rs_rt0_D = user_stall_bus_D[3] ;
    assign use_rs_rt1_D = user_stall_bus_D[2] ;
    assign use_rs0_D = user_stall_bus_D[1] ;
    assign use_rs1_D = user_stall_bus_D[0] ;
    
    wire wrback_rd2_E ;//E�׶����ջ�д��rd��ָ�(mfhi | mflo), Tnew = 2
    wire wrback_rt2_E ;//E�׶����ջ�д��rt��ָ�(load , mfc0) , Tnew = 2  
    wire wrback_rd12_E ;//E�׶���Ҫд��rd��ָ���mfhi | mflo | cal_r����Tnew = 1 , 2
    wire wrback_rt12_E ;//E�׶���Ҫд��rt��ָ���load | mfc0 | cal_i����Tnew = 1 , 2
    
    assign wrback_rd2_E = wrback_stall_bus_E[3] ;
    assign wrback_rt2_E = wrback_stall_bus_E[2] ;
    assign wrback_rd12_E = wrback_stall_bus_E[1] ;
    assign wrback_rt12_E = wrback_stall_bus_E[0] ;
    
    wire wrback_rd1_M ;//M�׶���Ҫд��rd��ָ���mfhi | mflo����Tnew = 1
    wire wrback_rt1_M ;//M�׶���Ҫд��rt��ָ���load | mfc0����Tnew = 1
    
    assign wrback_rd1_M = wrback_stall_bus_M[1] ;
    assign wrback_rt1_M = wrback_stall_bus_M[0] ;
    
    wire stall_use_rs_rt1 ;
    //cal_r , di/mu ��ָ����D�׶ε�����
    assign stall_use_rs_rt1 = use_rs_rt1_D & 
        ((wrback_rd2_E & (IR_D[`rs] == IR_E[`rd] | IR_D[`rt] == IR_E[`rd]) & (IR_E[`rd] != 5'b0))
        | (wrback_rt2_E & (IR_D[`rs] == IR_E[`rt] | IR_D[`rt] == IR_E[`rt])& (IR_E[`rt] != 5'b0))
        | (~datapath_M_bus[0] & datapath_M_bus[1] & (IR_D[`rs] == IR_M[`rt] | IR_D[`rt] == IR_M[`rt])& (IR_M[`rt] != 5'b0)));
    wire stall_use_rs1 ;
    //cal_i | load | store��ָ����D�׶ε�����
    assign stall_use_rs1 = use_rs1_D &
        ((wrback_rd2_E & (IR_D[`rs] == IR_E[`rd])& (IR_E[`rd] != 5'b0))
        |(wrback_rt2_E & (IR_D[`rs] == IR_E[`rt])& (IR_E[`rt] != 5'b0))
        | (~datapath_M_bus[0] & datapath_M_bus[1] & (IR_D[`rs] == IR_M[`rt])& (IR_M[`rt] != 5'b0)));
    wire stall_use_rs_rt0 ;
    // br_rs_rt��ָ����D�׶ε�����
    assign stall_use_rs_rt0 = use_rs_rt0_D &
        ((wrback_rd12_E & (IR_D[`rs] == IR_E[`rd] | IR_D[`rt] == IR_E[`rd])& (IR_E[`rd] != 5'b0))
        | (wrback_rt12_E & (IR_D[`rs] == IR_E[`rt] | IR_D[`rt] == IR_E[`rt])& (IR_E[`rt] != 5'b0))
        | (wrback_rd1_M & (IR_D[`rs] == IR_M[`rd] | IR_D[`rt] == IR_M[`rd])& (IR_M[`rd] != 5'b0))
        | (wrback_rt1_M & (IR_D[`rs] == IR_M[`rt] | IR_D[`rt] == IR_M[`rt])& (IR_M[`rt] != 5'b0)));
    wire stall_use_rs0 ;
    //br_rs | br_rs_al | jr_rs | jalr_rs_al��ָ����D�׶ε�����
    assign stall_use_rs0 = use_rs0_D &
        ((wrback_rd12_E & (IR_D[`rs] == IR_E[`rd])& (IR_E[`rd] != 5'b0))
            | (wrback_rt12_E & (IR_D[`rs] == IR_E[`rt])& (IR_E[`rt] != 5'b0))
            | (wrback_rd1_M & (IR_D[`rs] == IR_M[`rd])& (IR_M[`rd] != 5'b0))
            | (wrback_rt1_M & (IR_D[`rs] == IR_M[`rt])& (IR_M[`rt] != 5'b0)));   
    //�������ź�
    assign stall_D = stall_use_rs_rt1 | stall_use_rs1 | stall_use_rs_rt0 | stall_use_rs0 ;
    
endmodule










