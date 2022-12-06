*&---------------------------------------------------------------------*
*& Report ZDLDH_RESMAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLDH_RESMAP.

INCLUDE ZDLDH_RESMAP_TOP.
INCLUDE ZDLDH_RESMAP_SCR.
INCLUDE ZDLDH_RESMAP_PBO.
INCLUDE ZDLDH_RESMAP_PAI.
INCLUDE ZDLDH_RESMAP_F01.

INITIALIZATION.
START-OF-SELECTION.

PERFORM GET_DATA.

CALL SCREEN 100.
