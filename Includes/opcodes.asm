
; ========================================================== Mod R/M

MOD_RM:
    mov d [DECALAGE_EIP], 0
    mov rax, [EIP_]
    movzx eax, b [rax+1]
    and eax, 11000111b
    mov ecx, 40h    
    xor rdx, rdx
    div ecx
    mov d [MOD_], eax
    cmp eax, 1
    jne >
        add d [DECALAGE_EIP], 1
    :
    cmp eax, 2
    jne >
        add d [DECALAGE_EIP], 4
    :
    mov d [RM_], edx
    shl eax, 6
    add rax, rsi
    add rax, 8192           ; <--- ModRM_0
    lea rax, [rax+rdx*8]
    add rax, [rax]
    call rax
    ret


Reg_Opcode:
    mov rax, [EIP_]
    movzx eax, b [rax+1]
    and eax, 00111000b
    shr eax, 3
    mov d [RegOpcode], eax
    ret


NOTHING:
    ret

Addr_SIB:
    cmp d [AddressSize] ,32
    jnge >
        add d [DECALAGE_EIP], 1
        mov rax, [EIP_]
        movzx eax, b [rax+2]
        and eax, 00000111b
        mov d [BASE_], eax
        cmp d [BASE_],5
        jne >2
            cmp d [MOD_], 0
            jne >1
                add d [DECALAGE_EIP], 4
            1:            
        2:
        ret
    :
    ret

Addr_disp32:
    cmp d [AddressSize] ,32
    jnge >
        add d [DECALAGE_EIP], 4
        ret
    :
    ret

Addr_ESI:
    cmp d [AddressSize], 16
    jne >
        add d [DECALAGE_EIP], 2
        ret
    :
    ret


; *****************************************************************************************
;
;
;
;
;
;
; *****************************************************************************************


F1_:
    call MOD_RM
    mov eax, d [rbp+26]
    add d [rbp+35], eax
    add q [rbp+35], 2
    ret


; =============================================

F2_:
    inc q [EIP_]
    ret
; =============================================

F3_:
    add q [EIP_], 2
    ret
; =============================================

F4_:
    cmp d [OperandSize], 16   ; <--------------- (66h)
    jne >
        call F1_
        ret
    :
        call ECHEC_
        ret

; =============================================

F5_:
    cmp d [Architecture_], 64
    jne >
        call ECHEC_
        ret
    :
        inc q [EIP_]
        ret
    
; =============================================

F6_:
    cmp d [OperandSize] , 32
    jnge >
        add q [EIP_], 5
        ret
    :
        add q [EIP_], 3
        ret
    
; =============================================
F7_:

    cmp d [OperandSize], 64
    jne >
        add q [EIP_], 9
        ret
    :
    cmp d [OperandSize], 32
    jne >
        add q [EIP_], 5
        ret
    :
        add q [EIP_], 3
        ret
    
    
; =============================================


F8_:
    call F1_
    inc q [EIP_]
    ret 

; =============================================

F10_:

    cmp d [Architecture_], 64
    jne >
        mov d [OperandSize], 64      
        inc q [EIP_]
        mov rax, [EIP_]
        movzx rcx, b [rax]
        lea rax, [rsi+rcx*8]
        add rax, [rax]
        
        call rax

        mov d [OperandSize], 32
        ret
    :
        inc q [EIP_]
        ret   

; =============================================

F11_:
    cmp d [Architecture_], 64
    jne >
        inc q [EIP_]
        inc b [NB_PREFIX]
        cmp b [NB_PREFIX],15
        jne >1
            call ECHEC_
            ret
        1:
        mov rax, [EIP_]
        movzx rcx, b [rax]
        lea rax, [rsi+rcx*8]
        add rax, [rax]
        
        call rax

        ret
    :
        add q [EIP_], 1
        ret
    

; =============================================

