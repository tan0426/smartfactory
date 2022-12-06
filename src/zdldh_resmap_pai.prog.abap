

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

*&---------------------------------------------------------------------*
*&      Module  F4_RESID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_resid INPUT.
  DATA : BEGIN OF LS_HELP,
          ITEM_CODE TYPE ZTJ_ITEM-ITEM_CODE,
          COMPONENT TYPE ZTJ_ITEM-COMPONENT,
         END OF LS_HELP,
         LT_HELP LIKE TABLE OF LS_HELP.

   DATA : LS_RETURN LIKE DDSHRETVAL,
          LT_RETURN LIKE TABLE OF DDSHRETVAL.

   SELECT ITEM_CODE, COMPONENT INTO CORRESPONDING FIELDS OF TABLE @LT_HELP FROM ZTJ_ITEM.
     SORT LT_HELP.

      "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'RESID'
*     PVALKEY                = ' '
*     DYNPPROG               = ' '
*     DYNPNR                 = ' '
*     DYNPROFIELD            = ' '
*     STEPL                  = 0
*     WINDOW_TITLE           =
*     VALUE                  = ' '
     VALUE_ORG              = 'S'
*     MULTIPLE_CHOICE        = ' '
*     DISPLAY                = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM          = ' '
*     CALLBACK_METHOD        =
*     MARK_TAB               =
*   IMPORTING
*     USER_RESET             =
    tables
      value_tab              = LT_HELP
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN
*     DYNPFLD_MAPPING        =
   EXCEPTIONS
     PARAMETER_ERROR        = 1
     NO_VALUES_FOUND        = 2
     OTHERS                 = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  "서치헬프 창에서 선택하면 값을 가져옴
  IF LT_RETURN IS NOT INITIAL.
    LOOP AT LT_RETURN INTO LS_RETURN.
      LS_RMAP-RESID = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
  CLEAR : LS_HELP, LS_RETURN.

ENDMODULE.
