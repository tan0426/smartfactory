*&---------------------------------------------------------------------*
*& Include          ZDKTJ_BOMROUTING_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.

 DESCRIBE TABLE GT_BOMROUT LINES TC100-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
 READ TABLE GT_BOMROUT INTO GS_BOMROUT INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_screen OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'GS_BOMROUT-MITEMCODE'.
    SCREEN-REQUIRED = 1.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
