*&---------------------------------------------------------------------*
*& Include          ZDLDH_TOTSTOCK_CLS
*&---------------------------------------------------------------------*

CLASS EVENT DEFINITION.
  PUBLIC SECTION.

  METHODS HANDLE_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK
                              OF CL_GUI_ALV_GRID
                              IMPORTING E_ROW
                                        E_COLUMN
                                        ES_ROW_NO.


ENDCLASS.

CLASS EVENT IMPLEMENTATION.
  METHOD HANDLE_DOUBLE_CLICK.
    PERFORM ALV_HANDLE_DOUBLE_CLICK USING E_ROW
                                          E_COLUMN
                                          ES_ROW_NO.
  ENDMETHOD.
ENDCLASS.
