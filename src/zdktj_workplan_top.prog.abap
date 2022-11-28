*&---------------------------------------------------------------------*
*& Include          ZDKTJ_WORKPLAN_TOP
*&---------------------------------------------------------------------*

CONTROLS TC100 TYPE TABLEVIEW USING SCREEN 100.

DATA : OK_CODE TYPE SY-UCOMM,
       SAVE_OK TYPE SY-UCOMM.

DATA : BEGIN OF GS_WORKPL,
        MITEMCODE TYPE ZTJ_WORKPLAN-MITEMCODE,
        COMPONENT TYPE ZTJ_WORKPLAN-COMPONENT,
        ICNAME TYPE ZTJ_WORKPLAN-ICNAME,
        PLAN_DATE TYPE ZTJ_WORKPLAN-PLAN_DATE,
        PLAN_QT TYPE ZTJ_WORKPLAN-PLAN_QT,
        PLAN_CONFIRM TYPE ZTJ_WORKPLAN-PLAN_CONFIRM,
        CHK,
        ZDELETE,
       END OF GS_WORKPL,
       GT_WORKPL LIKE TABLE OF GS_WORKPL.

DATA : LV_MITEMCODENM TYPE ZTJ_ITEM-COMPONENT.