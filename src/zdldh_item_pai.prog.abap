*&---------------------------------------------------------------------*
*& Include          ZDLDH_ITEM_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  DATA : LS_ITEM LIKE GS_ITEM.
  DATA : LV_ANSWER.

  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE TO SCREEN 0.

    WHEN 'DISP'.
      SELECT ITEM_CODE COMPONENT ITEM_GROUP INTO CORRESPONDING FIELDS OF TABLE GT_ITEM FROM ZTJ_ITEM WHERE ITEM_CODE = LS_ITEM-ITEM_CODE.
        MESSAGE ' 조회 완료 !' TYPE 'S'.

    WHEN 'SAVE'.
      MODIFY ZTJ_ITEM FROM LS_ITEM.
      MESSAGE ' 품목 테이블에 저장 완료! ' TYPE 'S'.

    WHEN 'REFR'.
      CLEAR : LS_ITEM, GS_ITEM.

    WHEN 'DELE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
         TITLEBAR                    = '데이터 삭제'
*         DIAGNOSE_OBJECT             = ' '
          text_question               = ' 너 진짜 지울거야..?'
*         TEXT_BUTTON_1               = 'Ja'(001)
*         ICON_BUTTON_1               = ' '
*         TEXT_BUTTON_2               = 'Nein'(002)
*         ICON_BUTTON_2               = ' '
*         DEFAULT_BUTTON              = '1'
*         DISPLAY_CANCEL_BUTTON       = 'X'
*         USERDEFINED_F1_HELP         = ' '
*         START_COLUMN                = 25
*         START_ROW                   = 6
*         POPUP_TYPE                  =
*         IV_QUICKINFO_BUTTON_1       = ' '
*         IV_QUICKINFO_BUTTON_2       = ' '
       IMPORTING
         ANSWER                      = LV_ANSWER
*       TABLES
*         PARAMETER                   =
*       EXCEPTIONS
*         TEXT_NOT_FOUND              = 1
*         OTHERS                      = 2
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF LV_ANSWER = '1'.
        " 삭제 처리 "
        DELETE FROM ZTJ_ITEM WHERE ITEM_CODE = LS_ITEM-ITEM_CODE.
        COMMIT WORK.
        IF SY-SUBRC = 0.
          MESSAGE ' 삭제 완료 ' TYPE 'S'.
        ENDIF.
      ENDIF.

  CLEAR : OK_CODE.
  ENDCASE.
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
