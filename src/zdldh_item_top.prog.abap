*&---------------------------------------------------------------------*
*& Include          ZDLDH_ITEM_TOP
*&---------------------------------------------------------------------*

TABLES : ZTJ_ITEM.

DATA : BEGIN OF GS_ITEM,
        MANDT LIKE ZTJ_ITEM-MANDT,
        WAREID LIKE ZTJ_ITEM-WAREID,
        ITEM_CODE LIKE ZTJ_ITEM-ITEM_CODE,
        COMPONENT LIKE ZTJ_ITEM-COMPONENT,
        ITEM_GROUP LIKE ZTJ_ITEM-ITEM_GROUP,
       END OF GS_ITEM.

DATA : GT_ITEM LIKE TABLE OF GS_ITEM.

DATA : OK_CODE TYPE SY-UCOMM.

CONTROLS TC100 TYPE TABLEVIEW USING SCREEN 100.

DATA : LS_ITEM LIKE GS_ITEM.
