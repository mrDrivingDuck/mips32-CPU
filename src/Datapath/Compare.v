`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 13:00:22
// Design Name: 
// Module Name: Compare
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


module Compare(

    // ��������
    input  [31: 0] busA,
    input  [31: 0] busB,
    
    // ����ѡ��
    input  [2 : 0] func_choice,
    
    // ������
    output comp_result
    );
    
    /*
        ����ѡ��
            func_choice == 000 : �ж� busA �Ƿ� == busB
            func_choice == 001 : �ж� busA �Ƿ� != busB
            func_choice == 010 : �ж� busA �Ƿ� < busB
            func_choice == 011 : �ж� busA �Ƿ� > busB
            func_choice == 100 : �ж� busA �Ƿ� <= busB
            func_choice == 101 : �ж� busA �Ƿ� >= busB
            ��������ź�Ϊ�Ƿ�
            ֻ������һ�����
    */
    /*
        ��������
            �������� ��   ���1
            ���������� �� ���0
    */
    
    assign comp_result = ( (func_choice == 3'b000) & (busA == busB) )                          ? 1 :
                         ( (func_choice == 3'b001) & (busA != busB) )                          ? 1 :
                         ( (func_choice == 3'b010) & (busA[31] == 1'b1) )                      ? 1 :
                         ( (func_choice == 3'b011) & ( (busA > busB) & (busA[31] != 1'b1) ) )  ? 1 :
                         ( (func_choice == 3'b100) & ( (busA[31] == 1'b1) | (busA == busB) ) ) ? 1 :
                         ( (func_choice == 3'b101) & (busA[31] != 1'b1) )                      ? 1 :
                         0;
endmodule
