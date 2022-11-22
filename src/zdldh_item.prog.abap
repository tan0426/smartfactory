*&---------------------------------------------------------------------*
*& Report ZDLDH_ITEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_ITEM.

TABLES : ZTJ_ITEM.

DATA : BEGIN OF GS_ITEM,
        MANDT LIKE ZTJ_ITEM-MANDT,
        ITEM_CODE LIKE ZTJ_ITEM-ITEM_CODE,
        COMPONENT LIKE ZTJ_ITEM-COMPONENT,
        ITEM_GROUP LIKE ZTJ_ITEM-ITEM_GROUP,
       END OF GS_ITEM.

DATA : GT_ITEM LIKE TABLE OF GS_ITEM.

DATA : OK_CODE TYPE SY-UCOMM.

CONTROLS TC100 TYPE TABLEVIEW USING SCREEN 100.

CALL SCREEN 100.
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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : LS_ITEM LIKE GS_ITEM.

  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.

    WHEN 'DISP'.
      SELECT ITEM_CODE COMPONENT ITEM_GROUP INTO CORRESPONDING FIELDS OF TABLE GT_ITEM FROM ZTJ_ITEM WHERE ITEM_CODE = LS_ITEM-ITEM_CODE.
        MESSAGE ' 조회 완료 !' TYPE 'S'.

    WHEN 'SAVE'.
      MODIFY ZTJ_ITEM FROM LS_ITEM.
      MESSAGE ' 품목 테이블에 저장 완료! ' TYPE 'S'.

    WHEN OTHERS.
  ENDCASE.
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
*&      Module  MOVE_SCREEN_TO_ABAP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_screen_to_abap INPUT.
  MODIFY GT_ITEM FROM GS_ITEM INDEX TC100-CURRENT_LINE.

  IF TC100-LINES < TC100-CURRENT_LINE.
    IF GS_ITEM-ITEM_CODE IS NOT INITIAL.
      SELECT ITEM_CODE COMPONENT ITEM_GROUP FROM ZTJ_ITEM INTO CORRESPONDING FIELDS OF TABLE GT_ITEM.
        SORT GT_ITEM.
    ENDIF.
    INSERT GS_ITEM INTO GT_ITEM INDEX TC100-CURRENT_LINE.
    ELSE.
  ENDIF.
  MODIFY GT_ITEM FROM GS_ITEM INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
  CLEAR : GT_ITEM.
  IF LS_ITEM-ITEM_CODE IS NOT INITIAL.
    CLEAR : GS_ITEM.
    SELECT ITEM_CODE COMPONENT ITEM_GROUP FROM ZTJ_ITEM INTO CORRESPONDING FIELDS OF TABLE GT_ITEM WHERE ITEM_CODE = LS_ITEM-ITEM_CODE.
      SORT GT_ITEM.
  ELSE.
    SELECT ITEM_CODE COMPONENT ITEM_GROUP FROM ZTJ_ITEM INTO CORRESPONDING FIELDS OF TABLE GT_ITEM.
    SORT GT_ITEM.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
