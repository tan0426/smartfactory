*&---------------------------------------------------------------------*
*& Include          ZDLDH_RESMAP_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.

 DESCRIBE TABLE GT_RMAP LINES TC100-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
  READ TABLE GT_RMAP INTO GS_RMAP INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
  DATA : LS_RMAP LIKE GS_RMAP.
  CLEAR : GT_RMAP.
  IF LS_RMAP-RESID IS NOT INITIAL.
    CLEAR : GS_RMAP.
    SELECT RESID RESNAME BTYPE BUFNO RSIDE RROW RCOL FROM ZTJ_RESMAP INTO CORRESPONDING FIELDS OF TABLE GT_RMAP WHERE RESID = LS_RMAP-RESID.
      SORT GT_RMAP.
      ELSE.
        SELECT RESID RESNAME BTYPE BUFNO RSIDE RROW RCOL FROM ZTJ_RESMAP INTO CORRESPONDING FIELDS OF TABLE GT_RMAP.
          SORT GT_RMAP.
  ENDIF.
ENDMODULE.
