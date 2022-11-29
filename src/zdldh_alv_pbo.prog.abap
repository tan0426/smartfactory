*&---------------------------------------------------------------------*
*& Include          ZDLDH_ALV_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZDLDH_ALV_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
 SET PF-STATUS 'STATUS200'.
 SET TITLEBAR 'T200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
 SET PF-STATUS 'STATUS300'.
 SET TITLEBAR 'T300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
 SET PF-STATUS 'STATUS400'.
 SET TITLEBAR 'T400'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_alv_0200 OUTPUT.
  DATA : GT_LDH_CUST LIKE TABLE OF ZTJ_CUST WITH HEADER LINE,
         GT_LDH_ITEM LIKE TABLE OF ZTJ_ITEM WITH HEADER LINE,
         GT_LDH_RMAP LIKE TABLE OF ZTJ_RESMAP WITH HEADER LINE.

CREATE OBJECT gc_docking
  EXPORTING
*    parent                      =
    repid                       = SY-REPID
    dynnr                       = SY-DYNNR
*    side                        = DOCK_AT_LEFT
    extension                   = 5000
    .
IF sy-subrc <> 0.
ENDIF.

CREATE OBJECT gc_grid
  EXPORTING
*    i_shellstyle      = 0
*    i_lifetime        =
    i_parent          = GC_DOCKING
*  EXCEPTIONS
    .
IF sy-subrc <> 0.
ENDIF.

GS_FCAT-FIELDNAME = 'ZCODE'.
GS_FCAT-COLTEXT = ' 거래처 코드 '.
APPEND GS_FCAT TO GT_FCAT.
CLEAR GS_FCAT.

GS_FCAT-FIELDNAME = 'ZCNAME'.
GS_FCAT-COLTEXT = ' 거래처 명 '.
APPEND GS_FCAT TO GT_FCAT.
CLEAR GS_FCAT.

SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_LDH_CUST[] FROM ZTJ_CUST WHERE ZCODE = GS_CUST-ZCODE.

CALL METHOD gc_grid->set_table_for_first_display
*  EXPORTING
  CHANGING
    it_outtab                     = GT_LDH_CUST[]
    it_fieldcatalog               = GT_FCAT
*    it_sort                       =
*    it_filter                     =
*  EXCEPTIONS
        .
IF sy-subrc <> 0.
ENDIF.
CLEAR : GT_LDH_CUST, GT_LDH_CUST[], GT_FCAT.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_alv_0300 OUTPUT.
    CREATE OBJECT gc_docking
    EXPORTING
*      parent                      =
      repid                       = SY-REPID
      dynnr                       = SY-DYNNR
*      side                        = DOCK_AT_LEFT
      extension                   = 5000.

  CREATE OBJECT gc_grid
    EXPORTING
*      i_shellstyle      = 0
*      i_lifetime        =
      i_parent          = GC_DOCKING
*      i_appl_events     = SPACE
*      i_parentdbg       =
*      i_applogparent    =
*      i_graphicsparent  =
*      i_name            =
*      i_fcat_complete   = SPACE
*      o_previous_sral_handler =
  .

  GS_FCAT-FIELDNAME = 'ITEM_CODE'.
  GS_FCAT-COLTEXT = ' 품목 코드 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = ' 재료 명 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'ITEM_GROUP'.
  GS_FCAT-COLTEXT = ' 품목군 코드 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

 SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_LDH_ITEM FROM ZTJ_ITEM WHERE ITEM_CODE = GS_ITEM-ITEM_CODE.

  CALL METHOD gc_grid->set_table_for_first_display

    CHANGING
      it_outtab                     = GT_LDH_ITEM[]
      it_fieldcatalog               = GT_FCAT
*      it_sort                       =
*      it_filter                     =
.
  CLEAR : GT_LDH_ITEM, GT_LDH_ITEM[], GT_FCAT.
ENDMODULE.

MODULE display_alv_0400 OUTPUT.
  CREATE OBJECT gc_docking
    EXPORTING
*      parent                      =
      repid                       = SY-REPID
      dynnr                       = SY-DYNNR
*      side                        = DOCK_AT_LEFT
      extension                   = 5000.

  CREATE OBJECT gc_grid
    EXPORTING
*      i_shellstyle      = 0
*      i_lifetime        =
      i_parent          = GC_DOCKING
*      i_appl_events     = SPACE
*      i_parentdbg       =
*      i_applogparent    =
*      i_graphicsparent  =
*      i_name            =
*      i_fcat_complete   = SPACE
*      o_previous_sral_handler =
  .

  GS_FCAT-FIELDNAME = 'RESID'.
  GS_FCAT-COLTEXT = ' 창고 코드 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'RESNAME'.
  GS_FCAT-COLTEXT = ' 창고명 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'BTYPE'.
  GS_FCAT-COLTEXT = ' 버퍼 타입 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'BUFNO '.
  GS_FCAT-COLTEXT = ' 버퍼 개수 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'RSIDE'.
  GS_FCAT-COLTEXT = ' 팔레트 개수 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'RROW'.
  GS_FCAT-COLTEXT = ' 가로 개수 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'RCOL'.
  GS_FCAT-COLTEXT = ' 세로 개수 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

    GS_FCAT-FIELDNAME = 'RSHARE'.
  GS_FCAT-COLTEXT = ' 외부창고 사용여부 '.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_LDH_RMAP FROM ZTJ_RESMAP WHERE RESID = GS_RMAP-RESID.

  CALL METHOD gc_grid->set_table_for_first_display

    CHANGING
      it_outtab                     = GT_LDH_RMAP[]
      it_fieldcatalog               = GT_FCAT
*      it_sort                       =
*      it_filter                     =
.
  CLEAR : GT_LDH_RMAP, GT_LDH_RMAP[], GT_FCAT.
ENDMODULE.
