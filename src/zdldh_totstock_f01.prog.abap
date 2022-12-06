*&---------------------------------------------------------------------*
*& Include          ZDLDH_TOTSTOCK_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_object .
  CREATE OBJECT gc_docking
  EXPORTING
*    parent                      =
    repid                       = SY-REPID
    dynnr                       = SY-DYNNR
*    side                        = DOCK_AT_LEFT
    extension                   = 5000    .
IF sy-subrc <> 0.
ENDIF.

CREATE OBJECT gc_splitter
  EXPORTING
    parent            = GC_DOCKING
    rows              = 1
    columns           = 2
*  EXCEPTIONS
    .
IF sy-subrc <> 0.
ENDIF.

CALL METHOD GC_SPLITTER->GET_CONTAINER
  EXPORTING
    ROW       = 1
    COLUMN    = 1
  RECEIVING
    CONTAINER = GC_CONTAINER_1.

CALL METHOD GC_SPLITTER->GET_CONTAINER
  EXPORTING
    ROW       = 1
    COLUMN    = 2
  RECEIVING
    CONTAINER = GC_CONTAINER_2.

CREATE OBJECT GC_GRID_1
  EXPORTING
*    i_shellstyle      = 0
*    i_lifetime        =
    i_parent          = GC_CONTAINER_1
*  EXCEPTIONS
    .
IF sy-subrc <> 0.
ENDIF.

CREATE OBJECT GC_GRID_2
  EXPORTING
*    i_shellstyle      = 0
*    i_lifetime        =
    i_parent          = GC_CONTAINER_2
*  EXCEPTIONS
    .
IF sy-subrc <> 0.
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIELD_CATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM field_catalog .
  " SPLITTER 1번 "
  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'WAREID'.
  GS_FCAT-COLTEXT = '창고 코드'.
  APPEND GS_FCAT TO GT_FCAT.

  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'ITEM_CODE'.
  GS_FCAT-COLTEXT = '품목 코드'.
  APPEND GS_FCAT TO GT_FCAT.

  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = '품목명'.
  APPEND GS_FCAT TO GT_FCAT.

  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'TOTALQT'.
  GS_FCAT-COLTEXT = '총 수량'.
  APPEND GS_FCAT TO GT_FCAT.

  " SPLITTER 2번 "
  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'ITEM_CODE'.
  GS_FCAT2-COLTEXT = '품목 코드'.
  APPEND GS_FCAT2 TO GT_FCAT2.

  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'COMPONENT'.
  GS_FCAT2-COLTEXT = '품목명'.
  APPEND GS_FCAT2 TO GT_FCAT2.

  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'INQT'.
  GS_FCAT2-COLTEXT = '입고'.
  APPEND GS_FCAT2 TO GT_FCAT2.

  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'OUTQT'.
  GS_FCAT2-COLTEXT = '출고'.
  APPEND GS_FCAT2 TO GT_FCAT2.

  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'RTIME'.
  GS_FCAT2-COLTEXT = '이력'.
  APPEND GS_FCAT2 TO GT_FCAT2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
  CALL METHOD gc_grid_1->set_table_for_first_display
*  EXPORTING
  CHANGING
    it_outtab                     = GT_DATA
    it_fieldcatalog               = GT_FCAT
*  EXCEPTIONS
        .
  IF sy-subrc <> 0.
  ENDIF.

    CALL METHOD gc_grid_2->set_table_for_first_display
*  EXPORTING
  CHANGING
    it_outtab                     = GT_DATA2
    it_fieldcatalog               = GT_FCAT2
*  EXCEPTIONS
        .
  IF sy-subrc <> 0.
  ENDIF.

ENDFORM.
