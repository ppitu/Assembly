
%include             'functions.asm'     ; include external file

SECTION .data
menu                    db      'Welcome to the calculator!!!', 0Ah, 'Choose the mathematical action:', 0Ah, '[1] Add       [2] Sub', 0Ah, '[3] Close', 0h
first_number_txt        db      'Eneter first number: ', 0h
second_number_text      db      'Eneter second number: ', 0h

SECTION .bss
action:         resb    255   
first_number:    resb    255
second_number:  resb    255     
              
SECTION .text
global _start

_start:
        mov         eax, menu
        call        sprintLF
 
.input:       
        mov         edx, 255            ; number of byte to write 
        mov         ecx, action         ; reserved space to store our input 
        mov         ebx, 0              ; write to the STDIN 
        mov         eax, 3              ; invoke SYS_READ
        int         80h
        
        mov         edx, 255            ; number of byte to write 
        mov         ecx, first_number   ; reserved space to store our input 
        mov         ebx, 0              ; write to the STDIN 
        mov         eax, 3              ; invoke SYS_READ
        int         80h
        
        mov         edx, 255            ; number of byte to write 
        mov         ecx, second_number  ; reserved space to store our input 
        mov         ebx, 0              ; write to the STDIN 
        mov         eax, 3              ; invoke SYS_READ
        int         80h
        
        mov         eax, action         ; move user input to EAX
        call        atoi                ; convert input to number
        
        cmp         eax, 1              ; compare EAX to 1
        je          .addition           ; if EAX is 1 jump to addition
        
.addition:
        mov         eax, first_number   ; move first number to EAX
        mov         edx, 0              ; move zero to EDX
        call        atoi                ; call atoi
        
        add         edx, eax            ; add EAX to EDX
        
        mov         eax, second_number  ; move second number to EAX
        call        atoi                ; call atoi    
        
        add         edx, eax            ; add EAX to EDX      
        mov         eax, edx            ; move EDX to EAX                       
        
        call        iprintLF

.finished:        
        call        quit
