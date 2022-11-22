*&---------------------------------------------------------------------*
*& Report ZDKTJ_WORKPLAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDKTJ_WORKPLAN.

INCLUDE ZDKTJ_WORKPLAN_TOP.
INCLUDE ZDKTJ_WORKPLAN_SCR.
INCLUDE ZDKTJ_WORKPLAN_PBO.
INCLUDE ZDKTJ_WORKPLAN_PAI.
INCLUDE ZDKTJ_WORKPLAN_F01.

INITIALIZATION.

START-OF-SELECTION.

CALL SCREEN 100.