F12_:    
    inc d[EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX],15
    jne >1
        call ECHEC_
        ret
    1:
    mov rax, [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    
    call rax

    ret

; =============================================

F13_:
    cmp d [OperandSize], 32
    jnge >
        call F1_
        add q [EIP_],4
        ret 
    :
        call F1_
        add q [EIP_],2
        ret 
    


F14_:
    cmp d [Architecture_], 64
    jne >
        call ECHEC_
        ret
    :
        add q [EIP_], 2
        ret


    ; ***************** enter <---------------- C8h

F15_:
    add q [EIP_], 4
    ret


F16_:

    add q [EIP_], 5
    ret    


   ; ************* bound Gv, Ev <------------------------- 62h

F17_: 
    cmp d [Architecture_], 64
    jne >
        call ECHEC_
        ret
    :
        call F1_
        ret


F18_:
    call MOD_RM
    cmp d [MOD_], 11b
    jne >
        call F1_
        ret
    :
        call ECHEC_
        ret


    ; ************* retn  <--------------------------------- C2h
F19_:
    add q [EIP_], 3
    ret


    ; ************* mov AL, Ob <---------------------------- A0h

F20_:
        cmp d [AddressSize] , 64
        jne >
            add q [EIP_], 9
            ret
        :
            add q [EIP_], 5
            ret

    ; ************* mov eAX, Ov <---------------------------- A1h

F21_:
        cmp d [AddressSize] , 16
        jne >
            add q [EIP_], 3
            ret
        :
        cmp d [AddressSize] , 32
        jne >
            add q [EIP_], 5
            ret
        :
            add q [EIP_], 9
            ret


F22_:
    cmp b [PrefRepne] , 1   ; <--------------- (F2h)
    jne >
        call F1_
        ret
    :
        call ECHEC_
        ret
     
F23_:
    cmp b [PrefRepne] , 1  ; <------------------- (F2h)
    jne >
        call F1_
        ret 
    : 
    cmp b [PrefRepe] , 1   ; <------------------- (F3h)
    jne >
        call F1_
        ret 
    : 
    cmp d [OperandSize] , 16   ; <--------------- (66h)
    jne >
        call F1_
        ret 
    :
        call ECHEC_
        ret 
     


CALLF_:

    cmp d [Architecture_], 64
    jne >
        call ECHEC_
        ret
    :
        cmp d [OperandSize], 32
        jne >1
            add q [EIP_], 7
            ret
        1:
            add q [EIP_], 5
            ret
        ret


    ; ************* imul Ev, Gv, Iv <---------------------------- 69h

IMUL_GvEvIv:
    cmp d [OperandSize], 16
    je >1
        call MOD_RM
        mov eax, d [DECALAGE_EIP]
        add d [EIP_], eax
        add q [EIP_], 6
        ret 
    1:
        call MOD_RM
        mov eax, d [DECALAGE_EIP]
        add d [EIP_], eax
        add q [EIP_], 4
        ret 


JMP_far:

    cmp d [Architecture_] , 64
    jne >
        call ECHEC_
        ret

    :
        cmp d [OperandSize] , 32
        jne >
            add q [EIP_], 7
            ret
        :
            add q [EIP_], 5
            ret

     

    ; ************* pop Ev <---------------------- 8Fh

POP_Ev:
    call Reg_Opcode
    cmp d [RegOpcode] , 0
    jne >
        call F1_
        ret
    :
        call ECHEC_
        ret
     

    ; ************* push Iv  <-------------------------- 68h

PUSH_Iv:
    cmp d [Architecture_] , 64
    jne >
        add q [EIP_], 5
        ret
    :
    cmp d [OperandSize] , 32
    jne >
        add q [EIP_], 5
        ret
    :
        add q [EIP_], 3
        ret
     


LDDQU_:
    cmp b [PrefRepne] , 1   ; <--------------- (F2h)
    jne >
        call F1_
        ret 
    :
        call ECHEC_
        ret
     

    ; ********************************************* Opcode inconnu !
ECHEC_:
    mov rax, -1
    ret


; *****************************************************************************************
;
;
;
;
;
;
; *****************************************************************************************

    ; ******************* Grp1 Eb, Ib <--------------------------- 82h

G1_EbIb2:
    cmp d [Architecture_] , 64
    jne >
        call ECHEC_
        ret
    :
        call F1_
        add q [EIP_],1
        ret 
     

    ; ******************* Grp1 Ev, Iv <------------------------- 81h

G1_EvIv:
    cmp d [OperandSize] , 32
    jnge >
        call F1_
        add q [EIP_],4
        ret 
    :
        call F1_
        add q [EIP_],2
        ret 
     

    ; ******************* Grp3 Eb <------------------------- F6h


G3_Eb:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] , 0
    jne >
        mov eax, d [DECALAGE_EIP]
        add d [EIP_], eax
        add q [EIP_],3
        ret
    :    
    cmp d [RegOpcode] , 1
    jne >
        call ECHEC_
        ret
    :
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret


    ; ******************* Grp3 Ev <----------------------------- F7h

