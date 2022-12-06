*&---------------------------------------------------------------------*
*& Include          ZDLDH_STOCK_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.

 DESCRIBE TABLE GT_STOCK LINES TC100-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MOVE_ABAP_TO_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE move_abap_to_screen OUTPUT.
  READ TABLE GT_STOCK INTO GS_STOCK INDEX TC100-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_TC100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_tc100 OUTPUT.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_0100 OUTPUT.
  " REFRESH 버튼 누를때만 활성화 "
  IF SAVE_OK = 'REFR' OR SAVE_OK = 'DISP'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'LS_STOCK-ITEM_CODE' OR SCREEN-NAME = 'LV_INPUT'.
        SCREEN-INPUT = '1'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
    ELSE.
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'LS_STOCK-ITEM_CODE' OR SCREEN-NAME = 'LV_INPUT'.
          SCREEN-INPUT = '0'.
      ENDIF.
      MODIFY SCREEN.
      ENDLOOP.
   ENDIF.

ENDMODULE.
