*&---------------------------------------------------------------------*
*& Include          ZDLDH_RESMAP_F01
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
  CLEAR : GT_RMAP.
    SELECT RESID RESNAME BTYPE BUFNO RSIDE RROW RCOL FROM ZTJ_RESMAP INTO CORRESPONDING FIELDS OF TABLE GT_RMAP.
    SORT GT_RMAP.
ENDFORM.