*&---------------------------------------------------------------------*
*& Include          ZDLDH_CUST_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  DATA : LS_DATA LIKE GS_DATA.
  CLEAR GT_DATA.
    SELECT * FROM ZTJ_CUST INTO CORRESPONDING FIELDS OF TABLE GT_DATA.
    SORT GT_DATA.
ENDFORM.