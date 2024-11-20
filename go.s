		;;ONAT BUDAK
		;;150210086
		
		AREA knapsack_recursive, code, readonly
		ENTRY
		THUMB
        ALIGN
__main  FUNCTION
        EXPORT __main

        ; Initialize values
        LDR R0, =profit_array    	; Load address of profit array into R0
        LDR R1, =weight_array    	; Load address of weight array into R1
        MOVS R2, #3       			; Load number of items into R2
        MOVS R4, #50        		; Load knapsack capacity into R4

        ; Call recursive knapsack function
		
		
        BL knapsack_recursive1  
		
		
		MOV R2,R1				;Make R2 Weight array
		MOV R1,R0				;Make R1 Profit array
        
		
		; Store the result
        MOV R0, R3               ; Result in R3 is moved to R0 for returning to caller
        
        ; Infinite loop to end program
Stopp    B Stopp
		

knapsack_recursive1 
        PUSH {R2,R4}           	; Save registers R2-R4  
		PUSH {LR}				;Save LR Link Register

        CMP R2, #0                 ; If no items left (R2 == 0)
        BEQ zero_case

        CMP R4, #0                 ; If knapsack capacity is zero (R4 == 0)
        BEQ zero_case

        SUBS R2, R2, #1             ; Decrease the number of items (R2 - 1)

		
		PUSH {R2}					;For keeping original R2
		
		LSLS R2, R2, #2				;Shift R2 2 bit for multpliying with 4
		
		ADDS R7, R1, R2				;Make R7 the adrees of Weight[R2] 
		LDR R7, [R7]				;Load R7 with the weight of selected index
		POP{R2}						;Take original R2 back

        CMP R7, R4                 ; Compare weight with capacity
        BLE skip_not_capacity      ; If weight is less than or equal to capacity, continue

        ; If item weight is greater than remaining capacity, skip this item

        BL knapsack_recursive1

		
		POP{R5}						;Pop The LR we push at the start to R5
		MOV LR, R5					;MAke LR = R5
		POP {R2,R4}             	;POP the size and count of the recursive to avoid overwrite

        BX LR 						;Go to upper recurse
		

skip_not_capacity
		
		;Even we have enough capacity do not take this item and calculate value
        BL knapsack_recursive1

        
        MOV R5, R3                 ; Save the result without taking this item
		
		
		PUSH {R2}					;Save original R2
		LSLS R2,R2,#2				;Shift 2 bit for multiplying with 4
		ADDS R6,R0,R2				;Make R6 the adress of profit[R2]
		LDR R6, [R6]
		POP{R2}
		

		
		PUSH{R5}					;Also save result to stack to not lose
		
		
		
		PUSH {R2}					;For keeping original R2
		
		LSLS R2, R2, #2				;Shift R2 2 bit for multpliying with 4
		
		ADDS R7, R1, R2				;Make R7 the adrees of Weight[R2] 
		LDR R7, [R7]				;Load R7 with the weight of selected index
		POP{R2}						;Take original R2 back

		
        SUBS R4, R4, R7             ; Subtract item weight from remaining capacity
		
		PUSH{R6}					;For not losing profit
		
		
        BL knapsack_recursive1     ; Recursive call to knapsack_recursive1 including this item
		
		POP{R6}						;Take the profit back from stack
		
		ADDS R3, R6                 ; Add profit of the current item
        
		POP{R5}						;Take the exluding this item profit back
        CMP R3, R5                 ; Compare new profit with the previous one
        BGT bigger                 ; If new profit is greater, update result
        MOV R3, R5                 ; Otherwise, keep previous result

bigger


		POP{R5}						;Pop The LR we push at the start to R5
		MOV LR, R5					;MAke LR = R5
		POP {R2,R4}             	;POP the size and count of the recursive to avoid overwrite

        BX LR                      ; Return from the function

zero_case
		MOVS R3,#0					;Item count or weight not enough return zero
		POP {R5}					;Pop The LR we push at the start to R5
		MOV LR, R5					;MAke LR = R5
        POP {R2,R4}             	; POP the size and count of the recursive to avoid overwrite

        BX LR                      ; Return from function
		
		ALIGN
		ENDFUNC

profit_array       DCD 60, 100, 120           ; Example profits

weight_array       DCD 10, 20, 30             ; Example weights

num_items          DCD 3                      ; Example 3 items

capacity           DCD 50                     ; Example knapsack capacity


			
		END
			
			
			
			
			
			
			
	

