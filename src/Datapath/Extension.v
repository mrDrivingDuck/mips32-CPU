`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 12:41:38
// Design Name: 
// Module Name: Extension
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


module Extension(

    // 16 bit ����������
    input  [15: 0] imm16,
    
    // ����ѡ��
    input  [1 : 0] func_choice,
    
    // ��չ���
    output [31: 0] ext_result
    );
    
    /*
        func_choice == 00 : ������[15:0]16bit��������չ
        func_choice == 01 : �޷���[15:0]16bit��������չ
     // func_choice == 10 : ������[10:6]5bit��������չ
        func_choice == 11 : �޷���[10:6]5bit��������չ
    */
    assign ext_result = ( func_choice == 2'b00 ) ? { { 16{imm16[15]} }, imm16[15: 0] } :        // ������[15:0]16bit��������չ
                        ( func_choice == 2'b01 ) ? { { 16{1'b0} }     , imm16[15: 0] } :        // �޷���[15:0]16bit��������չ
                     // ( func_choice == 2'b10 ) ? { { 27{imm16[10]} }, imm16[10: 6] } :        // ������[10:6]5bit��������չ
                        ( func_choice == 2'b11 ) ? { { 27{1'b0}      }, imm16[10: 6] } :        // �޷���[10:6]5bit��������չ
                        32'b0;      // �����źŷǷ�
    
endmodule
