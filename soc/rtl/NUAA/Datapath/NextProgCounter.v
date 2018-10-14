`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 13:24:04
// Design Name: 
// Module Name: NextProgCounter
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


module NextProgCounter(

    // �ӳٲ�PC����
    input  [31: 0] add4,
    
    // ָ���26bit����
    input  [25: 0] imm26,
    
    // ����ѡ��
    input  func_choice,
    
    // ��һPC���
    output [31:0] next_pc
    
    );
    
    /*
        ����ѡ��
            func_choice == 0 : Branch��ָ��
            func_choice == 1 : Jump��ָ��
    */
    
    assign next_pc = (func_choice == 0) ? ( add4 + { {14{imm26[15]} }, imm26[15:0], 2'b00} ) :      // Branch��npc����
                     (func_choice == 1) ? { add4[31:28]              , imm26[25:0], 2'b00}   :      // Jump��npc����
                     0;
    
endmodule
