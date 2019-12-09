  	AREA    appcode ,CODE,READONLY
	IMPORT printMsg1
	IMPORT printMsg2
	IMPORT printMsg3
	IMPORT printMsg4
	IMPORT printMsg5
	IMPORT printMsg4p
    EXPORT __main
    ENTRY
__main    FUNCTION
	MOV R4,#1; Counter 	
    MOV R5,#25; for storing the Number of Terms in Series
        
				
	VLDR.F32 S0,=1 ;   
	VLDR.F32 S1,=1; 
	VLDR.F32 S6,=1; 
	
	VLDR.F32 S4,=1;
	VLDR.F32 S25,=0.5; S25=0.5 FOR COMPARISION 

;values accorfing to data given in python file

AND	BL printMsg1
	VLDR.F32 S7,=-0.1  
	VLDR.F32 S8,=0.2
	VLDR.F32 S9,=0.2
	VLDR.F32 S10,=-0.2
	B compute
		
OR	BL printMsg2
	VLDR.F32 S7,=-0.1  
	VLDR.F32 S8,=0.7
	VLDR.F32 S9,=0.7
	VLDR.F32 S10,=-0.1
	B compute
		
NOT	BL printMsg3
	VLDR.F32 S7,=0.5  
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=0
	VLDR.F32 S10,=0.1
	B compute
		
NAND	BL printMsg4
	VLDR.F32 S7,=0.6  
	VLDR.F32 S8,=-0.8
	VLDR.F32 S9,=-0.8
	VLDR.F32 S10,=0.3
	B compute
		
NOR	BL printMsg5
	VLDR.F32 S7,=0.5  
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=-0.7
	VLDR.F32 S10,=0.1
	B compute
		
		
compute	BL Set1
;input and their conversion to store in FPU registers
Set1		MOV R0, #1; input A 
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16 
			MOV R1, #0; input B 
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17 
			MOV R2, #0; input C 
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18
			B WEIGHT
			
Set2		MOV R0, #1; input A 
			VMOV.F32 S16,R0 
			VCVT.F32.S32 S16,S16
			MOV R1, #0; input B 
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17
			MOV R2, #1; input C 
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18
			B WEIGHT
			
Set3		MOV R0, #1; input A 
			VMOV.F32 S16,R0 
			VCVT.F32.S32 S16,S16
			MOV R1, #1; input B 
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17
			MOV R2, #0; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18
			B WEIGHT
			
Set4		MOV R0, #1; input A 
			VMOV.F32 S16,R0
			VCVT.F32.S32 S16,S16
			MOV R1, #1; input B 
			VMOV.F32 S17, R1
			VCVT.F32.S32 S17,S17
			MOV R2, #1; input C
			VMOV.F32 S18,R2
			VCVT.F32.S32 S18,S18
			B WEIGHT

WEIGHT				VMUL.F32 S19,S7,S16;
					VMOV.F32 S22,S19
					VMUL.F32 S20,S8,S17
					VADD.F32 S22, S22, S20
					VMUL.F32 S21,S9,S18
					VADD.F32 S22, S22, S21
					VADD.F32 S22, S22, S10; 		
					B exp
				
exp   CMP R4,R5; 	Compare i and n 
      BLE repeat; 	if i is less than n jump to repeat
      B sigmoid;		else jump to sigmoid 
		
repeat  VMUL.F32 S1,S1,S22; temp = temp*x
		VMOV.F32 S3,S1;
		VMOV.F32 S5,R4; 	
		VCVT.F32.S32 S5, S5;	
		
	VMUL.F32 S6,S6,S5;	
    VDIV.F32 S3,S3,S6;	
    VADD.F32 S0,S0,S3;	
		
    ADD R4,R4,#1;	
    B exp;	

sigmoid 
	VADD.F32 S14,S4,S0 ;	1 + e^x
	VDIV.F32 S15,S0,S14;	e^x/(1+e^x)
	VCMP.F32 S15,S25;	Comparing the result with 0.5
	VMRS.F32 APSR_NZCV, FPSCR
	ITE HI
	MOVHI R3,#1
	MOVLS R3,#0
	BL printMsg4p
	
	
	
	MOV R4,#1
	VLDR.F32 S0,=1 ;  
	VLDR.F32 S1,=1; 
	VLDR.F32 S6,=1; 

	; for changing inputs
	ADD R9, R9,#1
	CMP R9,#1
	BEQ Set2
	CMP R9,#2
	BEQ Set3
	CMP R9,#3
	BEQ Set4
	MOV R9,#0
	ADD R10, R10,#1
	

	CMP R10,#1	;go to OR 
	BEQ OR

	CMP R10,#2	;go to NOT 
	BEQ NOT

	CMP R10,#3	;go to NAND 
	BEQ NAND

	CMP R10,#4	;go to to NOR 
	BEQ NOR

	B stop
		
stop    B stop
        ENDFUNC
        END