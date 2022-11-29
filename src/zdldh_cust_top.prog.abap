*&---------------------------------------------------------------------*
*& Include          ZDLDH_CUST_TOP
*&---------------------------------------------------------------------*
TABLES : ZTJ_CUST.
CONTROLS TC100 TYPE TABLEVIEW USING SCREEN 100.

DATA : BEGIN OF GS_DATA,
        MANDT LIKE ZTJ_CUST-MANDT,
        ZCODE LIKE ZTJ_CUST-ZCODE,
        ZCNAME LIKE ZTJ_CUST-ZCNAME,
       END OF GS_DATA.

DATA : GT_DATA LIKE TABLE OF GS_DATA.

DATA : OK_CODE TYPE SY-UCOMM.
