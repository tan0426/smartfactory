*&---------------------------------------------------------------------*
*& Include          ZDLDH_ITEM_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.

 DESCRIBE TABLE GT_ITEM LINES TC100-LINES.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
  READ TABLE GT_ITEM INTO GS_ITEM INDEX TC100-CURRENT_LINE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
  CLEAR : GT_ITEM.
  DATA : LS_ITEM LIKE GS_ITEM.
  IF LS_ITEM-ITEM_CODE IS NOT INITIAL.
    CLEAR : GS_ITEM.
    SELECT ITEM_CODE COMPONENT ITEM_GROUP FROM ZTJ_ITEM INTO CORRESPONDING FIELDS OF TABLE GT_ITEM WHERE ITEM_CODE = LS_ITEM-ITEM_CODE.
      SORT GT_ITEM.
  ELSE.
    SELECT ITEM_CODE COMPONENT ITEM_GROUP FROM ZTJ_ITEM INTO CORRESPONDING FIELDS OF TABLE GT_ITEM.
    SORT GT_ITEM.
  ENDIF.
ENDMODULE.
