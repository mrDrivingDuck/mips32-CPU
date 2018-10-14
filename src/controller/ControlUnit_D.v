`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: �ڻ�
// 
// Create Date: 2017/06/18 14:32:20
// Design Name: 
// Module Name: ControlUnit_D
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


module ControlUnit_D(
    input [31:0]inst_D ,
    //����ָ��
    input RegWriEn ,
    //WB�׶�д���ź�
    input comp_result ,
    //����cmpareģ��ıȽϽ��
/*�������*/
    output [17:0] ID_control_bus , 
/*��������*/
    output [3:0] user_stall_bus ,
/*ת������*/
    output [1:0] user_bus_D ,
/*��֧Ԥ�����*/
    output [3:0] br_type_D  
    );
    //ȡָ�������
    wire [5:0] op ;
    wire [4:0] sa ;
    wire [5:0] funct ;
    wire [4:0] rs ;
    wire [4:0] rt ;
    wire [4:0] rd ;
    assign op = inst_D[31:26] ;
    assign sa = inst_D[10:6] ;
    assign funct = inst_D[5:0] ;
    assign rs = inst_D[25:21] ;
    assign rt = inst_D[20:16] ;
    assign rd = inst_D[15:11] ;
    //ʵ��ָ���б�
    wire inst_ADD , inst_ADDI , inst_ADDU , inst_ADDIU , inst_SUB , inst_SUBU ;
    wire inst_SLT , inst_SLTI , inst_SLTU , inst_SLTIU ;
    wire inst_DIV , inst_DIVU , inst_MULT , inst_MULTU ;
    wire inst_AND , inst_ANDI , inst_LUI , inst_NOR , inst_OR , inst_ORI , inst_XOR , inst_XORI ;
    wire inst_SLLV ,inst_SLL , inst_SRAV , inst_SRA , inst_SRLV , inst_SRL ;
    wire inst_BEQ , inst_BNE , inst_BGEZ , inst_BGTZ , inst_BLEZ , inst_BLTZ , inst_BGEZAL , inst_BLTZAL ;
    wire inst_J , inst_JAL , inst_JR , inst_JALR ;
    wire inst_MFHI , inst_MFLO , inst_MTHI , inst_MTLO ;
    wire inst_BREAK , inst_SYSCALL ;
    wire inst_LB , inst_LBU , inst_LH , inst_LHU , inst_LW , inst_SB , inst_SH ,inst_SW ;
    wire inst_ERET , inst_MFC0 , inst_MTC0 , inst_ZERO ;
    wire op_zero; // ������ȫ 0
    wire sa_zero; // sa ��ȫ 0
    assign op_zero = ~(|op);
    assign sa_zero = ~(|sa); 
    assign inst_ADD = op_zero & sa_zero & (funct == 6'b100000);//�з��żӷ�������������⣩
    assign inst_ADDI = (op == 6'b001000);//�з����������ӷ�������������⣩
    assign inst_ADDU = op_zero & sa_zero & (funct == 6'b100001);//�޷��żӷ�
    assign inst_ADDIU = (op == 6'b001001);//�޷����������ӷ�
    assign inst_SUB = op_zero & sa_zero & (funct == 6'b100010);//�з��ż���������������⣩
    assign inst_SUBU = op_zero & sa_zero & (funct == 6'b100011);//�޷��ż���
    assign inst_SLT = op_zero & sa_zero & (funct == 6'b101010);//С������λ
    assign inst_SLTI = (op == 6'b001010);//������С����λ
    assign inst_SLTU = op_zero & sa_zero & (funct == 6'b101011);//�޷���С����
    assign inst_SLTIU = (op == 6'b001011);//�������޷���С����λ
    assign inst_DIV = op_zero & sa_zero & (funct == 6'b011010) & (rd == 5'b0);//�з��ų���
    assign inst_DIVU = op_zero & sa_zero & (funct == 6'b011011) & (rd == 5'b0);//�޷��ų���
    assign inst_MULT = op_zero & sa_zero & (funct == 6'b011000) & (rd == 5'b0);//�з��ų˷�
    assign inst_MULTU = op_zero & sa_zero & (funct == 6'b011001) & (rd == 5'b0);//�޷��ų˷�
    assign inst_AND = op_zero & sa_zero & (funct == 6'b100100);//������
    assign inst_ANDI = (op == 6'b001100);//�������߼���
    assign inst_LUI = (op == 6'b001111) & (rs==5'd0);//������װ�ظ߰��ֽ� 
    assign inst_NOR = op_zero & sa_zero & (funct == 6'b100111);//�������
    assign inst_OR = op_zero & sa_zero & (funct == 6'b100101);//������
    assign inst_ORI = (op == 6'b001101);//�������߼���
    assign inst_XOR = op_zero & sa_zero & (funct == 6'b100110);//�������
    assign inst_XORI = (op == 6'b001110);//���������߼����
    assign inst_SLL = op_zero & (rs==5'd0) & (funct == 6'b000000);//�߼�����
    assign inst_SLLV = op_zero & sa_zero & (funct == 6'b000100);//�����߼�����
    assign inst_SRA = op_zero & (rs==5'd0) & (funct == 6'b000011);//��������
    assign inst_SRAV = op_zero & sa_zero & (funct == 6'b000111);//������������
    assign inst_SRL = op_zero & (rs==5'd0) & (funct == 6'b000010);//�߼�����
    assign inst_SRLV = op_zero & sa_zero & (funct == 6'b000110);//�����߼�����
    assign inst_BEQ = (op == 6'b000100); //�ж������ת
    assign inst_BNE = (op == 6'b000101); //�жϲ�����ת
    assign inst_BGEZ = (op == 6'b000001) & (rt==5'd1);//���ڵ��� 0 ��ת
    assign inst_BGTZ = (op == 6'b000111) & (rt==5'd0);//���� 0 ��ת
    assign inst_BLEZ = (op == 6'b000110) & (rt==5'd0);//С�ڵ��� 0 ��ת
    assign inst_BLTZ = (op == 6'b000001) & (rt==5'd0);//С�� 0 ��ת
    assign inst_BGEZAL = (op == 6'b000001) & (rt == 5'b10001);//���ڵ���0��ת�����ұ���PC+8
    assign inst_BLTZAL = (op == 6'b000001) & (rt == 5'b10000);//С��0��ת�����ұ���PC+8
    assign inst_J = (op == 6'b000010);//��������ת
    assign inst_JAL = (op == 6'b000011);//��������ת��������PC+8
    assign inst_JALR = op_zero & (rt==5'd0) & (rd==5'd31)
     & sa_zero & (funct == 6'b001001); //��ת�Ĵ���������
    assign inst_JR = op_zero & (rt==5'd0) & (rd==5'd0 )
     & sa_zero & (funct == 6'b001000); //��ת�Ĵ���
    assign inst_MFLO = op_zero & (rs==5'd0) & (rt==5'd0)
     & sa_zero & (funct == 6'b010010); //�� LO ��ȡ
    assign inst_MFHI = op_zero & (rs==5'd0) & (rt==5'd0)
     & sa_zero & (funct == 6'b010000); //�� HI ��ȡ
    assign inst_MTLO = op_zero & (rt==5'd0) & (rd==5'd0)
     & sa_zero & (funct == 6'b010011); //�� LO д����
    assign inst_MTHI = op_zero & (rt==5'd0) & (rd==5'd0)
     & sa_zero & (funct == 6'b010001); //�� HI д����
    assign inst_BREAK = (op == 6'b000000) & (funct == 6'b001101);//ϵͳ���ݣ��ϵ����⣩
    assign inst_SYSCALL = (op == 6'b000000) & (funct == 6'b001100);//SYSCALL��ϵͳ�������⣩
    assign inst_LB = (op == 6'b100000); //load �ֽڣ�������չ��
    assign inst_LBU = (op == 6'b100100); //load �ֽڣ��޷�����չ��
    assign inst_LH = (op == 6'b100001);//load���֣���ַ�����⣩
    assign inst_LHU = (op == 6'b100101);//load���֣�0��չ������ַ�����⣩
    assign inst_LW = (op == 6'b100011); //���ڴ�װ���֣���ַ�����⣩
    assign inst_SB = (op == 6'b101000); //���ڴ�洢�ֽ�
    assign inst_SH = (op == 6'b101001);//���ڴ�洢���֣���ַ�����⣩
    assign inst_SW = (op == 6'b101011); //���ڴ�洢�֣���ַ�����⣩
    assign inst_ERET = (op == 6'b010000) & (rs == 5'b10000) & (rt == 5'b0) & (rd == 5'b0) & sa_zero & (funct == 6'b011000);//ERET
    assign inst_MFC0 = (op == 6'b010000) & (rs == 5'b0) & sa_zero & (funct[5:3] == 3'b0);//��CP0ȡֵ
    assign inst_MTC0 = (op == 6'b010000) & (rs == 5'b00100) & sa_zero & (funct[5:3] == 3'b0);//��CP0��ֵ
    assign inst_ZERO = ( inst_D[31:0] == 32'b0) ;
/*��ת��֧��ָ�������begin*/
    wire [2:0] comp_func_choice ; 
    assign comp_func_choice = inst_BEQ ? 3'b000 :
                              inst_BNE ? 3'b001 :
                              inst_BLTZ | inst_BLTZAL ? 3'b010 :
                              inst_BGTZ ? 3'b011 :
                              inst_BLEZ ? 3'b100 :
                              inst_BGEZ | inst_BGEZAL ? 3'b101 : 3'b111 ; 
/*��ת��֧��ָ�������end*/

/*NPC������begin*/
    wire inst_j_ir ;//J��ָ���ַ����ָ�
    wire inst_br ;//br��ָ��
    wire br_taken ;//branch��ָ��Ŀ����ź�
    wire inst_j_rg ;//J��ָ���ַ���ԼĴ�����
    wire PCDSel ;
    wire jbr_taken ;
    wire j_taken ;
    wire npc_func_choice ;
    assign inst_j_ir = inst_J | inst_JAL  ;
    assign inst_j_rg = inst_JALR | inst_JR ;
    assign inst_br = inst_BEQ | inst_BNE | inst_BLTZ | inst_BLTZAL | inst_BGTZ | inst_BLEZ | inst_BGEZ | inst_BGEZAL ;
    assign npc_func_choice =  inst_j_ir ? 1'b1 : 1'b0 ;
    assign PCDSel = inst_j_rg ? 1'b1 : 1'b0 ;                   
    assign br_taken = inst_br & comp_result ;
    //ID->IF MPC�����ź�
    assign jbr_taken = (inst_br | inst_j_ir | inst_j_rg) ? 1'b1 : 1'b0 ;
    assign j_taken = inst_j_ir | inst_j_rg ;
/*NPC������end*/

/*Extensionģ������ź�begin*/
    wire inst_signext ;
    wire inst_zeroext ;
    wire [1:0] ext_func_choice ;
    assign inst_signext = inst_ADDI | inst_ADDIU | inst_SLTI | inst_SLTIU | inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW | inst_SB | inst_SH | inst_SW ;
    assign inst_zeroext = inst_ANDI | inst_ORI | inst_XORI | inst_LUI;
    /*Extension������*/
    assign ext_func_choice = inst_signext ? 2'b00 :
                             inst_zeroext ? 2'b01 :
                             inst_SLL | inst_SRA | inst_SRL ? 2'b11 : 2'b10 ;
/*Extensionģ������ź�end*/

/*ð����������ģ��begin*/
    //ָ�����
    wire cal_r ;//R��������ָ��
    wire di_mu ;//�˳�����ָ��
    wire cal_i ;//I��������ָ��
    wire br_rs_rt ;//��תָ�rs rt��
    wire br_rs ;//��תָ�rs��
    wire br_rs_al ;//��ת�����ӣ�rs 31��
    wire jr_rs ;//��������ת������(rs)
    wire jal_al ;//��������ת������(31)
    wire jalr_rs_al ;//��������ת������(rs 31)
    //wire mfhi , mflo , mfc0 , mthi , mtlo , mtc0 ;//����ת��ָ��
    wire load , store ;  //�ô�ָ��
    assign cal_r = inst_ADD | inst_ADDU | inst_SUB | inst_SUBU | inst_SLT | inst_SLTU | inst_AND | inst_NOR | inst_OR | inst_XOR | inst_SLLV
                 | inst_SLL | inst_SRAV | inst_SRA | inst_SRLV | inst_SRL ;
    assign di_mu = inst_DIV | inst_DIVU | inst_MULT | inst_MULTU ;
    assign cal_i = inst_ADDI | inst_ADDIU | inst_SLTI | inst_SLTIU | inst_ANDI | inst_ANDI | inst_LUI | inst_ORI | inst_XORI ;
    assign br_rs_rt = inst_BEQ | inst_BNE ;
    assign br_rs = inst_BGEZ | inst_BGTZ | inst_BLEZ | inst_BLTZ ;
    assign br_rs_al = inst_BGEZAL | inst_BLTZAL ;
    assign jr_rs = inst_JR ;
    assign jal_al = inst_JAL ;
    assign jalr_rs_al = inst_JALR ;
    //assign mfhi = inst_MFHI ;
    //assign mflo = inst_MFLO ;
    //assign mfc0 = inst_MFC0 ;
    //assign mthi = inst_MTHI ;
    //assign mtlo = inst_MTLO ;
    //assign mtc0 = inst_MTC0 ;
    assign load = inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW ;
    assign store = inst_SB | inst_SH | inst_SW ;   
    //ð��ָ�����
    wire use_rs_rt0_D ;
    wire use_rs_rt1_D ;
    wire use_rs0_D ;
    wire use_rs1_D ;
    assign use_rs_rt0_D = br_rs_rt ;
    assign use_rs_rt1_D = cal_r | di_mu ;
    assign use_rs0_D = br_rs | br_rs_al | jr_rs | jalr_rs_al ;
    assign use_rs1_D = cal_i | load | store ;
    //user_stall_bus
    assign user_stall_bus = {use_rs_rt0_D , use_rs_rt1_D , use_rs0_D ,use_rs1_D };
/*ð����������ģ��end*/ 

/*ת��ָ�����begin*/
    wire use_rs_D , use_rt_D ;
    assign use_rs_D = br_rs_rt| br_rs | br_rs_al | jr_rs | jalr_rs_al ;
    assign use_rt_D = br_rs_rt ;
    assign user_bus_D = {use_rs_D , use_rt_D };
/*ת��ָ�����end*/

/*D�׶�����ѡ���������ź�begin*/
    wire RFA2Sel ;
    wire PC4ESel ;
    assign RFA2Sel = inst_ADD | inst_ADDU | inst_SUB | inst_SUBU | inst_SLT | inst_SLTU | inst_DIV | inst_DIVU | inst_MULT | inst_MULTU
                     | inst_AND | inst_NOR | inst_OR | inst_XOR | inst_SLLV | inst_SLL | inst_SRAV | inst_SRA | inst_SRLV | inst_SRL 
                     | inst_BEQ | inst_BNE | inst_MTHI | inst_MTLO | inst_SB | inst_SH | inst_SW | inst_MTC0 ? 1'b0 : 1'b1 ;
    assign PC4ESel = inst_BREAK | inst_SYSCALL ? 1'b1 : 1'b0 ;
/*D�׶�����ѡ���������ź�end*/

/*����ָ�����begin*/
    wire reserve_inst_exc ;
    wire [2:0] Exception_bus ;
    //����ָ������
    assign reserve_inst_exc = inst_ADD | inst_ADDI | inst_ADDU | inst_ADDIU | inst_SUB | inst_SUBU |
                              inst_SLT | inst_SLTI | inst_SLTU | inst_SLTIU |
                              inst_DIV | inst_DIVU | inst_MULT | inst_MULTU |
                              inst_AND | inst_ANDI | inst_LUI | inst_NOR | inst_OR | inst_ORI | inst_XOR | inst_XORI |
                              inst_SLLV | inst_SLL | inst_SRAV | inst_SRA | inst_SRLV | inst_SRL |
                              inst_BEQ | inst_BNE | inst_BGEZ | inst_BGTZ | inst_BLEZ | inst_BLTZ | inst_BGEZAL | inst_BLTZAL |
                              inst_J | inst_JAL | inst_JR | inst_JALR |
                              inst_MFHI | inst_MFLO | inst_MTHI | inst_MTLO |
                              inst_BREAK | inst_SYSCALL |
                              inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW | inst_SB | inst_SH | inst_SW |
                              inst_ERET | inst_MFC0 | inst_MTC0 | inst_ZERO ? 1'b0 : 1'b1 ;
    //����ָ�����⣬ϵͳ�������⣬��������->����
    assign Exception_bus = {reserve_inst_exc , inst_BREAK, inst_SYSCALL };
/*����ָ�����end*/

/*D�׶�����ͨ·����*/
    assign ID_control_bus = { br_taken , j_taken , Exception_bus[2:0] ,store , load , jbr_taken ,RFA2Sel ,comp_func_choice[2:0] , npc_func_choice , PCDSel , ext_func_choice[1:0] , PC4ESel , RegWriEn };
/*��֧Ԥ������ź�*/
    assign br_type_D = inst_BEQ ? 4'b0000 :
                       inst_BNE ? 4'b0001 :
                       inst_BGEZ ? 4'b0010 :
                       inst_BGTZ ? 4'b0011 :
                       inst_BLEZ ? 4'b0100 :
                       inst_BLTZ ? 4'b0101 :
                       inst_BGEZAL ? 4'b0110 :
                       inst_BLTZAL ? 4'b0111 :
                        4'b1000 ; //others
endmodule
