*&---------------------------------------------------------------------*
*& Report ZDLDH_ITEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_ITEM.

INCLUDE ZDLDH_ITEM_TOP.
INCLUDE ZDLDH_ITEM_SCR.
INCLUDE ZDLDH_ITEM_PBO.
INCLUDE ZDLDH_ITEM_PAI.
INCLUDE ZDLDH_ITEM_F01.

INITIALIZATION.
START-OF-SELECTION.

PERFORM GET_DATA.

CALL SCREEN 100.
