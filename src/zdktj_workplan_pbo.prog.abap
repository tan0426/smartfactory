*&---------------------------------------------------------------------*
*& Include          ZDKTJ_WORKPLAN_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.

 DESCRIBE TABLE GT_WORKPL LINES TC100-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
  READ TABLE GT_WORKPL INTO GS_WORKPL INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
  LOOP AT SCREEN.
    IF GS_WORKPL-MITEMCODE IS NOT INITIAL.
      IF SCREEN-NAME = 'GS_WORKPL-PLAN_DATE'.
        SCREEN-INPUT = 1.
      ENDIF.

      IF SCREEN-NAME = 'GS_WORKPL-PLAN_QT'.
        SCREEN-INPUT = 1.
      ENDIF.
    ELSE.
      IF SCREEN-NAME = 'GS_WORKPL-PLAN_DATE'.
        SCREEN-INPUT = 0.
      ENDIF.
      IF SCREEN-NAME = 'GS_WORKPL-PLAN_QT'.
        SCREEN-INPUT = 0.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.
