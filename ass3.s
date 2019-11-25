  	AREA    appcode ,CODE,READONLY
	IMPORT printMsg
    EXPORT __main
    ENTRY
__main    FUNCTION
	MOV R2,#1; variable for counting	
    MOV R3,#20; number of Terms in Series
        
				
	VLDR.F32 S0,=1 ; register to hold the final sum of e^x  
	VLDR.F32 S1,=1; Temporary register to hold intermediate multiplication

	VLDR.F32 S6,=1; Temporary register to hold factorial

	VLDR.F32 S4,=1; 
	VLDR.F32 S25,=0.5; store 0.5 for comparison 
	
	MOV R10, #0	;value for selecting the logic to be choosen.
	BAL switch
		
switch			; switch-case 

	CMP R10,#0	;jump to AND  
	BEQ AND_gate

	CMP R10,#1	;jump to OR 
	BEQ OR_gate

	CMP R10,#2	;jump to NOT 
	BEQ NOT_gate

	CMP R10,#3	;jump to NAND 
	BEQ NAND_gate

	CMP R10,#4	;jump to NOR 
	BEQ NOR_gate

	CMP R10,#5  ;jump to XOR 
	BEQ XOR_gate

	CMP R10,#6	;jump to XNOR 
	BEQ XNOR_gate

exponential   CMP R2,R3; 	Compare i & n 
      BLE goto; 	if i < n jump to gotos
      B sigmoid;		else jump to sigmoid 
		
goto  VMUL.F32 S1,S1,S2; temp = temp*x
	  VMOV.F32 S3,S1;
      VMOV.F32 S5,R2; 	Moving value of register R2 to S5
      VCVT.F32.U32 S5, S5;	Converting to floating point 
		
	VMUL.F32 S6,S6,S5;	Calculating factorial term
        VDIV.F32 S3,S3,S6;	temp=temp/factorial
        VADD.F32 S0,S0,S3;	Final sum of all terms stored in S0
		
        ADD R2,R2,#1;	Increment i
        B exponential;	





		
OR_gate
	VLDR.F32 S7,=-0.1  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=0.7
	VLDR.F32 S9,=0.7
	VLDR.F32 S10,=-0.1
	B calculate
	
XNOR_gate
	VLDR.F32 S7,=-5  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=20
	VLDR.F32 S9,=10
	VLDR.F32 S10,=1
	B calculate
		
NAND_gate
	VLDR.F32 S7,=0.6  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=-0.8
	VLDR.F32 S9,=-0.8
	VLDR.F32 S10,=0.3
	B calculate
		
NOR_gate
	VLDR.F32 S7,=0.5  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=-0.7
	VLDR.F32 S10,=0.1
	B calculate
		
NOT_gate
	VLDR.F32 S7,=0.5  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=0
	VLDR.F32 S10,=0.1
	B calculate
	
XOR_gate		
	VLDR.F32 S7,=-5  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=20
	VLDR.F32 S9,=10
	VLDR.F32 S10,=1
	B calculate


AND_gate
	VLDR.F32 S7,=-0.1  ;Initializing values according to the data given in python file
	VLDR.F32 S8,=0.2
	VLDR.F32 S9,=0.2
	VLDR.F32 S10,=-0.2
	B calculate


calculate	VLDR.F32 S16,=1 ;input A 
	VLDR.F32 S17,=0		;input B 
	VLDR.F32 S18,=1		;input C 

	VMUL.F32 S19,S7,S16;
	VMUL.F32 S20,S8,S17;
	VMUL.F32 S21,S9,S18;

	VADD.F32 S22,S19,S20
	VADD.F32 S22,S22,S21
	VADD.F32 S22,S22,S10      ;x is calculated & stored in S22
	VMOV.F32 S2, S22;
	B exponential
				

sigmoid
	VADD.F32 s14,s4,s0 		;1+e^x
	VDIV.F32 S15,S0,S14		;e^x/1+e^x
	
	;VCVT.U32.F32 S15,S15
	VCMP.F32 S15,S25;	Comparing result of sigmoid function with 0.5
	VMRS APSR_NZCV, FPSCR
	
	BGT larger   ; jump to larger if S15(result) >0.5
	
	MOV R0,#0;	if S15(result) <0.5 then R0=0
	BL printMsg;	; print R0
	B stop
	
larger MOV R0,#1; if S15(result) > 0.5 then R0=0
	BL printMsg;	;print R0
	B stop
		
stop    B stop
        ENDFUNC
        END