*&---------------------------------------------------------------------*
*& Include          ZDLDH_TOTSTOCK_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module ALV_DISPLAY_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ALV_DISPLAY_0100 OUTPUT.
  IF GC_DOCKING IS INITIAL.
    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG.
    PERFORM DISPLAY.
    PERFORM EVENT.
    PERFORM ETC.          " VARIANT / TOOLBAR 등등
  ELSE.
    PERFORM REFRESH.
  ENDIF.


ENDMODULE.
