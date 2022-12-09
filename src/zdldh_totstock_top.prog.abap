*&---------------------------------------------------------------------*
*& Include          ZDLDH_TOTSTOCK_TOP
*&---------------------------------------------------------------------*

TABLES : ZTJ_TOTSTOCK,
         ZTJ_STOCK.

DATA : BEGIN OF GS_DATA,
        WAREID LIKE ZTJ_BOM-PLANTCODE,
        ITEM_CODE LIKE ZTJ_TOTSTOCK-ITEM_CODE,
        COMPONENT LIKE ZTJ_TOTSTOCK-COMPONENT,
        TOTALQT LIKE ZTJ_TOTSTOCK-TOTALQT,
       END OF GS_DATA.
DATA : GT_DATA LIKE TABLE OF GS_DATA.

DATA : BEGIN OF GS_DATA2,
        MANDT LIKE ZTJ_STOCK-MANDT,
        ITEM_CODE LIKE ZTJ_STOCK-ITEM_CODE,
        COMPONENT LIKE ZTJ_STOCK-COMPONENT,
        INQT LIKE ZTJ_STOCK-INQT,
        OUTQT LIKE ZTJ_STOCK-OUTQT,
        RTIME LIKE ZTJ_STOCK-RTIME,
        TOTALQT LIKE ZTJ_STOCK-TOTALQT,
       END OF GS_DATA2.
DATA : GT_DATA2 LIKE TABLE OF GS_DATA2.

DATA : OK_CODE TYPE SY-UCOMM,
       SAVE_OK TYPE SY-UCOMM.

DATA : GC_DOCKING TYPE REF TO CL_GUI_DOCKING_CONTAINER.
DATA : GC_SPLITTER TYPE REF TO CL_GUI_SPLITTER_CONTAINER.
DATA : GC_CONTAINER_1 TYPE REF TO CL_GUI_CONTAINER.
DATA : GC_CONTAINER_2 TYPE REF TO CL_GUI_CONTAINER.

DATA : GC_GRID_1 TYPE REF TO CL_GUI_ALV_GRID.
DATA : GC_GRID_2 TYPE REF TO CL_GUI_ALV_GRID.


DATA : GS_FCAT TYPE LVC_S_FCAT.
DATA : GT_FCAT TYPE LVC_T_FCAT.

DATA : GS_FCAT2 TYPE LVC_S_FCAT.
DATA : GT_FCAT2 TYPE LVC_T_FCAT.

DATA : GC_EVENT TYPE REF TO EVENT.

DATA : GT_TOOLBAR TYPE UI_FUNCTIONS.
DATA : GS_VARIANT TYPE DISVARIANT.
