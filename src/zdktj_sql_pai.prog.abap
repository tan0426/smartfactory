*&---------------------------------------------------------------------*
*& Include          ZDKTJ_SQL_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE OK_CODE.
    WHEN 'PUSH'.
      PERFORM SQL_RUN.
      IF SY-SUBRC = 0.
        MESSAGE 'RUN SUCCESS' TYPE 'S'.
      ELSE.
        MESSAGE 'RUN FAIL' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
  ENDCASE.
  CLEAR OK_CODE.
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
