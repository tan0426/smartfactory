*&---------------------------------------------------------------------*
*& Include          ZDLDH_CUST_PAI
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
*    WHEN 'ADD'.
*      IF LS_DATA-ZCODE IS NOT INITIAL               " LS_DATA에 값이 있으면 "
*        AND LS_DATA-ZCNAME IS NOT INITIAL.
*
*        SELECT *
*          INTO CORRESPONDING FIELDS OF TABLE GT_DATA
*          FROM ZTJ_CUST.
*
*        GS_DATA-ZCODE = LS_DATA-ZCODE.
*        GS_DATA-ZCNAME = LS_DATA-ZCNAME.
*        APPEND GS_DATA TO GT_DATA.
*        MESSAGE ' 추가 완료! ' TYPE 'S'.
*      ENDIF.

    WHEN 'DISP'.
      SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_DATA FROM ZTJ_CUST WHERE ZCODE = LS_DATA-ZCODE.
        MESSAGE ' 조회 완료 ! ' TYPE 'S'.

    WHEN 'SAVE'.
      MODIFY ZTJ_CUST FROM LS_DATA.
      MESSAGE ' 거래처 테이블에 저장 완료! ' TYPE 'S'.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  MOVE_SCREEN_TO_ABAP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_screen_to_abap INPUT.
  MODIFY GT_DATA FROM GS_DATA INDEX TC100-CURRENT_LINE.

  IF TC100-LINES < TC100-CURRENT_LINE.
    IF GS_DATA-ZCODE IS NOT INITIAL.
      SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
    SORT GT_DATA.
    ENDIF.
    INSERT GS_DATA INTO GT_DATA INDEX TC100-CURRENT_LINE.
*  ELSEIF GS_DATA-ZCODE = ''.
*    CLEAR GS_DATA.
  ELSE.
*    IF GS_DATA-ZCODE IS NOT INITIAL.
*      SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
*    SORT GT_DATA.
*    ENDIF.
  ENDIF.

  MODIFY GT_DATA FROM GS_DATA INDEX TC100-CURRENT_LINE.
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
