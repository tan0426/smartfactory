*&---------------------------------------------------------------------*
*& Report ZDLDH_STOCK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_STOCK.

INCLUDE ZDLDH_STOCK_TOP.
INCLUDE ZDLDH_STOCK_SCR.
INCLUDE ZDLDH_STOCK_PBO.
INCLUDE ZDLDH_STOCK_PAI.
INCLUDE ZDLDH_STOCK_F01.

INITIALIZATION.
START-OF-SELECTION.

PERFORM GET_DATA.

CALL SCREEN 100.