G3_Ev:
    cmp d [OperandSize] , 32
    jnge >
        call MOD_RM
        call Reg_Opcode
        cmp d [RegOpcode] , 0
        jne >1
            mov eax, d [DECALAGE_EIP]
            add d [EIP_], eax
            add q [EIP_],6
            ret
        1:
        cmp d [RegOpcode] , 1
        jne >1
            call ECHEC_
            ret
        1: 
        mov eax, d [DECALAGE_EIP]
        add d [EIP_], eax
        add q [EIP_],2
        ret

    :
        call MOD_RM
        call Reg_Opcode
        cmp d [RegOpcode] , 0
        jne >1
            mov eax, d [DECALAGE_EIP]
            add d [EIP_], eax
            add q [EIP_],4
            ret
        1:
        cmp d [RegOpcode] , 1
        jne >1
            call ECHEC_
            ret
        1: 
        mov eax, d [DECALAGE_EIP]
        add d [EIP_], eax
        add q [EIP_],2
        ret
     

    ; ********************************* G4 Inc/Dec <--------------------- FEh
G4_IncDec:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] , 1
    jng >
        call ECHEC_
        ret
    :
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret 

    ; *********************** G5 Inc Dec <---------------------------- FFh
G5_IncDec:
    call Reg_Opcode
    cmp d [RegOpcode] ,6      
    jle >
        call ECHEC_
        ret
    :
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; *********************** G6 <---------------------------- 0F00h
G6_:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] ,5
    jng >
        call ECHEC_
        ret
    : 
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret 

    ; ******************* Grp7 <---------------------- 0FBAh

G7_:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] , 0
    jne >
        cmp d [MOD_] ,011b
        jne long >2
            cmp d [RM_] , 100b
            jng long >2
                call ECHEC_
                ret
    : 
    cmp d [RegOpcode] , 1
    jne >
        cmp d [MOD_] , 011b
        jne long >2
            cmp d [RM_] , 001b
            jng long >2
                call ECHEC_
                ret
    : 
    cmp d [RegOpcode] , 2          
    jne >
        cmp d [MOD_] , 011b
        jne long >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 3          
    jne >
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 4
    jne >
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 5
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 6
    jne >
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 7
    jne >2
        cmp d [MOD_] , 011b
        jne >2
            cmp d [Architecture_] , 64
            jne >1
                cmp d [RM_] , 000b
                je >2
                    call ECHEC_
                    ret
            1:
                call ECHEC_
                ret
    2:            
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret 


    ; ******************* Grp8 Ev, Ib <---------------------- 0FBAh

G8_EvIb:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] , 4
    jnl >
        call ECHEC_
        ret
    :             
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],3
    ret 


    ; *********************** G9 

G9_:
    call MOD_RM
    call Reg_Opcode
    cmp d [RegOpcode] , 0      
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 2  
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 3
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 4  
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 5 
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 7
    jng >
        
        call ECHEC_
        ret
    : 
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; *********************** G12 

G12_:

    call Reg_Opcode
    cmp d [RegOpcode] , 0      
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 1
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 2 
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 3
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 4  
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 5 
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 6
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
         
    : 
        call ECHEC_
        ret
    2:
         
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],3
    ret

    ; *********************** G13 

G13_:
    call Reg_Opcode
    cmp d [RegOpcode] , 0      
    jne >
       call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 1
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 2 
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 3
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 4  
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 5 
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 6
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
    : 
        call ECHEC_
        ret
    2:
     
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],3
    ret

    ; *********************** G14 

