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
  GS_FCAT-OUTPUTLEN = 15.
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
  GS_FCAT2-OUTPUTLEN = 15.
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

  CLEAR GS_FCAT2.
  GS_FCAT2-FIELDNAME = 'TOTALQT'.
  GS_FCAT2-COLTEXT = '총 수량'.
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
*&---------------------------------------------------------------------*
*& Form ALV_HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM alv_handle_double_click  USING    e_row TYPE LVC_S_ROW
                                       e_column TYPE LVC_S_COL
                                       es_row_no TYPE LVC_S_ROID.

  "한 셀을 선택하면 뜨도록 함.
*  CASE e_column-FIELDNAME.
*    WHEN 'ITEM_CODE'.
**      CLEAR GS_DATA.
*      READ TABLE GT_DATA INTO GS_DATA INDEX ES_ROW_NO-ROW_ID.
*          SELECT * FROM ZTJ_STOCK INTO CORRESPONDING FIELDS OF TABLE GT_DATA2 WHERE ITEM_CODE = GS_DATA-ITEM_CODE.
*            PERFORM REFRESH.
*
*      MESSAGE 'HI' TYPE 'S'.
*   ENDCASE.

  "한 줄 선택 하면 뜨도록 함
  CLEAR GS_DATA.
  READ TABLE GT_DATA INTO GS_DATA INDEX ES_ROW_NO-ROW_ID.
  SELECT * FROM ZTJ_STOCK INTO CORRESPONDING FIELDS OF TABLE GT_DATA2 WHERE ITEM_CODE = GS_DATA-ITEM_CODE.
    PERFORM REFRESH.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EVENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM event .
  CREATE OBJECT GC_EVENT.
  SET HANDLER GC_EVENT->HANDLE_DOUBLE_CLICK FOR GC_GRID_1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh .
  DATA : LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GC_GRID_1->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE     = LS_STABLE
      .
  IF SY-subrc <> 0.
  ENDIF.

      CALL METHOD GC_GRID_2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE     = LS_STABLE
      .
  IF SY-subrc <> 0.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ETC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM etc .
  CALL METHOD GC_GRID_1->SET_READY_FOR_INPUT
    EXPORTING
      I_READY_FOR_INPUT = 1.

  APPEND CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW TO GT_TOOLBAR.

  GS_VARIANT-REPORT   = SY-REPID.
  GS_VARIANT-USERNAME = SY-UCOMM.
ENDFORM.
