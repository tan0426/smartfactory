*&---------------------------------------------------------------------*
*& Include          ZDLDH_RESMAP_PAI
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

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
