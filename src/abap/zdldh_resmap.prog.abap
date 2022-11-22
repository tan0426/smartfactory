*&---------------------------------------------------------------------*
*& Report ZDLDH_RESMAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_RESMAP.

TABLES : ZTJ_RESMAP.

DATA : BEGIN OF GS_RMAP,
        MANDT LIKE ZTJ_RESMAP-MANDT,
        RESID LIKE ZTJ_RESMAP-RESID,
        RESNAME LIKE ZTJ_RESMAP-RESNAME,
        BTYPE LIKE ZTJ_RESMAP-BTYPE,
        BUFNO LIKE ZTJ_RESMAP-BUFNO,
        RSIDE LIKE ZTJ_RESMAP-RSIDE,
        RROW LIKE ZTJ_RESMAP-RROW,
        RCOL LIKE ZTJ_RESMAP-RCOL,
        RSHARE LIKE ZTJ_RESMAP-RSHARE,
       END OF GS_RMAP.

DATA : GT_RMAP LIKE TABLE OF GS_RMAP.

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

 DESCRIBE TABLE GT_RMAP LINES TC100-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
DATA : LS_RMAP LIKE GS_RMAP.

  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.

    WHEN 'DISP'.
      SELECT RESID RESNAME BTYPE BUFNO RSIDE RROW RCOL INTO CORRESPONDING FIELDS OF TABLE GT_RMAP FROM ZTJ_RESMAP WHERE RESID = LS_RMAP-RESID.
        MESSAGE ' 조회 완료 !' TYPE 'S'.

    WHEN 'SAVE'.
      MODIFY ZTJ_RESMAP FROM LS_RMAP.
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
  READ TABLE GT_RMAP INTO GS_RMAP INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MOVE_SCREEN_TO_ABAP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_screen_to_abap INPUT.
  MODIFY GT_RMAP FROM GS_RMAP INDEX TC100-CURRENT_LINE.

  IF TC100-LINES < TC100-CURRENT_LINE.
    IF GS_RMAP-RESID IS NOT INITIAL.
      SELECT RESID RESNAME BTYPE BUFNO RSIDE RROW RCOL FROM ZTJ_RESMAP INTO CORRESPONDING FIELDS OF TABLE GT_RMAP.
        SORT GT_RMAP.
    ENDIF.
    INSERT GS_RMAP INTO GT_RMAP INDEX TC100-CURRENT_LINE.
    ELSE.
  ENDIF.
  MODIFY GT_RMAP FROM GS_RMAP INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
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
