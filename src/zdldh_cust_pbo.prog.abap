*&---------------------------------------------------------------------*
*& Include          ZDLDH_CUST_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'PF100'.
 SET TITLEBAR 'T100'.

*SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
*  SORT   GT_DATA.

DESCRIBE TABLE GT_DATA LINES TC100-LINES.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
  READ TABLE GT_DATA INTO GS_DATA INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
  DATA : LS_DATA LIKE GS_DATA.
  CLEAR GT_DATA.
  IF LS_DATA-ZCODE IS NOT INITIAL.
    CLEAR : GS_DATA.
    SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA WHERE ZCODE = LS_DATA-ZCODE.
    SORT GT_DATA.
  ELSE.
    SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
    SORT GT_DATA.
  ENDIF.

ENDMODULE.
