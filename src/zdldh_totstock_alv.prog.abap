*&---------------------------------------------------------------------*
*& Report ZDLDH_TOTSTOCK_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_TOTSTOCK_ALV.

INCLUDE ZDLDH_TOTSTOCK_TOP.
INCLUDE ZDLDH_TOTSTOCK_SEL.
INCLUDE ZDLDH_TOTSTOCK_PBO.
INCLUDE ZDLDH_TOTSTOCK_PAI.
INCLUDE ZDLDH_TOTSTOCK_F01.

INITIALIZATION.

START-OF-SELECTION.

SELECT * FROM ZTJ_TOTSTOCK INTO CORRESPONDING FIELDS OF TABLE GT_DATA WHERE ITEM_CODE IN S_ICODE.

CALL SCREEN 100.
