    PrefRepne       EQU rbp+0
    PrefRepe        EQU rbp+1
    OperandSize     EQU rbp+2
    AddressSize     EQU rbp+6
    MOD_            EQU rbp+10
    RM_             EQU rbp+14
    BASE_           EQU rbp+18
    RegOpcode       EQU rbp+22
    DECALAGE_EIP    EQU rbp+26
    Architecture_   EQU rbp+30
    NB_PREFIX       EQU rbp+34
    EIP_            EQU rbp+35


   ; dq ebp_old      rbp+43
   ; dq ret          rbp+51
   ; dq EIP          rbp+59
   ; dq Archi        rbp+67

; *************************************
;
;
;           1 BYTE-OPCODE MAP                   ; +0
;
;
; *************************************

    dq   F1_     , F1_       , F1_       , F1_       , F3_       , F6_       , F5_       , F5_       , F1_       , F1_       , F1_       , F1_       , F3_       , F6_       , F5_       , Esc_2byte
    dq   F1_     , F1_       , F1_       , F1_       , F3_       , F6_       , F5_       , F5_       , F1_       , F1_       , F1_       , F1_       , F3_       , F6_       , F5_       , F5_       
    dq   F1_     , F1_       , F1_       , F1_       , F3_       , F6_       , F12_      , F5_       , F1_       , F1_       , F1_       , F1_       , F3_       , F6_       , F12_      , F5_       
    dq   F1_     , F1_       , F1_       , F1_       , F3_       , F6_       , F12_      , F5_       , F1_       , F1_       , F1_       , F1_       , F3_       , F6_       , F12_      , F5_       
    dq   F11_    , F11_      , F11_      , F11_      , F11_      , F11_      , F11_      , F11_      , F10_      , F10_      , F10_      , F10_      , F10_      , F10_      , F10_      , F10_      
    dq   F2_     , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_     
    dq   F2_     , F2_       , F17_      , F1_       , F12_      , F12_      , PrefOpSize, PrefAdSize, PUSH_Iv   ,IMUL_GvEvIv, F3_       , F8_       , F2_       , F2_       , F2_       , F2_       
    dq   F3_     , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       
    dq   F8_     , G1_EvIv   , G1_EbIb2  , F8_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , POP_Ev
    dq   F2_     , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , CALLF_    , F2_       , F2_       , F2_       , F2_       , F2_       
    dq   F20_    , F21_      , F20_      , F21_      , F2_       , F2_       , F2_       , F2_       , F3_       , F6_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       
    dq   F3_     , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F7_       , F7_       , F7_       , F7_       , F7_       , F7_       , F7_       , F7_       
    dq   F8_     , F8_       , F19_      , F2_       , F17_      , F17_      , F8_       , F13_      , F15_      , F2_       , F19_      , F2_       , F2_       , F3_       , F5_       , F2_       
    dq   F1_     , F1_       , F1_       , F1_       , F14_      , F14_      , F2_       , F2_       , D8_       , D9_       , DA_       , DB_       , DC_       , DD_       , DE_       , DF_
    dq   F3_     , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F3_       , F6_       , F6_       , JMP_far   , F3_       , F2_       , F2_       , F2_       , F2_       
    dq   F12_    , F2_       , PrefREPNE , PrefREP   , F2_       , F2_       , G3_Eb     , G3_Ev     , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , G4_IncDec , G5_IncDec

; *************************************
;
;
;           2 BYTE-OPCODE MAP --> 0F xx         ; +2048
;
;
; *************************************


    dq   G6_     , G7_       , F1_       , F1_       , ECHEC_    , F2_       , F2_       , F2_       , F2_       , F2_       , ECHEC_    , F2_       , ECHEC_    , F1_       , F2_       , ECHEC_     
    dq  F1_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , G16_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       
    dq   F18_    , F18_      , F18_      , F18_      , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       
    dq   F2_     , F2_       , F2_       , F2_       , F2_       , F2_       , ECHEC_    , ECHEC_    ,Esc_tableA4, ECHEC_    ,Esc_tableA5, ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_     
    dq   F1_     , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       
    dq  F1_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_         
    dq F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F4_       , F4_       , F1_       , F1_          
    dq   F1_     , G12_      , G13_      , G14_      , F1_       , F1_       , F1_       , F2_       , F1_       , F1_       , ECHEC_    , ECHEC_    , F1_       , F1_       , F1_       , F1_        
    dq   F6_     , F6_       , F16_      , F16_      , F16_      , F16_      , F6_       , F6_       , F6_       , F6_       , F6_       , F6_       , F6_       , F6_       , F6_       , F6_       
    dq   F1_     , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_         
    dq   F2_     , F2_       , F2_       , F1_       , F8_       , F1_       , ECHEC_    , ECHEC_    , F2_       , F2_       , F2_       , F1_       , F8_       , F1_       , G15_      , F1_       
    dq  F1_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F2_       , G8_EvIb   , F1_       , F1_       , F1_       , F1_       , F1_       
    dq  F1_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , G9_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_       , F2_         
    dq  F1_      , F1_       , F1_       , F1_       , F1_       , F1_       , F23_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_          
    dq   F1_     , F1_       , F1_       , F1_       , F1_       , F1_       , F23_      , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       
    dq   LDDQU_  , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , ECHEC_     

; *************************************
;
;
;           3 BYTE-OPCODE MAP --> 0F 38 xx      ; +4096
;
;
; *************************************

    dq   F1_     , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , F1_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq  F4_      , ECHEC_    , ECHEC_    , ECHEC_    , F4_       , F4_       , ECHEC_    , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , F1_       , F1_       , F1_       , ECHEC_
    dq  F4_      , F4_       , F4_       , F4_       , F4_       , F4_       , ECHEC_    , ECHEC_    , F4_       , F4_       , F4_       , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq  F4_      , F4_       , F4_       , F4_       , F4_       , F4_       , ECHEC_    , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       
    dq  F4_      , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   F22_    , F22_      , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_

; *************************************
;
;
;           3 BYTE-OPCODE MAP --> 0F 3A xx      ; +6144
;
;
; *************************************

    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       , F4_       , F1_       
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , F4_       , F4_       , F4_       , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   F4_     , F4_       , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   F4_     , F4_       , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   F4_     , F4_       , F4_       , F4_       , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_
    dq   ECHEC_  , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_    , ECHEC_

    dq   NOTHING                    ; ModRM_0 +8192
    dq   NOTHING  
    dq   NOTHING  
    dq   NOTHING  
    dq   Addr_SIB
    dq   Addr_disp32
    dq   Addr_ESI
    dq   NOTHING 

    dq   NOTHING                    
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   Addr_SIB
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 

    dq   NOTHING                   
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   Addr_SIB
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 

    dq   NOTHING                   
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
    dq   NOTHING 
