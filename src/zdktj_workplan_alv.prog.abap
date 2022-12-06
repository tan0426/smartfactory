*&---------------------------------------------------------------------*
*& Report ZDKTJ_WORKPLAN_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDKTJ_WORKPLAN_ALV.

INCLUDE ZDKTJ_WORKPLAN_ALV_TOP.
INCLUDE ZDKTJ_WORKPLAN_ALV_SCR.
INCLUDE ZDKTJ_WORKPLAN_ALV_PBO.
INCLUDE ZDKTJ_WORKPLAN_ALV_PAI.
INCLUDE ZDKTJ_WORKPLAN_ALV_F01.

INITIALIZATION.

START-OF-SELECTION.
  PERFORM GET_DATA.

CALL SCREEN 100.
