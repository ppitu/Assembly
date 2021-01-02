;----------------------------------
; int atoi(String number)
; Ascii to integer funtion
atoi:
        push        ebx                 ; preserve EBX on the stack to be restored after function runs
        push        ecx                 ; preserve ECX on the stack to be restored after function runs
        push        edx                 ; preserve EDX on the stack to be restored after function runs
        push        esi                 ; preserve ESI on the stack to be restored after function runs
        mov         esi, eax            ; move pointer in EAX into ESI (number to convert)
        mov         eax, 0              ; initialise EAX with decimal value 0
        mov         ecx, 0              ; initialise ECX with decimal value 0
        
.multiplyLoop:
        xor         ebx, ebx            ; resets both lower and upper bytes of EBX to be 0
        mov         bl, [esi+ecx]       ; move a single byte into BL registry
        cmp         bl, 48              ; compare BL value against ascii value 48 (char value 0)
        jl          .finished           ; jump if less than 0 to label finished
        cmp         bl, 57              ; compare BL value against ascii value 57 (char value 9)
        jg          .finished           ; jump if grater than 9 to label finished
        
        sub         bl, 48              ; convert BL to decimal representation of ascii value
        add         eax, ebx            ; add EBX to integer value in EAX
        mov         ebx, 10             ; move decimal value 10 into EBX
        mul         ebx                 ; muliply EAX by EBX to get palce value
        inc         ecx                 ; increment ECX
        jmp         .multiplyLoop
        
.finished:
        cmp         ecx, 0              ; compare ECX register against decimal 0
        je          .restore            ; jump if equal to 0
        mov         ebx, 10             ; move decimal value 10 into EBX
        div         ebx                 ; divide EAX by EBX
        
.restore:
        pop         esi                 ; restore ESI from the value we pushed onto the stack at the start
        pop         edx                 ; restore EDX from the value we pushed onto the stack at the start
        pop         ecx                 ; restore ECX from the value we pushed onto the stack at the start
        pop         ebx                 ; restore EBX from the value we pushed onto the stack at the start
        ret               


;----------------------------------
; void iprint(Integer number)
; Integer printing function
iprint:
        push        eax                 ; preserve EAX on the stack to be restored after function runs 
        push        ecx                 ; preserve ECX on the stack to be restored after function runs
        push        edx                 ; preserve EDX on the stack to be restored after function runs
        push        esi                 ; preserve ESI on the stack to be restored after function runs
        mov         ecx, 0              ; counter of how many bytes we need to print in the end
        
.divideLoop:
        inc         ecx                 ; count each byte to print - number of characters
        mov         edx, 0              ; empty EDX
        mov         esi, 10             ; mov 10 into ESI
        idiv        esi                 ; divide EAX by ESI
        add         edx, 48             ; convert EDX to it`s anscii representation
        push        edx                 ; push EDX (string representation of an integer) onto the stack
        cmp         eax, 0              ; can the integer be divided anymore?
        jnz         .divideLoop          ; jump if not zero to the label divideLoop
        
.printLoop:
        dec         ecx                 ; count down each byte that we put on stack
        mov         eax, esp            ; move the stack pointer into EAX for printing
        call        sprint              ; call our string print function
        pop         eax                 ; remove last character from stack to move esp forward
        cmp         ecx, 0              ; have we print all bytes we pushed onto stack?
        jnz         .printLoop           ; jump is not zero to the label printLoop
        
        pop         esi                 ; restore ESI from the value we pushed onto the stack at the start
        pop         edx                 ; restore EDX from the value we pushed onto the stack at the start
        pop         ecx                 ; restore ECX from the value we pushed onto the stack at the start
        pop         eax                 ; restore EAX from the value we pushed onto the stack at the start
        ret



;----------------------------------
; void iprintLF(Integer number)
; Integer printing number with linefeed
iprintLF:
        call        iprint              ; call iprint function
        
        push        eax                 ; move EAX onto the stack
        mov         eax, 0Ah            ; move 0Ah into EAX
        push        eax                 ; push the linefeed onto the stack
        mov         eax, esp            ; move the address of the current stack pointer inro EAX
        call        sprint              ; call sprint function
        pop         eax                 ; remove our linefeed character from stack
        pop         eax                 ; restore the orginal value of EAX
        ret 



;----------------------------------
; int slen(String message)
; String lenth calculation function
slen:
        push        ebx                 ; push the value in EBX onto stack 
        mov         ebx, eax            ; move the address in EAX into EBX

.nextchar:
        cmp         byte [eax], 0       ; compare the byte pointed to by EAX at this address against zero (zero = end of string)
        jz          .finished            ; jump (if the zero flagged has been set) to the point in the code labled 'finished
        inc         eax                 ; incremenet the address in EAX by one byte
        jmp         .nextchar            ; jump to the nextchar
        
.finished:
        sub         eax, ebx            ; subtract the address in EBX from the address in EAX, EAX now equals the numer of bytes
        pop         ebx                 ; pop the value on the stack back into EBX
        ret                             ; return
        
        
        
;-------------------------------
; void sprint(String message)
; String printing function
sprint:
        push        edx
        push        ecx
        push        ebx
        push        eax
        call        slen                ; EAX keep the length of string
        
        mov         edx, eax            ; move the address in EAX into EBX
        pop         eax                 ; get the EAX value from stack
        
        mov         ecx, eax            ; move the addres in EAX into ECX
        mov         ebx, 1              ; write to the STDOUT file
        mov         eax, 4              ; invoke SYS_WRITE
        int         80h
        
        pop         ebx
        pop         ecx
        pop         edx
        ret
        
 
;-----------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
        call        sprint
        
        push        eax                 ; push EAX onto stack
        mov         eax, 0Ah            ; move 0Ah into EAX (0Ah ascii character for l linefeed)
        push        eax                 ; push the linefeed onto the stack so we can get the address
        mov         eax, esp            ; move the address of the current stack pointer into EAX for sprint
        call        sprint              ; class sprint
        pop         eax                 ; remove our linefeed character from stack
        pop         eax                 ; restore the orginal value of EAX
        ret                             ; return
         
                 
;-------------------------------
; void exit()
; Exit program and restore resources
quit:
        mov         ebx, 0              ; return 0 status on exit
        mov         eax, 1              ; invoke SYS_EXIT
        int         80h