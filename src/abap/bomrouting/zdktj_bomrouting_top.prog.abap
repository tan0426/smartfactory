*&---------------------------------------------------------------------*
*& Include          ZDKTJ_BOMROUTING_TOP
*&---------------------------------------------------------------------*
CONTROLS TC100 TYPE TABLEVIEW USING SCREEN 100.

DATA : OK_CODE TYPE SY-UCOMM,
       SAVE_OK TYPE SY-UCOMM.

DATA : BEGIN OF GS_BOMROUT,
        MITEMCODE TYPE ZTJ_BOMROUTING-MITEMCODE,
        ITEMCODE TYPE ZTJ_BOMROUTING-ITEMCODE,
        STEP_NO TYPE ZTJ_BOMROUTING-STEP_NO,
        OP_NO TYPE ZTJ_BOMROUTING-OP_NO,
        ASS_CODE TYPE ZTJ_BOMROUTING-ASS_CODE,
        RES_ID TYPE ZTJ_BOMROUTING-RES_ID,
        NEXTSTEP TYPE ZTJ_BOMROUTING-NEXTSTEP,
        DESCRIPTION TYPE ZTJ_BOMROUTING-DESCRIPTION,
        UOM TYPE ZTJ_BOMROUTING-UOM,
        INPUT_QT TYPE ZTJ_BOMROUTING-INPUT_QT,
        JSONCODE TYPE ZTJ_BOMROUTING-JSONCODE,
       END OF GS_BOMROUT,
       GT_BOMROUT LIKE TABLE OF GS_BOMROUT.

DATA : MITEMCODENM(100).
