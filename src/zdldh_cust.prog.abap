*&---------------------------------------------------------------------*
*& Report ZDLDH_CUST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_CUST.

INCLUDE ZDLDH_CUST_TOP.
INCLUDE ZDLDH_CUST_SCR.
INCLUDE ZDLDH_CUST_PBO.
INCLUDE ZDLDH_CUST_PAI.
INCLUDE ZDLDH_CUST_F01.


INITIALIZATION.
START-OF-SELECTION.

PERFORM GET_DATA.

CALL SCREEN 100.
