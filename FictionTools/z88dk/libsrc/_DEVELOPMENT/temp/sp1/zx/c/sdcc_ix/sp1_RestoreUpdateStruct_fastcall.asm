
; sp1_RestoreUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_RestoreUpdateStruct_fastcall

EXTERN asm_sp1_RestoreUpdateStruct

defc _sp1_RestoreUpdateStruct_fastcall = asm_sp1_RestoreUpdateStruct
