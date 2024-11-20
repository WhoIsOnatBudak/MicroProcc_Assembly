		;; ONAT BUDAK
		;; 150210086

ArraySize   EQU 0x33                        ; Array size = 51

		AREA     My_Array, DATA, READWRITE     ; Define this part as data area for write operations
		ALIGN
y_array SPACE    ArraySize                   ; Allocate space in memory for y_array (array for dynamic programming results)
y_end

		AREA knapsack_iteration, code, readonly ; Define code section for readonly operations
		ENTRY
		THUMB
        ALIGN
__main  FUNCTION
        EXPORT __main

        ; Initialize values
        LDR R0, =profit_array        ; Load address of profit array into R0
        LDR R1, =weight_array        ; Load address of weight array into R1
		LDR R3, =y_array             ; Load address of y_array for dynamic programming storage
        MOVS R2, #3                  ; Load number of items into R2
        MOVS R4, #50                 ; Load knapsack capacity into R4

        MOVS R5, #0                  ; Initialize item count to 0 (used for iterating through items)
        BL lets                      ; Branch to "lets" function to start main loop

		; Re-initialize addresses and pointers for reuse
		LDR R2, =weight_array        ; Load weight array address into R2
		LDR R1, =profit_array        ; Load profit array address into R1
		LDR R3, =y_array             ; Load y_array address for DP

        ; Infinite loop to end program
Stopp    B Stopp                      ; End program with infinite loop

lets
    MOVS R6, #50                  ; Set remaining capacity to 50
    CMP R5, R2                    ; Compare current item index with total items
    BEQ bitti                     ; If all items are processed, branch to "bitti" to end

go
    PUSH {R5}                     ; Save item index on stack
    LSLS R5, R5, #2               ; Shift R5 left by 2 to multiply by 4 (used for array indexing)
    ADDS R7, R1, R5               ; R7 = address of weight[i]
    LDR R7, [R7]                  ; Load weight[i] into R7
    POP {R5}                      ; Restore item index from stack

    PUSH {R5}                     ; Save item index on stack
    SUBS R5, R6, R7               ; Calculate remaining capacity after including weight[i]
    CMP R5, #0                    ; Check if remaining capacity is non-negative
    BLT hop                       ; If remaining capacity is negative, branch to "hop" to skip

    POP {R5}                      ; Restore item index from stack
    PUSH {R6}                     ; Save current capacity on stack
    SUBS R6, R7                   ; Update remaining capacity
    LSLS R2, R6, #2               ; Shift remaining capacity left by 2 for DP indexing
    POP {R6}                      ; Restore original capacity from stack

    ADDS R2, R3, R2               ; Calculate address of DP[i - w]
    LDR R2, [R2]                  ; Load DP[i - w] value

    LSLS R4, R6, #2               ; Calculate address for DP[i]
    ADDS R4, R3
    LDR R4, [R4]                  ; Load DP[i] value

    PUSH {R5}                     ; Save item index on stack
    LSLS R5, R5, #2               ; Calculate address offset for profit[i]
    ADDS R7, R0, R5               ; Calculate address of profit[i]
    LDR R7, [R7]                  ; Load profit[i]
    POP {R5}                      ; Restore item index

    ADDS R7, R2, R7               ; R7 = DP[i - w] + profit[i]

    CMP R7, R4                    ; Compare new DP value with current DP[i]
    BLT ekle                      ; If new value is greater, branch to "ekle" to update DP[i]
    MOVS R4, R7                   ; Update DP[i] with the new value if it's larger

ekle
    MOVS R2, R4                   ; Copy new DP[i] value to R2
    LSLS R4, R6, #2               ; Calculate address for DP[i]
    ADDS R4, R3
    STR R2, [R4]                  ; Store updated DP[i] value in y_array

    MOVS R2, #3                   ; Reset total items count for loop
    MOVS R4, #50                  ; Reset knapsack capacity
    SUBS R6, #1                   ; Decrease remaining capacity
    B go                          ; Loop back to go for next item

hop
    POP {R5}                      ; Restore item index
    ADDS R5, #1                   ; Move to the next item
    MOVS R6, #50                  ; Reset remaining capacity to initial knapsack capacity
    MOVS R2, #3                   ; Reset total items count for loop
    MOVS R4, #50                  ; Reset knapsack capacity
    B lets                        ; Loop back to lets to process the next item

bitti
    MOVS R6, #50                  ; Set remaining capacity to 50
    LSLS R6, R6, #2               ; Calculate final DP index for retrieval
    ADDS R6, R3
    LDR R0, [R6]                  ; Load the final result into R0

    BX LR                         ; Return from function
	
	ENDFUNC

profit_array       DCD 60, 100, 120         ; Example profits for each item

weight_array       DCD 10, 20, 30           ; Example weights for each item

num_items          DCD 3                    ; Define number of items

capacity           DCD 50                   ; Define knapsack capacity


		END
