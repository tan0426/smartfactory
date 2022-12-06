*&---------------------------------------------------------------------*
*& Include          ZDKTJ_SQL_TOP
*&---------------------------------------------------------------------*

DATA : OK_CODE TYPE SY-UCOMM,
       SAVE_OK TYPE SY-UCOMM.

DATA : GC_DOCKING TYPE REF TO CL_GUI_DOCKING_CONTAINER.
DATA : GC_GRID TYPE REF TO CL_GUI_ALV_GRID.

DATA : GS_FCAT TYPE LVC_S_FCAT,
       GT_FCAT TYPE LVC_T_FCAT.