G14_:
    call Reg_Opcode
    cmp d [RegOpcode] , 0      
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 1
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 2
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je long>2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 3 
    jne >
        cmp d [OperandSize] , 16
        jne >1
            call MOD_RM
            cmp d [MOD_] , 011b
            je >2
                call ECHEC_
                ret
        1:
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 4  
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 5 
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 6
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        je >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 7
    jne >1
        cmp d [OperandSize] , 16
        jne >1
            call MOD_RM
            cmp d [MOD_] , 011b
            je >2
                call ECHEC_
                ret
        1:
            call ECHEC_
            ret
    2:
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],3
    ret

    ; *********************** G15 
G15_:
    call Reg_Opcode
    cmp d [RegOpcode] , 0 
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne long >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 1
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne long >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 2  
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne long >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 3
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 4  
    jne >
        call ECHEC_
        ret
    : 
    cmp d [RegOpcode] , 5 
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 6
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
    : 
    cmp d [RegOpcode] , 7
    jg >
        call MOD_RM
        jmp >2
    :
        call ECHEC_
        ret
    2: 
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; *********************** G16 
G16_:
    call Reg_Opcode
    cmp d [RegOpcode] , 0 
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 1
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 2  
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
         
    : 
    cmp d [RegOpcode] , 3
    jne >
        call MOD_RM
        cmp d [MOD_] , 011b
        jne >2
            call ECHEC_
            ret
         
    : 
        call ECHEC_
        ret
        
    2:     
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret


     

; *****************************************************************************************
;
;
;
;
;
;
; *****************************************************************************************

    ; ******************** préfixe 66h

PrefOpSize:
    inc q [EIP_]
    mov d [OperandSize], 16
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    
    call rax

    mov d [OperandSize], 32
    ret

    ; ******************** préfixe 67h

PrefAdSize:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov ecx, d [AddressSize]
    shr ecx, 1
    mov d [AddressSize], ebx
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    
    call rax
    mov ebx, d [AddressSize]
    shl ecx, 1
    mov d [AddressSize], ecx
    ret

    ; ******************* préfixe REPNE <------ F2h

PrefREPNE:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx eax, b [rax]
    cmp al ,0A4h
    je >1
    cmp al ,0A7h
    je >1
    cmp al ,0AEh
    je >1
    cmp al ,0AFh
    je >1
    cmp al ,00Fh
    je >1
    jmp >2
    1:
        mov b [PrefRepne], 1
    2:
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    
    call rax
    mov b [PrefRepne], 0
    ret
    


    ; ******************* préfixe REP <------ F3h

PrefREP:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx eax, b [rax]

    cmp al ,090h
    je >1
    cmp al ,0A4h
    je >1
    cmp al ,0A5h
    je >1
    cmp al ,0A6h
    je >1
    cmp al ,0A7h
    je >1
    cmp al ,0AAh
    je >1
    cmp al ,0ABh
    je >1
    cmp al ,0ACh
    je >1
    cmp al ,0ADh
    je >1
    cmp al ,0AEh
    je >1
    cmp al ,0AFh
    je >1
    cmp al ,06Ch
    je >1
    cmp al ,06Dh
    je >1
    cmp al ,06Eh
    je >1
    cmp al ,06Fh
    je >1
    cmp al ,00Fh
    je >1
    jmp >2
    1:
        mov b [PrefRepe], 1
    2:
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    
    call rax
    mov b [PrefRepe], 0
    ret



    ; ******************* 0Fh       ; <--- préfixe pour opcodes à 2 bytes
Esc_2byte:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+2048+rcx*8]
    add rax, [rax]
    
    call rax
    ret

    ; ******************* 0F38h       ; <--- préfixe pour opcodes à 3 bytes
Esc_tableA4:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+4096+rcx*8]
    add rax, [rax]
    
    call rax
    ret

    ; ******************* 0F3Ah       ; <--- préfixe pour opcodes à 3 bytes
Esc_tableA5:
    inc q [EIP_]
    inc b [NB_PREFIX]
    cmp b [NB_PREFIX] , 15
    jne >
        call ECHEC_
        ret
    :
    mov rax, q [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+6144+rcx*8]
    add rax, [rax]
    
    call rax
    ret


; *****************************************************************************************
;
;
;
;
;
;
; *****************************************************************************************

    ; ************************************ D8h (ok)
