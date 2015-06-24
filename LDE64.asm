;
; LDE64 x64 relocatable (Length Disassembler Engine) for 64 bits plateforms
; FREEWARE
;
; coded by BeatriX 
; beatrix2004(at)free(dot)fr
;
; release : 1.6 - 01-14-09
;
;
;   Syntax to disassemble 32 bits target (fastcall convention):
;   mov edx, 0
;   mov rcx, Address2Disasm
;   call LDE
;
;   Syntax to disassemble 64 bits target:
;   mov edx, 64
;   mov rcx, Address2Disasm
;   call LDE
;
;******************************************************


.code

start:

; ================================================
;                   _fastcall
;   mov edx, Architecture ( 0 == IA-32 // 64 == EM64T )     
;   mov rcx, EIP
;   call LDE
;
; ================================================

_LDE@16:
    push rbp
    sub rsp, 43
    mov rbp, rsp
    push rcx
    push rdx
    push rsi
    call StartLDE

    #include Includes\datas.asm
    
StartLDE:
    pop rsi
    push rcx            
    pop [EIP_]
    mov d [Architecture_], edx

    mov b [NB_PREFIX], 0
    mov d [OperandSize], 32
    mov d [AddressSize], 32
    cmp d [Architecture_], 64
    jne >
        mov d [AddressSize], 64
    :
    mov rax, [EIP_]
    movzx rcx, b [rax]
    lea rax, [rsi+rcx*8]
    add rax, [rax]
    call rax
    pop rsi
    pop rdx
    pop rcx

    cmp rax, -1
    je >
      mov rax, [EIP_]
      sub rax, rcx
    :

    add rsp, 43
    pop rbp
    ret

   #include Includes\opcodes.asm
