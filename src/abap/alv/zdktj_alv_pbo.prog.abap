*&---------------------------------------------------------------------*
*& Include          ZDKTJ_ALV_PBO
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

  DATA : GT_ZTJ_BOM LIKE TABLE OF ZTJ_BOM WITH HEADER LINE,
         GT_ZTJ_BOMROUT LIKE TABLE OF ZTJ_BOMROUTING WITH HEADER LINE,
         GT_ZTJ_WORPL LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.

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

  GS_FCAT-FIELDNAME = 'ITEMCODE'.
  GS_FCAT-COLTEXT = '품목 코드'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = '품목명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'UOM'.
  GS_FCAT-COLTEXT = '단위'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'QUANTITY'.
  GS_FCAT-COLTEXT = '수량'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_BOM[]
    FROM ZTJ_BOM
    WHERE MITEMCODE = GS_BOM-MITEMCODE.

  CALL METHOD gc_grid->set_table_for_first_display

    CHANGING
      it_outtab                     = GT_ZTJ_BOM[]
      it_fieldcatalog               = GT_FCAT
*      it_sort                       =
*      it_filter                     =
.

  CLEAR : GT_ZTJ_BOM, GT_ZTJ_BOM[], GT_FCAT.
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

  GS_FCAT-FIELDNAME = 'ITEMCODE'.
  GS_FCAT-COLTEXT = '품목 코드'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'STEP_NO'.
  GS_FCAT-COLTEXT = '스텝 번호'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'OP_NO'.
  GS_FCAT-COLTEXT = '공정 번호'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'ASS_CODE'.
  GS_FCAT-COLTEXT = '조립 번호'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'RES_ID'.
  GS_FCAT-COLTEXT = '창고 번호'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'NEXTSTEP'.
  GS_FCAT-COLTEXT = '다음 스텝'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'DESCRIPTION'.
  GS_FCAT-COLTEXT = '공정 설명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'UOM'.
  GS_FCAT-COLTEXT = '단위'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'INPUT_QT'.
  GS_FCAT-COLTEXT = '투입 수량'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'JSONCODE'.
  GS_FCAT-COLTEXT = 'JSON_CODE'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_BOMROUT
    FROM ZTJ_BOMROUTING
    WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.

  CALL METHOD gc_grid->set_table_for_first_display

    CHANGING
      it_outtab                     = GT_ZTJ_BOMROUT[]
      it_fieldcatalog               = GT_FCAT
*      it_sort                       =
*      it_filter                     =
.
  CLEAR : GT_ZTJ_BOMROUT, GT_ZTJ_BOMROUT[], GT_FCAT.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
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

  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = '모품목명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'DESCRIPTION'.
  GS_FCAT-COLTEXT = '공정 설명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_DATE'.
  GS_FCAT-COLTEXT = '계획 날짜'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_QT'.
  GS_FCAT-COLTEXT = '계획 수량'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_CONFIRM'.
  GS_FCAT-COLTEXT = '계획 실행 여부'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_WORPL
    FROM ZTJ_WORKPLAN
    WHERE MITEMCODE = GS_WORKPL-MITEMCODE.

  CALL METHOD gc_grid->set_table_for_first_display

    CHANGING
      it_outtab                     = GT_ZTJ_WORPL[]
      it_fieldcatalog               = GT_FCAT
*      it_sort                       =
*      it_filter                     =
.
  CLEAR : GT_ZTJ_WORPL, GT_ZTJ_WORPL[], GT_FCAT.
ENDMODULE.