D8_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax, 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 7
        jng >
            call ECHEC_    
            ret
    :
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret



    ; ************************************ D9h (ok)
D9_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax ,0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 1
        jne >3
        cmp d [RegOpcode] , 7
        jng >3
            call ECHEC_
            ret
        
    : 
    cmp eax , 0C0h
    jnge >3
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Dh
        jne >1
            cmp ecx , 0
            je >3
                call ECHEC_
                ret
        1:
        cmp  edx , 0Eh
        jne >3
            cmp ecx , 2
            jne >2
                call ECHEC_
                ret
            2:
            cmp ecx , 3
            jne >2
                call ECHEC_
                ret
            2:
            cmp ecx , 6
            jne >2
                call ECHEC_
                ret
            2:
            cmp ecx , 7
            jne >2
                call ECHEC_
                ret
            2:
            cmp ecx , 0Fh
            jne >3
                call ECHEC_
                ret
    3:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret


    ; ************************************ D9h (ok)
DA_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax , 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 7                
        jng >3
            call ECHEC_  
            ret  
    :
    cmp eax , 0C0h
    jnge >3
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Eh
        jne >
            cmp ecx , 9
            je >3
                call ECHEC_
                ret
            
        : 
        cmp edx , 0Fh
        jne >3
            call ECHEC_
            ret
    3:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; ************************************ DBh (ok)
DB_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax ,0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 4
        je >1 
        cmp d [RegOpcode] , 6
        je >1
        cmp d [RegOpcode] , 7
        jg >1
        jmp >3
        1:
            call ECHEC_ 
            ret   
    : 
    cmp eax , 0C0h
    jnge >3
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Eh
        jne >
            cmp ecx , 8
            jnl >3
                cmp ecx , 3
                je >3
                cmp ecx , 2
                je >3
                    call ECHEC_
                    ret
        : 
        cmp edx , 0Fh
        jne >3
            cmp ecx , 8
            jnge >3
                call ECHEC_
                ret
    3:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; ************************************ DCh (ok)
DC_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax , 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 7
        jng >2
            call ECHEC_    
            ret
        
    : 
    cmp eax , 0C0h
    jnge >2
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Dh
        jne >2
            call ECHEC_
            ret
        
    2:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret


    ; ************************************ DDh (ok)
DD_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax , 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 5
        je >1
        cmp d [RegOpcode] , 7
        jg >1
        jmp >2
        1:
            call ECHEC_
            ret
    : 
    cmp eax , 0C0h
    jnge >2
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Ch
        jne >
            cmp ecx , 8
            jnge >2
                call ECHEC_
                ret
        : 
        cmp edx , 0Fh
        jne >2
            call ECHEC_
            ret
    2:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret


    ; ************************************ DEh (ok)
DE_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax , 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 7                
        jng >2
            call ECHEC_
            ret
    : 
    cmp eax , 0C0h
    jnge >2
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Dh
        jne >2
            cmp ecx , 9
            je >2
                call ECHEC_
                ret
    2:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret

    ; ************************************ DFh (ok)
DF_:
    mov d [DECALAGE_EIP], 0
    mov rax, q [EIP_]
    movzx eax, b [rax+1]
    cmp eax , 0BFh
    jnle >
        call Reg_Opcode
        cmp d [RegOpcode] , 7                
        jng >2
            call ECHEC_
            ret
    : 
    cmp eax , 0C0h
    jnge >2
        mov edx, eax
        shr edx, 4
        mov ecx, eax
        and ecx, 0Fh
        cmp edx , 0Ch
        jne >
            call ECHEC_
            ret
        : 
        cmp edx , 0Dh
        jne >
            call ECHEC_
            ret
        : 
        cmp edx , 0Eh
        jne >
            cmp ecx , 0
            je >2
            cmp ecx , 8
            jnl >2
                call ECHEC_
                ret
        : 
        cmp edx , 0Fh
        jne >2
            cmp ecx , 8
            jnge >2
                call ECHEC_
                ret
    2:
    call MOD_RM
    mov eax, d [DECALAGE_EIP]
    add d [EIP_], eax
    add q [EIP_],2
    ret
